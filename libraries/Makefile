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

LIBRARIES = kernel

.PHONY: all 

all: 
	ruby makeruntime.rb $(LIBRARIES)
	zasm -uwy _runtime.asm -l _runtime.lst -o _runtime.bin
	ruby getruntime.rb 
	
	


