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
		puts(@base_address.to_s(16))
	end 
end

bc = BinaryCode.new

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
	def get_name
		return @name end
	def get_value 
		return @value end 
	def to_s
		return "DICT: #{@name} [#{@value} $#{@value.to_s(16)}]" end
end

class MemoryReference < DictionaryElement 
end 

class Constant < DictionaryElement
end 

class CalledWord < DictionaryElement
end

class MacroWord < DictionaryElement
	def initialize(name,value,size) 
		super(name,value) 
		raise "Macro size #{name}" if size < 1 or size > 4
		@size = size
	end 
	def get_size 
		return @size end 
	def to_s 
		super + " (#{@size})" end
end 

# *******************************************************************************************************************************
#
#  															Dictionary
#
# *******************************************************************************************************************************

class Dictionary 
	def initialize 
		@items = {} 
	end 
	#
	def add(element) 
		@items[element.get_name] = element
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
		raise "Bad runtime #{s1}"
	end
end		

di = Dictionary.new.load_runtime 
de = MacroWord.new("HELLO",1000,4)
di.add de
puts(di.get "hello")		
puts(di.get "hellox")		
puts(di.to_s)
