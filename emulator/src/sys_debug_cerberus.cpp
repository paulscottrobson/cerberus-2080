// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_debug_cerberus.c
//		Purpose:	Debugger Code (System Dependent)
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons->org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "gfx.h"
#include "sys_processor.h"
#include "debugger.h"
#include "hardware.h"

#define DBGC_ADDRESS 	(0x0F0)														// Colour scheme.
#define DBGC_DATA 		(0x0FF)														// (Background is in main.c)
#define DBGC_HIGHLIGHT 	(0xFF0)

static int renderCount = 0;

#include "debugger_z80.h"
#include "debugger_6502.h"

// *******************************************************************************************************************************
//											This renders the debug screen
// *******************************************************************************************************************************

void DBGXRender(int *address,int showDisplay) {

	int n = 0;
	char buffer[32];
	const char **labels = CPUIsZ80() ? z_labels : c_labels;
	GFXSetCharacterSize(28,24);
	DBGVerticalLabel(21,0,labels,DBGC_ADDRESS,-1);									// Draw the labels for the register

	if (CPUIsZ80()) { 																// Draw registers
		z_showRegisters(address);
	} else {
		c_showRegisters(address);		
	}

	n = 0;
	int a = address[1];																// Dump Memory.
	for (int row = 13;row < 24;row++) {
		GFXNumber(GRID(0,row),a,16,4,GRIDSIZE,DBGC_ADDRESS,-1);
		for (int col = 0;col < 8;col++) {
			GFXNumber(GRID(5+col*3,row),CPUReadMemory(a),16,2,GRIDSIZE,DBGC_DATA,-1);
			a = (a + 1) & 0xFFFF;
		}		
	}

	int p = address[0];																// Dump program code. 
	int opc,osel;
	char *instr,*t;
	char indexReg,code;

	for (int row = 0;row < 12;row++) {
		int isPC = (p == CPUGetPC());												// Tests.
		int isBrk = (p == address[3]);
		GFXNumber(GRID(0,row),p,16,4,GRIDSIZE,isPC ? DBGC_HIGHLIGHT:DBGC_ADDRESS,	// Display address / highlight / breakpoint
																	isBrk ? 0xF00 : -1);
		opc = CPUReadMemory(p++);													// Read opcode.
		if (CPUIsZ80()) {
			instr = (char *)z_mnemonics_0[opc]; 										// Base opcode.
			if (opc == 0xDD || opc == 0xFD) {											// DD/FD shift.
				indexReg = (opc == 0xDD) ? 'X':'Y';
				opc = CPUReadMemory(p++);
				instr = (char *)z_mnemonics_dd[opc];
				if (opc == 0xCB) {
					opc = CPUReadMemory(p+1);
					instr = (char *)z_mnemonics_ddcb[opc];				
				}
			}
			if (opc == 0xED || opc == 0xCB) {
				osel = opc;
				opc = CPUReadMemory(p++);
				instr = (char *)(osel == 0xED ? z_mnemonics_ed[opc] : z_mnemonics_cb[opc]);			
			}
		} else {
			instr = (char *)c_mnemonics_0[opc];
		}

		t = buffer;
		while (*instr != '\0') {
			if (*instr == '$') {
				code = instr[1];
				instr += 2;
				*t = '\0';
				switch(code) {
					case '1':
						sprintf(t,"%02x",CPUReadMemory(p++));t += 2;break;
					case '2':
						sprintf(t,"%02x%02x",CPUReadMemory(p+1),CPUReadMemory(p));p += 2;t += 4;break;
					case 'I':
						*t++ = 'I';*t++ = indexReg;break;
					case 'O':
					case 'S':
						if (code == 'O') {
							opc = CPUReadMemory(p++);
						} else {
							opc = CPUReadMemory(p);							
							p += 2;
						}
						if (opc & 0x80)
							sprintf(t,"-%02x",0x100-opc);
						else
							sprintf(t,"+%02x",opc);
						t = t + strlen(t);
						break;
				}
				
			} else {
				*t++ = *instr++;
			}
		}
		*t = '\0';
		t = buffer;
		while (*t != '\0') {
			*t = tolower(*t);t++;
		}
		GFXString(GRID(5,row),buffer,GRIDSIZE,isPC ? DBGC_HIGHLIGHT:DBGC_DATA,-1);	// Print the mnemonic
	}

	if (showDisplay) {
		int xs = 40;
		int ys = 30;
		int xSize = 3;
		int ySize = 3;
		if (showDisplay) {
			int x1 = WIN_WIDTH/2-xs*xSize*8/2;
			int y1 = WIN_HEIGHT/2-ys*ySize*8/2;
			SDL_Rect r;
			int b = 32;
			r.x = x1-b;r.y = y1-b;r.w = xs*xSize*8+b*2;r.h=ys*ySize*8+b*2;
			GFXRectangle(&r,0x0);
			b = b - 4;
			r.x = x1-b;r.y = y1-b;r.w = xs*xSize*8+b*2;r.h=ys*ySize*8+b*2;
			for (int x = 0;x < xs;x++) 
			{
				for (int y = 0;y < ys;y++)
			 	{
			 		int ch = CPUReadMemory(0xF800+x+y*40);
			 		int xc = x1 + x * 8 * xSize;
			 		int yc = y1 + y * 8 * ySize;
			 		SDL_Rect rc;

					SDL_Rect rcf = rc;

			 		rc.w = xSize;rc.h = ySize;							// Width and Height of pixel.
		 			for (int y = 0;y < 8;y++) {							// 8 Down
		 				rc.x = xc;
		 				rc.y = yc + y * ySize;
		 				int f = CPUReadMemory(ch*8+0xF000+y);
				 		for (int x = 0;x < 8;x++) {						// 8 Across
			 				if (f & 0x80) {		
			 					GFXRectangle(&rc,0xC60);			
			 				}
			 				f <<= 1;
			 				rc.x += xSize;
			 			}
			 		}
			 	}
			}
		}
	}
}	
