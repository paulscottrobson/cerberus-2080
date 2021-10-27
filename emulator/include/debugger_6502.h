// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		debugger_6502.h
//		Purpose:	Debugger Code (CPU Dependent)
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons->org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

static const char * c_labels[] = { "A","X","Y","S","ST","","PC","BK","CY",NULL };

static const char *c_mnemonics_0[256] = {
	#include "6502/_mnemonics_group_0.h"
};

static void c_showRegisters(int *address) {
	CPUSTATUS6502 *s = CPUGetStatus6502();

	const char *sr = "NV1BDIZC";
	int i,n = 0;

	#define DNC(v,w) GFXNumber(GRID(24,n++),v,16,w,GRIDSIZE,DBGC_DATA,-1)			// Helper macro
	#define DNC2(v,w) GFXNumber(GRID(29,n++),v,16,w,GRIDSIZE,DBGC_DATA,-1)

	DNZ(s->A,2);DNZ(s->X,2);DNZ(s->Y,2);DNZ(s->S,2);DNZ(s->ST,2);
	n++;
	DNZ(s->PC,4);DNZ(address[3],4);DNZ(s->cycles,4);


	for (int i = 0;i < 8;i++) {
		int set = (s->ST & (0x80 >> i));
		GFXCharacter(GRID(24+i,5),sr[i],GRIDSIZE,set ? 0xFF0 : 0x800,-1);
	}
}
