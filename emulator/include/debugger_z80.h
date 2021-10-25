// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		debugger_z80.h
//		Purpose:	Debugger Code (CPU Dependent)
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons->org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

static const char *z_mnemonics_0[256] = {
	#include "z80/_mnemonics_group_0.h"
};
static const char *z_mnemonics_cb[256] = {
	#include "z80/_mnemonics_group_cb.h"
};
static const char *z_mnemonics_dd[256] = {
	#include "z80/_mnemonics_group_dd.h"
};
static const char *z_mnemonics_ed[256] = {
	#include "z80/_mnemonics_group_ed.h"
};
static const char *z_mnemonics_ddcb[256] = {
	#include "z80/_mnemonics_group_ddcb.h"
};

static const char * z_labels[] = { "A","F","","BC","DE","HL","IX","IY","SP","PC","BK","CY",NULL };


static void z_showRegisters(int *address) {
	CPUSTATUSZ80 *s = CPUGetStatusZ80();
	const char *sr = "SZ-H-PNC";
	int i,n = 0;

	#define DNZ(v,w) GFXNumber(GRID(24,n++),v,16,w,GRIDSIZE,DBGC_DATA,-1)			// Helper macro
	#define DNZ2(v,w) GFXNumber(GRID(29,n++),v,16,w,GRIDSIZE,DBGC_DATA,-1)

	DNZ(s->AF>>8,2);DNZ(s->AF & 0xFF,2);n++;
	DNZ(s->BC,4);DNZ(s->DE,4);DNZ(s->HL,4);DNZ(s->IX,4);DNZ(s->IY,4);
	DNZ(s->SP,4);DNZ(s->PC,4);DNZ(address[3],4);DNZ(s->cycles,4);
	n = 0;
	DNZ2(s->AFalt,4);n += 2;DNZ2(s->BCalt,4);DNZ2(s->DEalt,4);DNZ2(s->HLalt,4);

	for (int i = 0;i < 8;i++) {
		int set = (s->AF & (0x80 >> i));
		GFXCharacter(GRID(24+i,2),sr[i],GRIDSIZE,set ? 0xFF0 : 0x800,-1);
	}
	GFXCharacter(GRID(24+5,1),'I',GRIDSIZE,s->IE ? 0xFF0 : 0x800,-1);
}