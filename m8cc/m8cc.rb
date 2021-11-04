# *******************************************************************************************************************************
# *******************************************************************************************************************************
#
#      Name:       m8cc.rb
#      Purpose:    M8 Cross Compiler
#      Created:    2nd November 2021
#      Author:     Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************************************************
# *******************************************************************************************************************************

require "./runtime.rb"

# *******************************************************************************************************************************
#
# 													Binary Code Class
#
# *******************************************************************************************************************************

class BinaryCode 
	def initialize 
		@code = RuntimeLibrary.new.getCode.split(",").collect { |a| a.to_i(16) }
		@base_address = @code[4]+(@code[5] << 8)
		@echo = true
	end 
	#
	def read(addr)
		raise "Bad read address $#{addr.to_s(16)}" if addr < @base_address or addr >= @base_address + @code.length
		@code[addr-@base_address]
	end
	#
	def write(addr,data)
		raise "Bad write address $#{addr.to_s(16)}" if addr < @base_address or addr >= @base_address + @code.length
		raise "Bad write data $#{data.to_s(16)}" if data < 0 or data > 255
		@code[addr-@base_address] = data
	end
	#
	def get_base()
		@base_address
	end
	#	
	def get_pc()
		@base_address + @code.length 
	end 
	#
	def add_byte(data)
		raise "Bad add byte data $#{data.to_s(16)}" if data < 0 or data > 255
		puts "#{get_pc.to_s(16)} : #{data.to_s(16)}" if @echo
		@code.append(data)
	end 
	#
	def add_word(data)
		raise "Bad add word data $#{data.to_s(16)}" if data < 0 or data > 65535
		puts "#{get_pc.to_s(16)} : #{data.to_s(16)}" if @echo
		@code.append(data & 0xFF)
		@code.append(data >> 8)
	end
end

# *******************************************************************************************************************************
#
#  												 Dictionary Element Classes
#
# *******************************************************************************************************************************

class DictionaryElement 
	def initialize(name,value)
		@name = name.strip.downcase
		@value = value
	end
	#
	def get_name
		return @name 
	end
	def get_value 
		return @value 
	end 
	#
	def to_s
		return "DICT: #{@name} [#{@value} $#{@value.to_s(16)}]" 
	end
	#
	def compile(bc)
		raise "Compile failed #{self}"
	end
end

class Constant < DictionaryElement
	def compile(bc)
		bc.add_byte(0xEB)  							# EX DE,HL
		bc.add_byte(0x21) 							# LD HL,xxxx
		bc.add_word(@value) 						# xxxx constant
	end
end 

class MemoryReference < DictionaryElement 
end 

class CalledWord < DictionaryElement
	def compile(bc)
		bc.add_byte(0xCD) 							# CALL xxxx
		bc.add_word(@value) 						# xxxx constant
	end
end

class MacroWord < DictionaryElement
	def initialize(name,value,size) 
		super(name,value) 
		raise "Macro size #{name}" if size < 1 or size > 4
		@size = size
	end 
	#
	def get_size 
		return @size end 
	#
	def to_s 
		super + " (#{@size})" 
	end
	#
	def compile(bc)
		(0..@size-1).each { |i| bc.add_byte(bc.read(@value+i))}
	end
end 

class ImmediateWord < DictionaryElement
	def compile(bc)
		raise "Abstract class"
	end
end

# *******************************************************************************************************************************
#
#  															Dictionary
#
# *******************************************************************************************************************************

class Dictionary 
	def initialize 
		@items = {} 
		@last_word = nil
	end 
	#
	def add(element) 
		@last_word = element
		@items[element.get_name] = element
	end
	#
	def get_last
		@last_word
	end
	#
	def get(word_name)
		word_name = word_name.strip.downcase
		@items.key?(word_name) ? @items[word_name] : nil 
	end 
	#
	def to_s 
		@items.collect { |k,e| e.to_s }.join("\n")
	end
	#
	def load_runtime 
		RuntimeLibrary.new.getIndex.split("::") { |a| add create_element(a) }
		self
	end
	#
	def create_element(s1) 
		s = s1.split(",")
		start_addr = s[2][1..].to_i(16)
		end_addr = s[3][1..].to_i(16)
		return CalledWord.new(s[0],start_addr) if s[1] == "C"
		return MacroWord.new(s[0],start_addr,end_addr-start_addr) if s[1] == "M"
		raise "Bad runtime info #{s1}"
	end
end		

# *******************************************************************************************************************************
#
#  														Compiler class
#
# *******************************************************************************************************************************

class Compiler
	def initialize
		@binary = BinaryCode.new
		@dictionary = Dictionary.new.load_runtime 
	end
	#
	# 		Compile a single word.
	#
	def compile_word(word)
		#
		# 		Integer Constants
		#
		return compile_constant word.to_i if word.match(/^[0-9]+$/)
		return compile_constant word[1..].to_i(16) if word.match(/^\$[0-9A-Fa-f]+$/)
		return compile_constant word[1].ord if word.match(/^\'.?\'$/)
		#
		#  		Word in dictionary
		#
		dict_entry = @dictionary.get word
		raise "Unknown word #{word.downcase}" unless dict_entry
		dict_entry.compile @binary
	end 
	#
	def compile_constant(n)
		@binary.add_byte(0xEB)  						# EX DE,HL
		@binary.add_byte(0x21) 							# LD HL,xxxx
		@binary.add_word(n & 0xFFFF) 					# xxxx constant
	end
end


cp = Compiler.new
cp.compile_word "*"
cp.compile_word "break"
cp.compile_word "@"
cp.compile_word "+"
cp.compile_word "42"
cp.compile_word "$abcd"
cp.compile_word "'*'"
cp.compile_word "break"

# string constants
# definitions
