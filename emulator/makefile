ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

APPNAME = cerberus$(APPSTEM)

SOURCES = 	src$(S)sys_processor.o  framework$(S)main.o framework$(S)gfx.o framework$(S)debugger.o \
			src$(S)sys_debug_cerberus.o src$(S)hardware.o src$(S)hardware_emu.o 
  
CC = g++

.PHONY: all clean emulator prebuild

all: emulator

run: emulator 
	.$(S)$(APPNAME) storage$(S)cellz80.bin go

debug: emulator 
	.$(S)$(APPNAME) storage$(S)cellz80.bin 
	
test : emulator
	$(CDEL) memory.dump $(CDELQ)
	zasm -u test.asm
	.$(S)$(APPNAME) test.rom

emulator: prebuild $(APPNAME)

prebuild:
	make -C ..$(S)cpu$(S)z80
	$(CCOPY) ..$(S)cpu$(S)z80$(S)code$(S)*.h cpu$(S)z80

%.o:%.cpp
	$(CC) $(CXXFLAGS) -D INCLUDE_DEBUGGING_SUPPORT -I cpu -I framework -I include -c -o $@ $<

clean:
	$(CDEL) $(APPNAME) 
	$(CDEL) src$(S)*.o 
	$(CDEL) framework$(S)*.o

$(APPNAME): $(SOURCES)
	$(CC) $(SOURCES) $(LDFLAGS) $(SDL_LDFLAGS) -o $@
	

