ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

EMULATOR = ..$(S)..$(S)emulator$(S)cerberus$(APPSTEM)

all: 
	sjasmplus --lst --raw=sprz80.bin test.asm 
	$(EMULATOR) sprz80.bin go

