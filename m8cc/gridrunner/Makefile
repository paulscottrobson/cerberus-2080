ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

all: build run

system:
	make -C ..
	
build:
	m8cc gridrunner.m8

run:
	..$(S)$(EMULATOR) a80.bin go


