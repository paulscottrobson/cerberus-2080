ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

.PHONY: all 

all: 
	ruby export.rb
	$(CCOPY) *.h ..$(S)emulator$(S)include
