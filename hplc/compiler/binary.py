# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		binary.py
#		Purpose :	Binary blob class
#		Date :		15th November 2021
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from runtime import *

# *******************************************************************************************
#
#										Binary Blob class
#
# *******************************************************************************************

class BinaryBlob(object):
	def __init__(self,baseAddress,defaultCode):
		self.code = defaultCode
		self.base = baseAddress
		self.trace = True
	#
	def getBase(self):
		return self.base 
	#
	def getCodeAddress(self):
		return self.base + len(self.code)
	#
	def add(self,v):
		if v < 256:
			self.addByte(v)
		else:
			self.addWord(v)
	#
	def addByte(self,b):
		assert b >= 0 and b < 256
		if self.trace:
			print("${0:04x} : ${1:02x}".format(self.getCodeAddress(),b))
		self.code.append(b)
	#
	def addWord(self,w):
		assert w >= 0 and w < 65536
		if self.trace:
			print("${0:04x} : ${1:04x}".format(self.getCodeAddress(),w))
		self.code.append(w & 0xFF)
		self.code.append(w >> 8)
	#
	def read(self,addr):
		assert addr >= self.base and addr < self.getCodeAddress()
		return self.code[addr-self.base]
	#
	def write(self,addr,b):
		assert b >= 0 and b < 256
		assert addr >= self.base and addr < self.getCodeAddress()
		if self.trace:
			print("${0:04x} : ${1:02x}".format(addr,b))
		self.code[addr-self.base] = b
	#
	def writeBinaryFile(self,fileName = "a80.bin"):
		open(fileName,"wb").write(bytes(self.code))
	#
	def setMainFunction(self,address):
		assert False

# *******************************************************************************************
#
#							Z80 w/Runtime Binary Blob class
#
# *******************************************************************************************

class Z80BinaryBlob(BinaryBlob):
	def __init__(self):
		runtimeCode = HPLCRuntime().getCode()
		BinaryBlob.__init__(self,runtimeCode[1]+runtimeCode[2]*256,runtimeCode)
	#
	def setMainFunction(self,address):
		self.code[0x0A] = address & 0xFF 					# see runtime.lst, overwriting the jump target
		self.code[0x0B] = address >> 8


if __name__ == '__main__':	
	zb = Z80BinaryBlob()
	print(zb.code)
	print(zb.getBase())
	print(zb.getCodeAddress())
	zb.addByte(42)
	zb.addWord(4222)
	zb.add(1)
	zb.add(522)
	zb.writeBinaryFile()
