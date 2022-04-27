# *****************************************************************************
# *****************************************************************************
#
#		Name:		definitions.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		25th October 2021
#		Reviewed: 	No
#		Purpose:	Class for substitute definitions.
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
#
#  								Definition class
#
# *****************************************************************************

class Definition 
	def initialize(spec)
		m = spec.match(/(.*?)\s*\[(.*)\]\s*/)		
		raise "Bad definition #{spec}" if not m
		@name = m[1].strip.downcase
		@shift = nil 
		@subst = []
		m[2].strip.split(",").each_with_index do |e,n| 
			if e[0..5].strip.downcase == "shift:"
				raise "Bad shift "+e if not e[6..e.length-1].match(/^\d$/)
				@shift = e[6..e.length-1].to_i
			elsif e.strip != "_"
				@subst.append (e.include?(":") ? e.strip : e.strip+":"+e.strip).split(":").collect { |a| a.strip }
			else
				@subst.append nil
			end
		end
		self
	end

	def count
		@subst.length
	end

	def name 
		@name 
	end 

	def shift
		@shift
	end 

	def sub(n)
		@subst[n]
	end 

	def to_s
		s = @subst.collect { |s| (s ? s[0]+":"+s[1] : "_") }.join(",")
		"DEF:#{@name} Shift:#{@shift} [#{s}]"
	end
end

# *****************************************************************************
#
# 								Definition dictionary
#
# *****************************************************************************

class Dictionary 
	def initialize
		@dictionary = {}
	end 

	def load(fileName)
		src = open(fileName).select { |a| a[0] != "#"}.join(" ").split("@").collect { |s| s.strip }
		src.select { |s| s != "" }.each do |l|
			entry = Definition.new l
			raise "Duplicate #{entry.name}" if @dictionary.include? entry.name			
			@dictionary[entry.name] = entry
		end
		self
	end 

	def load_default
		Dir.glob('defines/*').select {|f| not f.include? "_"}.each { |f| load(f) }
		self
	end 

	def find(key) 
		key.strip.downcase!
		@dictionary.include?(key) ? @dictionary[key] : nil
	end 

	def to_s
		"Dictionary:\n"+@dictionary.collect { |k,v| "\t"+v.to_s }.join("\n")
	end
end 

if __FILE__ == $0 
	df = Definition.new "nonsense [ Shift:2, B,_,D,E,H,L,(HL):READ8(HL()),A ]"
	puts df,df.name,df.count,df.shift
	(0..df.count-1).each { |n| puts "#{n}:#{df.sub n}" }
	puts "==============="
	dc = Dictionary.new.load("defines/_demo.def")
	puts dc,dc.find("srcreg").to_s,dc.find("xxx") == nil
	puts "==============="
	dw = Dictionary.new.load_default
	puts dw.to_s
end
