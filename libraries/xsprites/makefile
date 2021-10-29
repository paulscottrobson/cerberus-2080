ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

EMULATOR = ..$(S)..$(S)emulator$(S)cerberus$(APPSTEM)

all: build
	$(EMULATOR) sprz80.bin go

build: test.asm 
	zasm -u test.asm  -l test.lst -o sprz80.bin
