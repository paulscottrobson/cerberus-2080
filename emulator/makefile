ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

VERSION = "1_00"

APPNAME = cerberus$(APPSTEM)

SOURCES = 	src$(S)sys_processor.o  framework$(S)main.o framework$(S)gfx.o framework$(S)debugger.o \
			src$(S)sys_debug_cerberus.o src$(S)hardware.o src$(S)hardware_emu.o src$(S)cat.o
  
CC = g++

.PHONY: all clean emulator prebuild release run debug test run65 debug65

all: emulator

release: emulator
	$(CDEL) ..$(S)release$(S)cerberus_$(VERSION)_$(OSNAME).zip $(CDELQ)
	$(CCOPY) ..$(S)documents$(S)readme.txt .
	zip -r ..$(S)release$(S)cerberus_$(VERSION)_$(OSNAME).zip $(APPNAME) storage readme.txt $(EXTRAFILES)

run: emulator 
	.$(S)$(APPNAME) storage$(S)cellz80.bin go

debug: emulator 
	.$(S)$(APPNAME) storage$(S)cellz80.bin 

run65: emulator 
	.$(S)$(APPNAME) storage$(S)cell6502.bin go

debug65: emulator 
	.$(S)$(APPNAME) storage$(S)cell6502.bin 
	
test : emulator
	.$(S)$(APPNAME) 

emulator: prebuild $(APPNAME)

prebuild:
	make -C ..$(S)programs
	make -C ..$(S)cpu$(S)z80
	make -C ..$(S)cpu$(S)6502
	$(CCOPY) ..$(S)cpu$(S)z80$(S)code$(S)*.h cpu$(S)z80
	$(CCOPY) ..$(S)cpu$(S)6502$(S)*.h cpu$(S)6502

%.o:%.cpp
	$(CC) $(CXXFLAGS) -D INCLUDE_DEBUGGING_SUPPORT -I cpu -I framework -I include -c -o $@ $<

clean:
	$(CDEL) $(APPNAME) 
	$(CDEL) src$(S)*.o 
	$(CDEL) framework$(S)*.o

$(APPNAME): $(SOURCES)
	$(CC) $(SOURCES) $(LDFLAGS) $(SDL_LDFLAGS) -o $@
	

