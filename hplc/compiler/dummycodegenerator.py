# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		dummycodegenerator.py
#		Purpose :	Fake code generator for debugging compiler
#		Date :		15th November 2021
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from compiler import *

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
	def compileBranch(self,test,address=0):
		brTest = "jmp"
		if test != Compiler.ALWAYS:
			brTest = "jz" if test == Compiler.ZERO else "jnz"
		print("{0:04x} : {2} ${1:04x}".format(self.pc,address,brTest))
		patchAddress = self.pc
		self.pc += 1
		return patchAddress
	#
	def setBranchOffset(self,patchAddress,target):
		print("     : Patch ${0:04x} to branch to ${1:04x}".format(patchAddress,target))
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
	def compileDecrementPush(self):
		print("{0:04x} : dec r0".format(self.pc))
		print("{0:04x} : push r0".format(self.pc+1))
		self.pc += 2
	#
	def compileGetOuterIndex(self):
		print("{0:04x} : pop r0".format(self.pc))
		print("{0:04x} : push r0".format(self.pc+1))
		self.pc += 2
	#
	def compilePop(self):
		print("{0:04x} : pop r0".format(self.pc))
		self.pc += 1
	#
	def compileDebugBreak(self):
		print("{0:04x} : debug".format(self.pc))
		self.pc += 1
	#
	def compileByteData(self,byte):
		print("{0:04x} : byte ${1:02x}".format(self.pc,byte))
		self.pc += 1
	#
	#		Because strings/variables are handled in the preprocessor, these can simply be put in the code without
	#		affecting it, they don't need to be skipped over or anything.
	#
	def allocateString(self,s):
		print("{0:04x} : asciiz \"{1}\"".format(self.strings,s))
		self.strings += len(s) + 1
		return self.strings - (len(s)+1)
	#
	def allocateVariable(self):
		self.variables += 2
		return self.variables-2
	#
