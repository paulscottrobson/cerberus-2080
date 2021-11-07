ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

LIBRARIES = kernel xsprites

.PHONY: all 

all: runtime test

runtime:
	make -C ..$(S)libraries
	$(CCOPY) ..$(S)libraries$(S)runtime.rb .

test:
	ruby m8cc.rb
	$(EMULATOR) a80.bin go


