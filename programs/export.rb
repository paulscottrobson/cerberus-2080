# *****************************************************************************
# *****************************************************************************
#
#		Name:		export.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		30th September 2021
#		Reviewed: 	No
#		Purpose:	Export ROM image
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
#
#  					Class encapsulating standard ROM
#
# *****************************************************************************

class StandardROM
	def initialize(binary_file)
		@data = open(binary_file,"rb").each_byte.collect { |a| a }
	end 

	def export_include(include_file)
		bytes = @data.collect { |b| b.to_s }.join(",")
		open(include_file,"w").write(bytes+"\n")
		self
	end

	def export_binary(binary_file) 
		h = open(binary_file,"wb")
		@data.each { |b| h.write(b.chr) }
		self 
	end
end

class TextROM < StandardROM
	def initialize(binary_file)
		super
		puts(@data.length)
		@data = @data.collect { |a| a.chr }.join("").split().collect { |a| a.to_i }
	end 
end 

if __FILE__ == $0 
	StandardROM.new("chardefs.bin").export_include("_char_data.h")
	TextROM.new("cerbicon.img").export_include("_img_data.h")
end

