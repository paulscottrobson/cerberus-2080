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
							"++":"inc","--":"dec","<<":"shl",">>":"shr",
							"~":"not"
		}
	#
	# 		List of keywords that won't be used as variables
	#
	def getKeywords(self):
		return "int,func,endfunc,if,then,else,endif,while,wend,repeat,until,for,next,break,case,when,endcase,default,true,false".split(",")
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
		#print("CODEBLOCK:"+c)
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
		# 			Call a function.
		#
		if head == Preprocessor.CALLMARKER:
			self.next()
			self.compileFunctionCall()
			return
		#
		# 		Binary operator check.
		#
		if head in self.binaryOps:																	# is it a binary operator ?
			self.compileBinaryOperator()
			return
		#
		#		Unary operator
		#
		if head in self.unaryOps:
			self.codeGenerator.unaryOperation(self.unaryOps[head])
			self.next()
			return
		#
		# 		Special keywords BREAK TRUE FALSE ;
		#
		if head == "BREAK" or head == "TRUE" or head == "FALSE" or head == ";":
			self.next()
			if head == "BREAK":
				self.codeGenerator.compileDebugBreak()
			if head == "TRUE" or head == "FALSE":
				self.codeGenerator.accessRegister(0,Compiler.CONST,0xFFFF if head == "TRUE" else 0)
			return
		#
		# 		All other keywords (structures)
		#
		if head.isalpha():
			self.compileStructures()
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
		if operator == Compiler.CONST or int(value) != 0xFFFF: 										# If not var $FFFF (_)
			self.codeGenerator.accessRegister(register,operator,int(value))							# generate the code.
	#
	# 		Function call compiler
	#
	def compileFunctionCall(self):
		addr = int(self.get())																		# get and skip address
		self.next()
		self.check("(","Missing ( on function call") 												# check next is (
		paramCount = 0
		while self.get() != ")":																	# while parameters
			self.compileLoadValue(paramCount)														# parameter, can only be var or const.
			paramCount += 1
			nextToken = self.get()
			if nextToken != "," and nextToken != ")":												# check syntax
				raise HPLException("Syntax error in function call")
			if nextToken == ",": 																	# skip ,
				self.next()
		self.next()																					# skip )
		self.codeGenerator.callRoutine(addr)														# code to call function.
	#
	# 		Binary operator code
	#
	def compileBinaryOperator(self):
		head = self.get()
		opcode = self.binaryOps[head]																# command to do.
		self.next() 																				# skip
		value = self.get() 																			# get operand and skip it.
		self.next()
		mode = Compiler.CONST 																		# and mode 
		if value == Preprocessor.VARMARKER:															# is it [VAR]addr
			value = self.get() 																		# get and skip operand
			self.next()	
			mode = Compiler.READ 																	# it's read memory.
		if not value.isdigit():																		# missing var/const
			raise HPLException("Missing constant/variable in binary operation")
		if opcode == "str":																			# gazinta is different.
			if mode == Compiler.CONST:
				raise HPLException("Cannot gazinta constant")
			self.codeGenerator.accessRegister(0,Compiler.WRITE,int(value))
		else:
			self.codeGenerator.binaryOperation(opcode,mode,int(value))
	#
	# 		Structure compilers
	#
	def compileStructures(self):
		kwd = self.get() 																			# get the structure word.
		self.next()
		if kwd == "REPEAT":
			self.pushStack("REPEAT",{ "loop":self.codeGenerator.getCodeAddress() })
		if kwd == "UNTIL":
			loopAddress = self.popStack("REPEAT")["loop"]
			self.compileCondition()
			self.codeGenerator.compileBranch(Compiler.ZERO,loopAddress)
	#
	# 		Compile a condition
	#
	def compileCondition(self):
		self.check("(","Missing ( in test") 														# check ( of condition
		while self.get() != ")":																	# compile code in test until )
			self.compileOneItem()
			if self.isEmpty():
				raise HPLException("Missing ) in test")
		self.next() 																				# skip closing )
	# 
	# 		Push on structure stack
	#
	def pushStack(self,marker,info):
		info["marker"] = marker
		self.compileStack.append(info)
	#
	# 		Pop/Check structure stack
	#
	def popStack(self,marker):
		if self.compileStack[-1]["marker"] != marker:
			raise HPLException("Missing {0} in structures".format(marker.lower()))
		return self.compileStack.pop()
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
	# 		Check next token and skip
	#
	def check(self,token,message):
		if self.get() != token:
			raise HPLException(message)
		self.next()
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

Compiler.ZERO = 3
Compiler.NONZERO = 4
Compiler.ALWAYS = 5

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
	def callRoutine(self,addr):
		print("{0:04x} : call {1}".format(self.pc,addr))
		self.pc += 1
	#
	def compileBranch(self,test,address):
		brTest = "jmp"
		if test != Compiler.ALWAYS:
			brTest = "jz" if test == Compiler.ZERO else "jnz"
		print("{0:04x} : {2} {1}".format(self.pc,address,brTest))
		self.pc += 1
	#
	def accessRegister(self,reg,mode,operand):
		print("{0:04x} : {1} r{4},{2}${3:04x}".format(self.pc,"str" if mode == Compiler.WRITE else "ldr","#" if mode == Compiler.CONST else "",operand,reg))
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
	#
	def compileDebugBreak(self):
		print("{0:04x} : debug".format(self.pc))
		self.pc += 1

if __name__ == '__main__':	
	src = """
	int s1


	func main()
		int c 4->c
		repeat c -- ->c until (c == 0)
	endfunc

	""".split("\n")
	compiler = Compiler(DummyCodeGenerator())
	pp = Preprocessor(compiler)
	pp.compileBlock(src)

#
#	TODO: 	While, For, If then write library and Z80 Code Generator
#			@ operator