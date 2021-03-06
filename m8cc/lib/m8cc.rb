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

require "runtime.rb"

# *******************************************************************************************************************************
#
# 														Error class
#
# *******************************************************************************************************************************

class M8Exception < StandardError
	@@file = ""
	@@line = 0

	def self.restart(file_name)
		@@file = file_name
		@@line = 1
	end

	def self.bump
		@@line += 1
	end

	def message 
		super + " #{@@file}:#{@@line}"
	end
end 

# *******************************************************************************************************************************
#
# 													Binary Code Class
#
# *******************************************************************************************************************************

class BinaryCode 
	def initialize 
		@code = RuntimeLibrary.new.getCode.split(",").collect { |a| a.to_i(16) }
		@base_address = @code[4]+(@code[5] << 8)
		@echo = false
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
	#
	def remove_bytes(c)
		(0..c-1).each { |n| @code.pop }
	end
	#
	def set_start(addr)
		@code[4] = addr & 0xFF
		@code[5] = addr >> 8
	end
	#
	def write_binary(file_name = "a80.bin")
		h = open(file_name,"wb")
		@code.each { |b| h.write(b.chr) }
		h.close
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
	def compile(bc,dict)
		raise "Compile failed #{self}"
	end
end

class Constant < DictionaryElement
	def compile(bc,dict)
		bc.add_byte(0xEB)  							# EX DE,HL
		bc.add_byte(0x21) 							# LD HL,xxxx
		bc.add_word(@value) 						# xxxx constant
	end
end 

class MemoryReference < DictionaryElement 
end 

class CalledWord < DictionaryElement
	def compile(bc,dict)
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
	def compile(bc,dict)
		(0..@size-1).each { |i| bc.add_byte(bc.read(@value+i))}
	end
end 

# *******************************************************************************************************************************
#
#  														  Action words
#
# *******************************************************************************************************************************

class ImmediateWord < DictionaryElement
	def compile(bc,dict)
		raise "Abstract class"
	end
end

# *******************************************************************************************************************************
#
# 													Load and save adjusters
#
# *******************************************************************************************************************************

class LoadModifier < ImmediateWord  
	def compile(bc,dict)
		raise M8Exception.new("Bad load modifier") unless bc.read(bc.get_pc-3) == 0x21  			# Check LD hl,xxxxx
		bc.write(bc.get_pc-3,0x2A) 																	# Replace with LD hl,(xxxx)
	end
end

class SaveModifier < ImmediateWord  
	def compile(bc,dict)
		raise M8Exception.new("Bad load modifier") unless bc.read(bc.get_pc-3) == 0x21  			# Check LD hl,xxxxx
		bc.write(bc.get_pc-4,0x22) 																	# Replace with LD hl,(xxxx), no EX DE,HL
		bc.write(bc.get_pc-3,bc.read(bc.get_pc-2))
		bc.write(bc.get_pc-2,bc.read(bc.get_pc-1))
		bc.remove_bytes(1) 																			# drop the last 
	end
end

# *******************************************************************************************************************************
#
# 													Variable/Constant/Arrays
# :const 42 constant
# :var variable
# :array 420 array
#
# *******************************************************************************************************************************

class ConstantHandler < ImmediateWord
	def compile(bc,dict)
		raise M8Exception.new("Missing constant value") unless bc.read(bc.get_pc-3) == 0x21 		# check constant compiled
		value = bc.read(bc.get_pc-2) + bc.read(bc.get_pc-1) * 256  									# get value
		bc.remove_bytes(4) 																			# undo it
		dict.add Constant.new(dict.get_last.get_name,value) 										# overwrite definition.
	end 
end 

class VariableHandler < ImmediateWord
	def compile(bc,dict)
		size = get_data_size(bc,dict) 																# get bytes to reserve
		address = bc.get_pc 																		# variable address
		(0..size-1).each { |b| bc.add_byte 0 }  													# reserve them.
		dict.add Constant.new(dict.get_last.get_name,address) 										# define variable 
	end 
	#
	def get_data_size(bc,dict)
		2
	end
end

class ArrayHandler < VariableHandler
	def get_data_size(bc,dict) 
		raise M8Exception.new("Missing array size") unless bc.read(bc.get_pc-3) == 0x21 			# check constant compiled as array size
		value = bc.read(bc.get_pc-2) + bc.read(bc.get_pc-1) * 256  									# get value
		bc.remove_bytes(4) 																			# undo it
		raise M8Exception.new("Array size ?") if bc.get_pc + value >= 0x10000  						# basic validation
		value 
	end 
end

# *******************************************************************************************************************************
#
# 														For/Next Loop Handlers
#
# *******************************************************************************************************************************

class ForHandler < ImmediateWord
	@@address = 0
	def compile(bc,dict)
		if get_value == 0 
			bc.add_byte(0x2B) 																		# dec HL
			@@address = bc.get_pc 																	# get loop position.
			bc.add_byte(0xE5) 																		# Push HL			
		else 
			dict.get("next.handler").compile(bc,dict) 												# Compile next code handler.
			back = bc.get_pc - @@address 															# loop back amount from offset pos
			raise M8Exception.new("For loop too large") if back >= 0x100  							# too far.
			bc.add_byte back 																		# compile back branch.
			@@address = 0 																			# unused address
		end
	end
end 

# *******************************************************************************************************************************
#
# 														  Repeat Handler
#
# *******************************************************************************************************************************

class RepeatHandler < ImmediateWord
	@@address = 0
	def compile(bc,dict)
		if get_value == 0  																			# REPEAT
			@@address = bc.get_pc 																	# get loop position.
		else  																						# UNTIL or -UNTIL or FOREVER
			ctrl = get_value < 0 ? "brpos.bwd":"brzero.bwd"											# get check.
			ctrl = "br.bwd" if get_value == 2 														# handle FOREVER
			dict.get(ctrl).compile(bc,dict) 														# Compile until/-until
			back = bc.get_pc - @@address 															# loop back amount from offset pos
			raise M8Exception.new("repeat loop too large") if back >= 0x100  						# too far.
			bc.add_byte back 																		# compile back branch.
			@@address = 0 																			# unused address
		end
	end
end

# *******************************************************************************************************************************
#
# 													If/-If Else Then Handler
#
# *******************************************************************************************************************************

class IfHandler < ImmediateWord
	@@address = 0
	def compile(bc,dict)
		if get_value.abs == 1  																		# IF/-IF
			ctrl = get_value < 0 ? "brpos.fwd":"brzero.fwd"											# get check.
			dict.get(ctrl).compile(bc,dict) 														# Compile until/-until
			@@address = bc.get_pc 																	# get branch forward position
			bc.add_byte 0 																			# dummy branch
		elsif get_value == 2 																		# ELSE
			dict.get("br.fwd").compile(bc,dict) 													# compile branch forward over else block
			new_addr = bc.get_pc 																	# new address to patch and dummy branch
			bc.add_byte 0 
			fwd = bc.get_pc - @@address 															# how far we have to go forward to skip to else clause
			raise M8Exception.new("if test too large") if fwd >= 0x100  							# too far.
			bc.write(@@address,fwd) 																# patch the forward branch			
			@@address = new_addr 																	# this is the new addresss to patch
		else 				 																		# THEN
			fwd = bc.get_pc - @@address 															# how far we have to go forward.
			raise M8Exception.new("if test too large") if fwd >= 0x100  							# too far.
			bc.write(@@address,fwd) 																# patch the forward branch
		end
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
		@modules_loaded = {}
		@boot_words = []
		immediate_words
	end 
	#
	# 		Load immediate words
	#
	def immediate_words
		@dictionary.add LoadModifier.new("@@",-1)
		@dictionary.add SaveModifier.new("!!",-1)
		@dictionary.add ConstantHandler.new("constant",-1)
		@dictionary.add VariableHandler.new("variable",-1)
		@dictionary.add ArrayHandler.new("array",-1)
		@dictionary.add ForHandler.new("for",0)
		@dictionary.add ForHandler.new("next",1)
		@dictionary.add RepeatHandler.new("repeat",0)
		@dictionary.add RepeatHandler.new("until",1)
		@dictionary.add RepeatHandler.new("-until",-1)
		@dictionary.add RepeatHandler.new("forever",2)
		@dictionary.add IfHandler.new("if",1)
		@dictionary.add IfHandler.new("-if",-1)
		@dictionary.add IfHandler.new("else",2)
		@dictionary.add IfHandler.new("then",3)
	end
	#
	# 		Compile a file 
	#
	def compile_file(file_name)
		if File.file? file_name
			src = open(file_name)
			compile_block(src,file_name)
		else
			puts("Cannot load file #{file_name}")
			exit(false)
		end
		self
	end
	#
	# 		Compile an array of lines/line
	#
	def compile_block(block,file_name = "(Body)")
		M8Exception.restart file_name
		begin
			block.each do|b|
				m = b.match(/^require\s*\"(.*?)\"$/) 
				if m 
					req_file = m[1]
					req_file += ".m8" unless req_file[-3..] == ".m8"
					unless @modules_loaded.key? req_file
						@modules_loaded[req_file] = true 
						compile_file req_file
					end
				else
					compile_line b
				end
				M8Exception.bump
			end
		rescue M8Exception => e 
			puts(e.message)
			exit(false)
		end
		self
	end
	#
	# 		Compile a single line
	#
	def compile_line(line)
		return self if line.strip[0..1] == "//"
		line = line[..line.index("//")-1] if line.include?("//") 
		line.split { |w| compile_word w if w != "" }
		self
	end
	#
	# 		Compile a single word.
	#
	def compile_word(word)
		#
		# 		Colon Definition
		#
		return compile_definition word[1..] if word[0] == ":"
		#
		#  		String constant
		#
		return compile_string word[1..-2] if word[0] == '"' and word[-1] == '"'
		#
		# 		Integer Constants
		#
		return compile_constant word.to_i if word.match(/^[0-9]+$/)
		return compile_constant word[1..].to_i(16) if word.match(/^\$[0-9A-Fa-f]+$/)
		return compile_constant word[1].ord if word.match(/^\'.?\'$/)
		#
		#  		Raw data
		#
		return compile_data word[1..-2].strip if word[0] == '[' and word [-1] == ']'
		#
		#  		Word in dictionary
		#
		dict_entry = @dictionary.get word
		raise M8Exception.new("Unknown word #{word.downcase}") unless dict_entry
		dict_entry.compile @binary,@dictionary
	end 
	#
	# 		Compile code to load constant
	#
	def compile_constant(n)
		@binary.add_byte(0xEB)  						# EX DE,HL
		@binary.add_byte(0x21) 							# LD HL,xxxx
		@binary.add_word(n & 0xFFFF) 					# xxxx constant
	end
	#
	# 		Compile a new definition
	#
	def compile_definition(word)
		word_def = CalledWord.new(word,@binary.get_pc)
		@boot_words.append(word_def) if word[-5..] == ".boot"
		@dictionary.add(word_def)
	end
	#
	# 		Compile a string
	#
	def compile_string(text)
		@dictionary.get("string.inline").compile(@binary,@dictionary)
		text.gsub("_"," ").each_char { |c| @binary.add_byte(c.ord) }
		@binary.add_byte(0)
	end
	#
	# 		Compile hexadecimal data
	#
	def compile_data(bytes)
		while bytes != ""
			raise M8Exception.new("Bad data construct") if bytes.length == 1
			hex = bytes[0..1]
			raise M8Exception.new("Bad hexadecimal data") unless hex.match(/[0-9a-fA-F]+/)
			@binary.add_byte hex.to_i(16)
			bytes = bytes[2..].strip
		end
	end
	#
	#  		Compile main
	#
	def compile_boot_word
		@binary.set_start(@binary.get_pc) 						# Set start address
		@boot_words.each { |w| w.compile(@binary,@dictionary) } # compile all boots
		@dictionary.get_last.compile(@binary,@dictionary) 		# start from last word
		@binary.add_byte 0x76 									# halt
	end
	#
	# 		Write Binary file out
	#
	def write_binary(file_name = "a80.bin")
		@binary.write_binary(file_name)
	end
end

class M8CC
	def compile(argv)
		cp = Compiler.new
		if argv.length == 0
			puts("m8cc <source file list>")
			puts("\tWritten by Paul Robson November 2021")
			exit(false)
		end
		argv.each { |f| cp.compile_file f }
		cp.compile_boot_word
		cp.write_binary
	end
end
			