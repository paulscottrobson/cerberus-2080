# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		compiler.py
#		Purpose :	Preprocessor class
#		Date :		13th November 2021
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import re
from preprocessor import *
from error import *

# *******************************************************************************************
#
#									Compiler Class
#
# *******************************************************************************************

class Compiler:
	def __init__(self,codeGenerator):
		self.codeGenerator = codeGenerator
		self.twoParam = { 
							">=":True, "=>":True, "->":True, "==":True,"<>":True,
							"++":True, "--":True, ">>":True, "<<":True
		}
		self.binaryOps = { 	
							"+":"add","-":"sub","*":"mlt","/":"div","&":"and","|":"or","^":"xor",
							">=":"tge","==":"teq","!=":"tne","<":"tlt",
							"=>":"str","->":"str"
		}
		self.unaryOps = {
							"++":"inc","--":"dec","<<":"shl",">>":"shr"
		}
	#
	# 		List of keywords that won't be used as variables
	#
	def getKeywords(self):
		return "int,func,endfunc,if,then,else,endif,while,wend,repeat,until,for,next,break,case,when,endcase,default".split(",")
	#
	#		Write out the parameters to the addresses in the array at the start of the routine
	#
	def compileSaveParameters(self,params):
		for i in range(0,len(params)):
			self.codeGenerator.accessRegister(i,Compiler.WRITE,params[i])
	#
	#		Compile a whole function
	#
	def compileFunction(self,c):
		print("CODEBLOCK:"+c)
		self.compileStack = [] 																		# Compiler stack
		self.source = c.strip() 																	# Data source
		while (not self.isEmpty()): 																# Compile body
			self.compileOneItem()
		self.codeGenerator.compileReturn() 															# Return
		if len(self.compileStack) > 0:
			raise HPLException("Structure still open") 												# Check everything closed.
	#
	# 		Compile one single item.
	#
	def compileOneItem(self):
		head = self.get() 																			# what is up front ?
		#
		#		Various checks .....
		#			CALLing functions with _
		#			Structure handler

		#
		# 		Binary operator check.
		#
		if head in self.binaryOps:																	# is it a binary operator ?
			opcode = self.binaryOps[head]															# command to do.
			self.next() 																			# skip
			value = self.get() 																		# get operand and skip it.
			self.next()
			mode = Compiler.CONST 																	# and mode 
			if value == Preprocessor.VARMARKER:														# is it [VAR]addr
				value = self.get() 																	# get and skip operand
				self.next()
				mode = Compiler.READ 																# it's read memory.
			if not value.isdigit():																	# missing var/const
				raise HPLException("Missing constant/variable in binary operation")
			if opcode == "str":																		# gazinta is different.
				if mode == Compiler.CONST:
					raise HPLException("Cannot gazinta constant")
				self.codeGenerator.accessRegister(0,Compiler.WRITE,int(value))
			else:
				self.codeGenerator.binaryOperation(opcode,mode,int(value))
			return
		#
		#		Unary operator
		#
		if head in self.unaryOps:
			self.codeGenerator.unaryOperation(self.unaryOps[head])
			self.next()
			return
		#
		# 		Must be a constant or a variable.
		#
		self.compileLoadValue(0)																	# Must be [var]addr or constant
	#
	# 		Should be a simple value, either a variable access or a constant, compile code to load it.
	#		
	def compileLoadValue(self,register):
		value = self.get()  																		# get the value.
		self.next()
		operator = Compiler.CONST 
		if value == Preprocessor.VARMARKER:															# is it [VMRK] address
			value = self.get() 																		# get and skip address
			self.next()
			operator = Compiler.READ
		if not value.isdigit():																		# if not digit, simply wrong.
			raise HPLException("Syntax Error")
		self.codeGenerator.accessRegister(register,operator,int(value))								# generate the code.
	#
	#		Get current first element
	#
	def get(self):
		self.skipLineMarkers()

		if self.source[0].isalnum() and ord(self.source[0]) < 128: 									# alphanumeric element (Python bug ?)
			return re.match("^([0-9A-Za-z]+)",self.source).group(1)

		if self.source[0:2] in self.twoParam: 														# 2 character punctuation
			return self.source[0:2]

		return "" if self.source == "" else self.source[0] 											# 1 character punctuation
	#
	# 		Goto next element
	#
	def next(self):
		self.source = self.source[len(self.get()):].strip()
		return self
	#
	# 		Return true if nothing left to get
	#
	def isEmpty(self):
		self.skipLineMarkers()
		return self.source == ""
	#
	# 		Skip line markers
	#
	def skipLineMarkers(self):
		while self.source.startswith(Preprocessor.LINESEP): 										# Handle seperators, bumping line number.
			self.source = self.source[1:].strip()
			HPLException.LINE += 1
	# 
	# 		Allocate space for a variable
	#
	def allocateVariable(self):
		return self.codeGenerator.allocateVariable()
	#
	# 		Allocate space for a string
	#
	def allocateString(self,s):
		return self.codeGenerator.allocateString(s)
	#
	# 		Get current PC address.
	#
	def getCodeAddress(self):
		return self.codeGenerator.getCodeAddress()

Compiler.READ = 0 							# Code Generation ReadMem,WriteMem,Const
Compiler.WRITE = 1
Compiler.CONST = 2

# *******************************************************************************************
#
#									Dummy code generator
#
# *******************************************************************************************

class DummyCodeGenerator(object):
	def __init__(self):
		self.pc = 4096
		self.variables = 40960
		self.strings = 32768
	#	
	def getCodeAddress(self):
		return self.pc 
	#
	def accessRegister(self,reg,mode,operand):
		print("{0:04x} : {1} {2}${3:04x}".format(self.pc,"str" if mode == Compiler.WRITE else "ldr","#" if mode == Compiler.CONST else "",operand))
		self.pc += 1
	#
	def unaryOperation(self,opcode):
		print("{0:04x} : {1}".format(self.pc,opcode))
		self.pc += 1
	#
	def binaryOperation(self,opcode,mode,operand):
		print("{0:04x} : {1} {2}${3:04x}".format(self.pc,opcode,"#" if mode == Compiler.CONST else "",operand))
		self.pc += 1
	#
	def compileReturn(self):
		print("{0:04x} : retn".format(self.pc))
		self.pc += 1
	#
	def allocateVariable(self):
		self.variables += 2
		return self.variables-2
	#
	def allocateString(self,s):
		print("{0:04x} : asciiz \"{1}\"".format(self.strings,s))
		self.strings += len(s) + 1
		return self.strings - (len(s)+1)

if __name__ == '__main__':	
	src = """
	int s1
	func t1(xxx,y,z)
		"hello" +4 *xxx => s1 ++ => y _
	endfunc

	""".split("\n")
	compiler = Compiler(DummyCodeGenerator())
	pp = Preprocessor(compiler)
	pp.compileBlock(src)


