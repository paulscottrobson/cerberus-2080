ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

.PHONY: all 

all: 
	$(CCOPY) ..$(S)z80$(S)*.rb .
	ruby generate.rb