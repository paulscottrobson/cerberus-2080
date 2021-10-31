# *******************************************************************************************************************************
# *******************************************************************************************************************************
#
#      Name:       getruntime.rb
#      Purpose:    Get runtime library information from listing file.
#      Created:    31st October 2021
#      Author:     Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************************************************
# *******************************************************************************************************************************

words = {}

open("_runtime.lst").select {|a| a[0..2] == "M8_" }.each do |s|
	m = s.match(/M8_([MC])_(.*?)\s*\=\s*\$([0-9a-fA-F]+)/)
	raise "Listing format changed ? #{s}" unless m
	#
	type = m[1]
	word_name = m[2]
	address = m[3].to_i(16)
	section = "S"
	if word_name[-4..] == "_end"
		section = "E"
		word_name = word_name[..-5]
	end
	word_name = word_name.gsub (/\_c[0-9]+\_/) { |a| a[2..-2].to_i.chr }
	word_name.upcase!
	#puts "#{type} #{word_name} #{section} #{address.to_s(16)}"
	words[word_name] = { "name"=>word_name,"type"=>type,"S"=>0,"E"=>0 } unless words.key? word_name
	words[word_name][section] = address
end
words = words.collect { |k,v| "#{k},#{v["type"]},$#{v["S"].to_s(16)},$#{v["E"].to_s(16)}" }.join("::")
code = open("_runtime.bin","rb").each_byte	.collect { |a| a.ord.to_s(16) }.join(",")

h = open("runtime.rb","w")
h.write("class RuntimeLibrary\n")
h.write("\tdef getIndex\n\t\treturn \"#{words}\"\n\tend\n\n")
h.write("\tdef getCode\n\t\treturn \"#{code}\"\n\tend\n\n")
h.write("end\n")