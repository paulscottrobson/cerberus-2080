# *****************************************************************************
# *****************************************************************************
#
#		Name:		generate.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		25th October 2021
#		Reviewed: 	No
#		Purpose:	Generate include files
#
# *****************************************************************************
# *****************************************************************************

require "./definitions.rb"
require "./storage.rb"

# *****************************************************************************
#
#  			Generator
#
# *****************************************************************************

class Generator
	def initialize
		@dictionary = Dictionary.new.load_default
		@stores = {}
	end 

	def run
		Dir.glob('source/*').each do |f| 
			load_process(f).each { |d| load_definition d } unless f.include?("_")
		end 
		self
	end

	def load_process(f)
		src = open(f).select { |l| l[0] != '#' and l.strip() != "" }.collect { |l| l.gsub("\t"," ") }
		src = src.collect {|l| l[0] == ' ' ? l.strip : "|||"+l.strip }.join " "
		src.split("|||").collect { |l| l.strip }.select { |l| l != "" }
	end

	def load_definition(d)
		m = d.match(/([0-9a-fA-F]+)\s*\"(.*?)\"\s*(\d+)\s*(.*)/)
		raise "Bad definition '#{d}'" if not m
		opcode = m[1].to_i(16)
		base_opcode = opcode & 0xFFFFFF00
		@stores[base_opcode] = CodeStore.new(base_opcode,@dictionary) unless @stores.include? base_opcode
		@stores[base_opcode].add(opcode,[m[2],m[4],m[3].to_i])
	end

	def export
		@stores.each { |k,v| v.export }
	end
end 

if __FILE__ == $0 
	gen = Generator.new.run.export
end



