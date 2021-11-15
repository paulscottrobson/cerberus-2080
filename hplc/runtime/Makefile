ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

.PHONY: all 

all: runtime

runtime:
	zasm -u -w -b runtime.asm
	python makeruntime.py
	$(CCOPY) runtime.py ..$(S)compiler

