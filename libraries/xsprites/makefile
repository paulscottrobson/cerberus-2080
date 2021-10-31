ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

EMULATOR = ..$(S)..$(S)emulator$(S)cerberus$(APPSTEM)

all: build
	$(EMULATOR) sprz80.bin go

build: _test.asm xsprite.asm
	zasm -u _test.asm  -l test.lst -o sprz80.bin

demo: _demo.asm xsprite.asm
	zasm -u _demo.asm  -l demo.lst -o sprz80.bin
	$(EMULATOR) sprz80.bin go
