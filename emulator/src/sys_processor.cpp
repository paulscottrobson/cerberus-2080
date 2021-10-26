// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_processor.cpp
//		Purpose:	Processor Emulation.
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <stdio.h>
#include <string.h>
#include "sys_processor.h"
#include "sys_debug_system.h"
#include "hardware.h"
#include "cat.h"

// *******************************************************************************************************************************
//														   Timing
// *******************************************************************************************************************************

static int cpuClock = 4*1024*1024; 													// 4Mhz Clock.
#define FRAME_RATE		(50)														// Frames per second (50Hz)
#define CYCLES_PER_FRAME (cpuClock / FRAME_RATE) 									// Cycles per frame.

// *******************************************************************************************************************************
//														CPU / Memory
// *******************************************************************************************************************************

static BYTE8 runZ80 = 1; 															// non zero Z80 on, zero 6502 on
static BYTE8 cpuIsRunning = 1; 														// non zero if CPU not in halt.
static BYTE8 forceRun = 0; 															// Force direct execution.

static BYTE8 A,B,C,D,E,H,L,X,Y,S; 													// Standard register
static WORD16 AFalt,BCalt,DEalt,HLalt; 												// Alternate data set.
static WORD16 PC,SP; 																// 16 bit registers
static WORD16 IX,IY; 																// IX IY accessed indirectly.

static BYTE8 s_Flag,z_Flag,c_Flag,h_Flag,n_Flag,p_Flag,b_Flag,d_Flag; 				// Flag Registers
static BYTE8 I,R,intEnabled; 														// We don't really bother with these much.

static BYTE8 ramMemory[0x10000];													// Memory at $0000 upwards

static LONG32 temp32;
static WORD16 temp16,temp16a,*pIXY;
static BYTE8 temp8,oldCarry;
static int frameCount = 0;

static int cycles;																	// Cycle Count.
static WORD16 cyclesPerFrame = CYCLES_PER_FRAME;									// Cycles per frame

#define CYCLES(n) cycles -= (n)

// *******************************************************************************************************************************
//											 Memory and I/O read and write macros.
// *******************************************************************************************************************************

#define READ8(a) 	_Read(a)														// Basic Read
#define WRITE8(a,d)	_Write(a,d)														// Basic Write

#define READ16(a) 	(READ8(a) | ((READ8((a)+1) << 8)))								// Read 16 bits.
#define WRITE16(a,d) { WRITE8(a,(d) & 0xFF);WRITE8((a)+1,(d) >> 8); } 				// Write 16 bits

#define FETCH8() 	ramMemory[PC++]													// Fetch byte
#define FETCH16()	_Fetch16()	 													// Fetch word

static inline BYTE8 _Read(WORD16 address);											// Need to be forward defined as 
static inline void _Write(WORD16 address,BYTE8 data);								// used in support functions.

#define INPORT(p) 		(0xFF) 														// No port functionality.
#define OUTPORT(p,d) 	{}

// *******************************************************************************************************************************
//											   Read and Write Functions
// *******************************************************************************************************************************

static inline BYTE8 _Read(WORD16 address) {
	return ramMemory[address];							
}

static void _Write(WORD16 address,BYTE8 data) {
	ramMemory[address] = data;
}

static inline WORD16 _Fetch16(void) {
	WORD16 w = ramMemory[PC] + ((ramMemory[PC+1]) << 8);
	PC += 2;
	return w;
}


// *******************************************************************************************************************************
//											 Support macros and functions
// *******************************************************************************************************************************

void CPUSetClock(int mhz) {
	cpuClock = mhz * 1024 * 1024;
}

void CPUEnable(BYTE8 isOn) {
	cpuIsRunning = isOn;
	forceRun = 0;
}

void CPUSetZ80(BYTE8 isZ80) {
	runZ80 = isZ80;
}

BYTE8 CPUIsZ80(void) {
	return runZ80;
}

#ifdef INCLUDE_DEBUGGING_SUPPORT
#include <stdlib.h>
#define FAILOPCODE(g,n) exit(fprintf(stderr,"Opcode %02x in group %s %x\n",n,g,PC))
#else
#define FAILOPCODE(g,n) {}
#endif

#include "z80_cpu_support.h"

WORD16 CPUGetPC(void) {
	return PC;
}

void CPUSetPC(WORD16 newPC) {
	PC = newPC;
}

// *******************************************************************************************************************************
//														Reset the CPU
// *******************************************************************************************************************************

void CPUReset(void) {
	HWReset();																		// Reset Hardware
	if (CPUIsZ80()) {
		BuildParityTable();															// Build the parity flag table.
		PC = 0; 																	// Zero PC.
	} else {
		// TODO: 6502 Reset
	}
	cycles = CYCLES_PER_FRAME;
}

// *******************************************************************************************************************************
//					Called on exit, does nothing on ESP32 but required for compilation
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
#include "gfx.h"
void CPUExit(void) {	
	printf("Exited via $FFFF");
	GFXExit();
}
#else
void CPUExit(void) {}
#endif

// *******************************************************************************************************************************
//												Execute a single instruction
// *******************************************************************************************************************************

BYTE8 CPUExecuteInstruction(void) {
	#ifdef INCLUDE_DEBUGGING_SUPPORT
	if (PC == 0xFFFF) CPUExit();
	#endif
	if (cpuIsRunning || forceRun) {
		BYTE8 opcode = FETCH8();													// Fetch opcode.
		if (CPUIsZ80()) {
			switch(opcode) {														// Execute it.
				#include "z80/_code_group_0.h"
				default:
					FAILOPCODE("-",opcode);
			}
		} else {
			switch(opcode) {														// Execute it.
				// TODO: 6502 Execute one instruction
				default:
					FAILOPCODE("-",opcode);
			}
		}
	} else { 																		// If CPU not running end this frame.
		cycles = -1;
	}
	if (cycles >= 0 ) return 0;														// Not completed a frame.
	cycles = cyclesPerFrame;														// Adjust this frame rate, up to x16 on HS
	HWSync();																		// Update any hardware
	CatSync();
	frameCount++;
	return FRAME_RATE;																// Return frame rate.
}

// *******************************************************************************************************************************
//												Read/Write Memory
// *******************************************************************************************************************************

BYTE8 CPUReadMemory(WORD16 address) {
	return READ8(address);
}

void CPUWriteMemory(WORD16 address,BYTE8 data) {
	WRITE8(address,data);
}

// *******************************************************************************************************************************
//											Load in a binary (for debugging)
// *******************************************************************************************************************************

void CPULoadBinary(char *fileName) {
	FILE *f = fopen(fileName,"rb");
	if (f != NULL) {
		fread(ramMemory+0x202,0x10000-0x202,1,f);
		fclose(f);	
	}
	forceRun = -1;
}

// *******************************************************************************************************************************
//															NMI
// *******************************************************************************************************************************

void CPUInterrupt(void) {
	if (CPUIsZ80()) {
		if (READ8(PC) == 0x76) PC++;
		PUSH(PC);PC = 0x38;
	} else {
		// TODO: 6502 NMI.
	}
}

#ifdef INCLUDE_DEBUGGING_SUPPORT

// *******************************************************************************************************************************
//		Execute chunk of code, to either of two break points or frame-out, return non-zero frame rate on frame, breakpoint 0
// *******************************************************************************************************************************

BYTE8 CPUExecute(WORD16 breakPoint1,WORD16 breakPoint2) { 
	BYTE8 next;
	do {
		BYTE8 r = CPUExecuteInstruction();											// Execute an instruction
		if (r != 0) return r; 														// Frame out.
		next = CPUReadMemory(PC);
	} while (PC != breakPoint1 && PC != breakPoint2 && next != 0x40);				// Stop on breakpoint or $40 LD B,B break
	return 0; 
}

// *******************************************************************************************************************************
//									Return address of breakpoint for step-over, or 0 if N/A
// *******************************************************************************************************************************

WORD16 CPUGetStepOverBreakpoint(void) {
	BYTE8 op = CPUReadMemory(PC); 	
	if (CPUIsZ80()) {
		if (op == 0xCD || (op & 0xC7) == 0xC4) return PC+3; 						// CALL/CALL xx
		if ((op & 0xC7) == 0xC7) return PC+1;										// RST
	} else {
		if (op == 0x20) return PC+3; 												// JSR xx	
	}
	return 0;																		// Do a normal single step
}

void CPUEndRun(void) {
	FILE *f = fopen("memory.dump","wb");
	fwrite(ramMemory,1,RAMSIZE,f);
	fclose(f);
}

// *******************************************************************************************************************************
//											Retrieve a snapshot of the processor
// *******************************************************************************************************************************

static CPUSTATUSZ80 st;																	// Status area
static CPUSTATUS6502 st2;

CPUSTATUSZ80 *CPUGetStatusZ80(void) {
	st.AF = AF();
	st.BC = BC();
	st.DE = DE();
	st.HL = HL();
	st.AFalt = AFalt;
	st.BCalt = BCalt;
	st.DEalt = DEalt;
	st.HLalt = HLalt;
	st.PC = PC;
	st.SP = SP;
	st.IX = IX;
	st.IY = IY;
	st.IE = intEnabled;
	st.cycles = cycles;
	return &st;
}

CPUSTATUS6502 *CPUGetStatus6502(void) {
	st2.cycles = cycles;
	return &st2;
}

#endif