# *******************************************************************************************************************************
# *******************************************************************************************************************************
#
#      Name:       makeruntime.rb
#      Purpose:    Generates assembler file for runtime.
#      Created:    25th October 2021
#      Author:     Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************************************************
# *******************************************************************************************************************************

start_addr = 0x202
assembler = ["\t.org $202","M8_C_boot:","\tld sp,$F000","\tjp $#{start_addr.to_s(16)}"]
current = nil

(["kernel"] + (ARGV.select {|m| m != "kernel"})).each do |m|
	Dir.glob("#{m}/*.asm").select { |f| not f.index("/_")  }.each do |f|
		open(f).collect { |l| l.rstrip }.each do |l|
			if l[..1] == ";;"
				m = l.match(/^\;\;\s*\[([A-Z]+)\]\s*(.*)\s*$/)
				raise "Syntax #{l}" unless m
				if m[1] == "END"
					assembler.append(current+"_end:")
				elsif m[1] == "CALL" or m[1] == "MACRO"
					s = m[2].downcase.split("").collect {|a| a.match(/[0-9a-z]/) ? a : "_c#{a.ord}_" }.join("")
					current = "M8_"+m[1][0]+"_"+s
					assembler.append(current+":")
				else
					raise "Bad line #{l}"
				end

			else 
				assembler.append l 
			end
		end
	end
end

open("_runtime.asm","w").write(assembler.join "\n")
