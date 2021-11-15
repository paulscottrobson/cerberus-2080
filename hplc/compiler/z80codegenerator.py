# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		z80codegenerator.py
#		Purpose :	Z80 Code Generator
#		Date :		15th November 2021
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from compiler import *
from preprocessor import *
from error import *

# *******************************************************************************************
#
#									  Z80 opcodes class
#
# *******************************************************************************************

class Z80:	
	pass

# *******************************************************************************************
#
#									Z80 code generator class
#
# *******************************************************************************************

class Z80CodeGenerator(object):
	def __init__(self):
		pass
	#	
	def getCodeAddress(self):
		return 0
	#
	def callRoutine(self,addr):
#		print("{0:04x} : call {1}".format(self.pc,addr))
		pass
	#
	def compileBranch(self,test,address=0):
#		brTest = "jmp"
#		if test != Compiler.ALWAYS:
#			brTest = "jz" if test == Compiler.ZERO else "jnz"
#		print("{0:04x} : {2} ${1:04x}".format(self.pc,address,brTest))
#		patchAddress = self.pc
		pass
#		return patchAddress
	#
	def setBranchOffset(self,patchAddress,target):
#		print("     : Patch ${0:04x} to branch to ${1:04x}".format(patchAddress,target))
		pass
	#
	def accessRegister(self,reg,mode,operand):
#		print("{0:04x} : {1} r{4},{2}${3:04x}".format(self.pc,"str" if mode == Compiler.WRITE else "ldr","#" if mode == Compiler.CONST else "",operand,reg))
		pass
	#
	def unaryOperation(self,opcode):
#		print("{0:04x} : {1}".format(self.pc,opcode))
		pass
	#
	def binaryOperation(self,opcode,mode,operand):
#		print("{0:04x} : {1} {2}${3:04x}".format(self.pc,opcode,"#" if mode == Compiler.CONST else "",operand))
		pass
	#
	def compileReturn(self):
#		print("{0:04x} : retn".format(self.pc))
		pass
	#
	def compileDecrementPush(self):
#		print("{0:04x} : dec r0".format(self.pc))
#		print("{0:04x} : push r0".format(self.pc+1))
		pass
	#
	def compileGetOuterIndex(self):
#		print("{0:04x} : pop r0".format(self.pc))
#		print("{0:04x} : push r0".format(self.pc+1))
		pass
	#
	def compilePop(self):
#		print("{0:04x} : pop r0".format(self.pc))
		pass
	#
	def compileDebugBreak(self):
#		print("{0:04x} : debug".format(self.pc))
		pass
	#
	def compileByteData(self,byte):
#		print("{0:04x} : byte ${1:02x}".format(self.pc,byte))
		pass
	#
	#		Because strings/variables are handled in the preprocessor, these can simply be put in the code without
	#		affecting it, they don't need to be skipped over or anything.
	#
	def allocateString(self,s):
#		print("{0:04x} : asciiz \"{1}\"".format(self.strings,s))
#		self.strings += len(s) + 1
		return 0
	#
	def allocateVariable(self):
#		self.variables += 2
		return 0
	#

if __name__ == '__main__':	
	src = """
	int s1

	func main()
	endfunc

	""".split("\n")
	compiler = Compiler(Z80CodeGenerator())
	pp = Preprocessor(compiler)
	pp.compileBlock(src)

