// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_processor.h
//		Purpose:	Processor Emulation (header)
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#ifndef _PROCESSOR_H
#define _PROCESSOR_H

#define EMU_VERSION 	"1.00"

#define CYCLE_RATE 		(3250*1000)													// Cycles per second (3.25Mhz)

#define RAMSIZE 		(0x10000)													// Max memory in PC version (including ROM space)

typedef unsigned short WORD16;														// 8 and 16 bit types.
typedef unsigned char  BYTE8;
typedef unsigned int   LONG32;														// 32 bit type.

#define DEFAULT_BUS_VALUE (0xFF)													// What's on the bus if it's not memory.

#define AKEY_BACKSPACE	(0x5F)														// Apple Backspace

BYTE8 CPUIsZ80(void);
void CPUEnable(BYTE8 isOn);
void CPUSetZ80(BYTE8 isZ80);
void CPUReset(void);
BYTE8 CPUExecuteInstruction(void);
BYTE8 CPUReadMemory(WORD16 address);
void CPUWriteMemory(WORD16 address,BYTE8 data);
WORD16 CPUGetPC(void);
void CPUSetPC(WORD16 newPC);
void CPULoadBinary(char *fileName);

#ifdef INCLUDE_DEBUGGING_SUPPORT													// Only required for debugging

typedef struct __CPUSTATUSZ80 {
	int AF,BC,DE,HL;
	int AFalt,BCalt,DEalt,HLalt;
	int IE,PC,SP,IX,IY,cycles;
} CPUSTATUSZ80;

typedef struct __CPUSTATUS6502 {
	int A,X,Y,S,ST,PC;
	int cycles;
} CPUSTATUS6502;

CPUSTATUSZ80 *CPUGetStatusZ80(void);
CPUSTATUS6502 *CPUGetStatus6502(void);
BYTE8 CPUExecute(WORD16 breakPoint1,WORD16 breakPoint2);
WORD16 CPUGetStepOverBreakpoint(void);
void CPUEndRun(void);
void CPUExit(void);

#endif
#endif