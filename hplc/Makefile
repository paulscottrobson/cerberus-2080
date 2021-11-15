ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

.PHONY: all 

all: runtime compiler

runtime:
	make -C runtime

compiler:
	make -C compiler


