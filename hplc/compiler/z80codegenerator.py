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
from binary import *

# *******************************************************************************************
#
#									  Z80 opcodes class
#
# *******************************************************************************************

class Z80:	
	pass
Z80.CALL = 0xCD	
Z80.RETURN = 0xC9

Z80.LDI_BC = 0x01
Z80.LDI_DE = 0x11
Z80.LDI_HL = 0x21

Z80.LDM_HL = 0x2A
Z80.LDM_BC = 0xED4B
Z80.LDM_DE = 0xED5B

Z80.STM_HL = 0x22
Z80.STM_BC = 0xED43
Z80.STM_DE = 0xED53

Z80.ADD_HLDE = 0x19
Z80.ADD_HLHL = 0x29

Z80.SRL_H = 0xCB3C
Z80.RR_L = 0xCB1D

Z80.PUSH_HL = 0xE5
Z80.POP_HL = 0xE1
Z80.INC_HL = 0x23
Z80.DEC_HL = 0x2B

# *******************************************************************************************
#
#									Z80 code generator class
#
# *******************************************************************************************

class Z80CodeGenerator(object):
	def __init__(self):
		self.bin = Z80BinaryBlob()
	#	
	# 		Get current program counter
	#
	def getCodeAddress(self):
		return self.bin.getCodeAddress()
	#
	# 		Compile code to call another routine
	#
	def callRoutine(self,addr):
		self.bin.add(Z80.CALL)
		self.bin.addWord(addr)
	#
	# 		Compile a branch, offset may be patched later.
	#
	def compileBranch(self,test,address=0):
		func = "jump"
		if test != Compiler.ALWAYS:
			func = "jump.zero" if test == Compiler.ZERO else "jump.nonzero"
		self.compileSystem(func)
		patch = self.bin.getCodeAddress()
		self.bin.a
		ddByte(0)
		if address != 0:
			self.setBranchOffset(patch,address)
		return patch
	#
	# 		Calculate and write a branch offset.
	#
	def setBranchOffset(self,patchAddress,target):
		offset = target - patchAddress
		if offset < -0x80 or offset > 0x7F:
			raise HPLException("Jump out of range - structure too large")
		self.bin.write(patchAddress,offset & 0xFF)
	#
	# 		Compile code to load, read or write a register
	#
	def accessRegister(self,reg,mode,operand):
		opc = [Z80.LDI_HL,Z80.LDI_DE,Z80.LDI_BC][reg]
		if mode == Compiler.READ:
			opc = [Z80.LDM_HL,Z80.LDM_DE,Z80.LDM_BC][reg]
		if mode == Compiler.WRITE:
			opc = [Z80.STM_HL,Z80.STM_DE,Z80.STM_BC][reg]
		self.bin.add(opc)
		self.bin.addWord(operand)
	#
	# 		Handle unary operations.
	#
	def unaryOperation(self,opcode):
		if opcode == "inc":
			self.binaryOps("add",Compiler.CONST,1)
		if opcode == "dec":
			self.binaryOps("sub",Compiler.CONST,1)
		if opcode == "shl":
			self.bin.add(Z80.ADD_HLHL)
		if opcode == "shr":
			self.bin.add(Z80.SRL_H)
			self.bin.add(Z80.RR_L)
		if opcode == "not":
			self.compileSystem("not")
	#
	# 		Handle calls to system functions.
	#
	def compileSystem(self,func):
		fn = self.bin.find("system."+func)
		if fn is None:
			raise HPLException("Cannot find system.{0}".format(func))
		self.callRoutine(fn)
	#
	# 		Handle binary operations.
	#
	def binaryOperation(self,opcode,mode,operand):
		fn = opcode+".const" if mode == Compiler.CONST else opcode+".var"
		self.compileSystem(fn)
		self.bin.addWord(operand)
	#
	# 		Compile a function return.
	#
	def compileReturn(self):
		self.bin.add(Z80.RETURN)
	#
	# 		Decrement R and push (start of FOR)
	#
	def compileDecrementPush(self):
		self.bin.add(Z80.DEC_HL)
		self.bin.add(Z80.PUSH_HL)
	#
	# 		Pop/Push (INDEX keyword)
	#
	def compileGetOuterIndex(self):
		self.bin.add(Z80.POP_HL)
		self.bin.add(Z80.PUSH_HL)
	#
	# 		Pop Index.
	#
	def compilePop(self):
		self.bin.add(Z80.POP_HL)
	#
	# 		Compile a breakpoint - this is currently $F3 (DI)
	#
	def compileDebugBreak(self):
		self.bin.add(0xF3) 								
	#
	# 		Compile a single byte as data
	#
	def compileByteData(self,byte):
		self.bin.addByte(byte)
	#
	#		Because strings/variables are handled in the preprocessor, these can simply be put in the code without
	#		affecting it, they don't need to be skipped over or anything.
	#
	def allocateString(self,s):
		addr = self.bin.getCodeAddress()
		for c in s:
			self.bin.addByte(ord(c))
		self.bin.addByte(0)
		return addr
	#
	# 		Allocate a 2 byte variable
	#
	def allocateVariable(self):
		addr = self.bin.getCodeAddress()
		self.bin.addWord(0)
		return addr

if __name__ == '__main__':	
	src = """
	int s1
	func main()
		break
		10->s1
		42 -5-s1
	endfunc

	""".split("\n")
	zg = Z80CodeGenerator()
	compiler = Compiler(zg)
	pp = Preprocessor(compiler)
	pp.compileBlock(src)
	zg.bin.setStartFunction(compiler.getStartFunction())
	zg.bin.writeBinaryFile()
