ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

LIBRARIES = kernel xsprites

.PHONY: all 

all: runtime gem test

runtime:
	make -C ..$(S)libraries
	$(CCOPY) ..$(S)libraries$(S)runtime.rb .

gem : runtime 
	gem build m8cc.gemspec
	gem install ./m8cc-1.0.0.gem
	
test:
	m8cc demo.m8
	$(EMULATOR) a80.bin go


