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
from dummycodegenerator import *

# *******************************************************************************************
#
#									Compiler Class
#
# *******************************************************************************************

class Compiler:
	def __init__(self,codeGenerator):
		self.codeGenerator = codeGenerator
		self.lastFunction = None
		self.twoParam = { 
							">=":True, "=>":True, "->":True, "==":True,"<>":True,
							"++":True, "--":True, ">>":True, "<<":True
		}
		self.binaryOps = { 	
							"+":"add","-":"sub","*":"mlt","/":"div","%":"mod",
							"&":"and","|":"or","^":"xor",
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
		return "int,func,endfunc,if,else,endif,while,wend,repeat,until,for,next,break,case,when,endcase,default,true,false,index".split(",")
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
		self.lastFunction = self.codeGenerator.getCodeAddress()
		self.source = self.source.replace("@"+Preprocessor.VARMARKER,"") 							# Converts @<var><addr> to just <addr>
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
		# 		Ignores ; which is syntactic sugar
		#
		if head == ";":
			return
		#
		# 		Data block
		#
		if head == "[":
			self.compileDataBlock()
			return
		#	
		# 		All other keywords (structures and others)
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
		#
		if kwd == "UNTIL":
			loopAddress = self.popStack("REPEAT")["loop"]
			self.compileCondition()
			self.codeGenerator.compileBranch(Compiler.ZERO,loopAddress)
		#
		if kwd == "FOR":
			self.compileCondition() 																# actually a constant here
			self.pushStack("FOR",{ "loop":self.codeGenerator.getCodeAddress() })
			self.codeGenerator.compileDecrementPush()
		#
		if kwd == "NEXT":
			loopAddress = self.popStack("FOR")["loop"]
			self.codeGenerator.compilePop()
			self.codeGenerator.compileBranch(Compiler.NONZERO,loopAddress)
		#
		if kwd == "WHILE":
			loopAddress = self.codeGenerator.getCodeAddress()
			self.compileCondition() 														
			branchPatch = self.codeGenerator.compileBranch(Compiler.ZERO)
			self.pushStack("WHILE",{ "loop":loopAddress, "patch":branchPatch })
		#
		if kwd == "WEND":
			info = self.popStack("WHILE")
			self.codeGenerator.compileBranch(Compiler.ALWAYS,info["loop"])
			self.codeGenerator.setBranchOffset(info["patch"],self.getCodeAddress())
		#
		if kwd == "IF":
			self.compileCondition() 															
			branchPatch = self.codeGenerator.compileBranch(Compiler.ZERO)
			self.pushStack("IF",{ "patch":branchPatch })
		#
		if kwd == "ELSE":
			elseBranchPatch = self.codeGenerator.compileBranch(Compiler.ALWAYS)
			self.codeGenerator.setBranchOffset(self.popStack("IF")["patch"],self.codeGenerator.getCodeAddress())			
			self.pushStack("IF",{ "patch":elseBranchPatch })
		#
		if kwd == "ENDIF":
			self.codeGenerator.setBranchOffset(self.popStack("IF")["patch"],self.codeGenerator.getCodeAddress())			
		#
		if kwd == "BREAK":
			self.codeGenerator.compileDebugBreak()
		#
		if kwd == "TRUE":
			self.codeGenerator.accessRegister(0,0xFFFF)
		#
		if kwd == "FALSE":
			self.codeGenerator.accessRegister(0,0)
		#
		if kwd == "INDEX":
			self.codeGenerator.compileGetOuterIndex()
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
		if len(self.compileStack) == 0 or self.compileStack[-1]["marker"] != marker:
			raise HPLException("Missing {0} in structures".format(marker.lower()))
		return self.compileStack.pop()
	#
	# 		Compile a data block. In octal so the preprocessor leaves it alone.
	#
	def compileDataBlock(self):
		self.next()
		block = self.get()
		if re.match("^[0-7]+$",block) is None or len(block) % 3 != 0:
			raise HPLException("Bad data block")
		for i in range(0,len(block),3):
			self.codeGenerator.compileByteData(int(block[i:i+3],8))
		self.next()
		self.check("]","Missing ] on data block")
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
	# 		Get last defined function which starts it
	#
	def getStartFunction(self):
		return self.lastFunction
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

if __name__ == '__main__':	
	src = """
	int s1

	func main()
		int c @c -> c index
		[040137] 
	endfunc

	""".split("\n")
	compiler = Compiler(DummyCodeGenerator())
	pp = Preprocessor(compiler)
	pp.compileBlock(src)

