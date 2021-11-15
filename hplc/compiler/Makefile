ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

.PHONY: all 

all: 
	make -C ../runtime
	python z80codegenerator.py
	../../emulator/cerberus a80.bin go

