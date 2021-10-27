ifeq ($(OS),Windows_NT)
CCOPY = copy
CMAKE = make
CDEL = del /Q
S = \\
else
CCOPY = cp
CDEL = rm -f
CMAKE = make
S = /
endif

.PHONY: all 

all: _6502opcodes.h

_6502opcodes.h : process.py 6502.def
	python process.py
	


