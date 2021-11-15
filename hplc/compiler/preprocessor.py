# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		preprocessor.py
#		Purpose :	Preprocessor class
#		Date :		13th November 2021
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import re
from error import *

# *******************************************************************************************
#
#									Preprocessor Class
#
# *******************************************************************************************

class Preprocessor(object):
	def __init__(self,compiler):
		self.compiler = compiler
		self.locals = {}
		self.globals = { "_":0xFFFF } 																	# _ is universal do nothing in params.
		self.keywords = compiler.getKeywords()
	#
	# 		Compile a block passed as a list of strings
	#	
	def compileBlock(self,src):
		src = [x if x.find("//") < 0 else x[:x.find("//")] for x in src] 								# remove comments
		src = Preprocessor.LINESEP.join(src).replace("\t"," ")											# Handle tabs, glue together
		src = re.split("(func\\s+"+Preprocessor.IDENT+"\\(.*?endfunc)",src)								# split into chunks, globals and functions

		for s in src:																					# do each chunk.
			isGlobal = not s.startswith("func")									 						# func or global space.
			#
			#		Global area, only comments , semicolons and global <v>,<v>,<v> allowed
			#
			if isGlobal:
				s = self.processBlock(s,True) 															# process for globals
				s = s.replace(" ","").replace(";","")													# remove spaces and semicolons
				for c in s: 																			# check remainder are line seps
					if c != Preprocessor.LINESEP: 
						raise HPLException("Code in global declaration")
				HPLException.LINE += len(s)																# adjust position in file.
			#
			#		func <name>([<params>]) ..... endfunc
			#
			else: 		
				self.locals = {} 																		# Forget all locals.																							
				m = re.match("^func\\s+("+Preprocessor.IDENT+")\\((.*?)\\)(.*)endfunc$",s) 				# chop function into bits.
				if m is None:
					raise HPLException("Syntax error")
				newFunc = m.group(1).lower()+"(" 														# name of function
				if newFunc in self.globals:																# already known
					raise HPLException("Duplicate function name {0}".format(newFunc))
				params = [x for x in m.group(2).strip().split(",") if x.strip() != ""]					# parameters ?
				for i in range(0,len(params)): 															# for each parameter.
					if re.match("^"+Preprocessor.IDENT+"$",params[i]) is None:							# check it's a valid name.
						raise HPLException("Bad identifier "+params[i])
					params[i] = self.createVariable(params[i].lower(),False) 							# Convert to an address
				body = self.processBlock(m.group(3),False)												# preprocess main body
				self.globals[newFunc] = self.compiler.getCodeAddress()				 					# record function address.
				if len(params) > 0: 																	# code to store parameters passed
					self.compiler.compileSaveParameters(params)
				self.compiler.compileFunction(body)														# compile body of function
		self.stripUnderscore()
	#
	# 		Do all processing
	#
	def processBlock(self,s,isGlobal):
		s = self.processStrings(s)																		# handle strings.
		s = self.processConstants(s)																	# handle constants
		s = self.processDeclarations(s,isGlobal)														# handle INT
		s = self.processIdentifiers(s) 																	# handle variables/func calls
		return s	
	#
	# 		Extract quoted strings out and replace with constant values
	#
	def processStrings(self,s):
		s = re.split("(\".*?\")",s)																		# split up into strings.
		for i in range(0,len(s)): 																		# for each bit
			if s[i].startswith('"') and s[i].endswith('"'): 											# if quoted string
				s[i] = str(self.compiler.allocateString(s[i][1:-1])) 									# convert to string in memory.
		return "".join(s)
	#
	#		Convert hexadecimal $[Hex] and character constants '<character>' to integers
	#
	def processConstants(self,s):
		s = re.split("(\\$[0-9A-fa-f]+)",s)																# hex constants first
		for i in range(0,len(s)):
			if re.match("^\\$[0-9A-fa-f]+$",s[i]) is not None:
				s[i] = str(int(s[i][1:],16))
		s = re.split("(\\'.\\')","".join(s))															# character constants
		for i in range(0,len(s)):
			if s[i].startswith("'") and s[i].endswith("'") and len(s[i]) == 3:
				s[i] = str(ord(s[i][1]))		
		return "".join(s)
	#
	#		Look for INT <varlist>, create variables and chop out.
	#
	def processDeclarations(self,s,isGlobal):
		s = re.split("(int\\s+"+Preprocessor.IDENT_LIST+")",s)
		for i in range(0,len(s)):
			if s[i].startswith("int"):
				for newVar in [x for x in s[i][3:].lower().strip().split(",") if x.strip() != ""]:
					if re.match(Preprocessor.IDENT,newVar) is None:
						raise HPLException("Bad int declaration")
					tgt = self.globals if isGlobal else self.locals
					if newVar in tgt:
						raise HPLException("Duplicate integer variable "+newVar)
					tgt[newVar] = self.compiler.allocateVariable()
				s[i] = ""
		return "".join(s)
	#
	# 		Replace identifiers with function calls or variable references.
	#
	def processIdentifiers(self,s):
		s = re.split("("+Preprocessor.IDENT+"\\(?)",s)													# split with optional (
		for i in range(0,len(s)):
			if re.match(Preprocessor.IDENT+"\\(?",s[i].lower()):
				s[i] = self.identToValue(s[i])
		return "".join(s)
	#
	# 		Identifier to value
	#
	def identToValue(self,id):
		id = id.strip().lower() 																		# preprocess
		#
		# 		Keywords
		#
		if id in self.keywords: 																		# keywords returned in capitals.
			return id.upper()
		#
		# 		Function calls
		#
		if id.endswith("("):
			if id not in self.globals:																	# check globals for function
				raise HPLException("Unknown function {0}".format(id[:-1]))
			return "{0}{1}(".format(Preprocessor.CALLMARKER,self.globals[id])							# add call marker
		#
		# 		Variable references
		#
		srctab = self.locals if id in self.locals else self.globals 									# where to look
		if id in srctab: 																				# already known
			return "{0}{1}".format(Preprocessor.VARMARKER,srctab[id])
		raise HPLException("Unknown identifier {0}".format(id))
	#
	#		Create a new variable, local or global
	#
	def createVariable(self,name,isGlobal):
		name = name.strip().lower()
		value = self.compiler.allocateVariable()
		if isGlobal:
			self.globals[name] = value 
		else:
			self.locals[name] = value
		return value
	#
	# 		Remove all globals beginning with _ except _ itself
	#
	def stripUnderscore(self):
		for k in list(self.globals.keys()):
			if k != "_" and k.startswith("_"):
				del self.globals[k]

Preprocessor.LINESEP = chr(449) 						# double bar is line seperator.
Preprocessor.VARMARKER = chr(415) 						# 0 wih line through is variable.
Preprocessor.CALLMARKER = chr(643)						# Integral is call marker

Preprocessor.IDENT = "[A-Za-z\\_][A-Za-z0-9\\.\\_]*"	# Regex for identifier (accurate)
Preprocessor.IDENT_LIST = "[A-Za-z0-9\\.\\_\\,]+" 		# Regex for list of identifiers (approx,checked)

# *******************************************************************************************
#
#								Fake for testing preprocessor
#
# *******************************************************************************************

class DummyCompiler:
	def __init__(self):
		self.varSpace = 16384
		self.strSpace = 60000
	#
	def getKeywords(self):
		return "int,func,endfunc,if,then,else,endif,while,wend,repeat,until,for,next,break,case,when,endcase,default".split(",")
	#
	def compileSaveParameters(self,params):
		print("[SAVE] {0}".format(",".join([str(n) for n in params])))
	#
	def compileFunction(self,c):
		print("[CODE] {0}".format(c))
	#
	def allocateVariable(self):
		self.varSpace += 2
		return self.varSpace-2
	#
	def allocateString(self,s):
		print("[CSTR] \"{0}\"@{1}".format(s,self.strSpace))
		p = self.strSpace
		self.strSpace += len(s)+1
		return p
	#
	def getCodeAddress(self):
		return 0x9870+self.varSpace-0xA000

if __name__ == '__main__':	
	src = """
	// Hello world
	int a,b,c

	func _t1()
	endfunc

	func test(x,y) 
		while if endif
		int z,w;
		z = "Hello";
		x = "demo"
	endfunc

	int w,z;

	func test.main(b,c) 
		a = w;
		b = 99
		c = $2A
		int d
		d = '*'+d
		test(42)
	endfunc
	""".split("\n")
	pp = Preprocessor(DummyCompiler())
	pp.compileBlock(src)
	print(pp.globals)

