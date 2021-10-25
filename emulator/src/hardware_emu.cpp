// ****************************************************************************
// ****************************************************************************
//
//		Name:		hardware_emu.c
//		Purpose:	Hardware Emulation (Emulator Specific)
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ****************************************************************************
// ****************************************************************************

#include "sys_processor.h"
#include "hardware.h"
#include "gfxkeys.h"
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

#include <stdlib.h>
#include "gfx.h"

//
//		Really annoying.
//
#ifdef LINUX
#define MKSTORAGE()	mkdir("storage", S_IRWXU)
#else
#define MKSTORAGE()	mkdir("storage")
#endif

// ****************************************************************************
//								  Sync CPU
// ****************************************************************************

void HWXSyncImplementation(LONG32 iCount) {
}

// ****************************************************************************
//						Get System time in 1/1000s
// ****************************************************************************

LONG32 HWXGetSystemClock(void) {
	return (GFXTimer());
}

// ****************************************************************************
// 						Set frequency of beeper,0 = off
// ****************************************************************************

void HWXSetFrequency(int frequency) {
	GFXSetFrequency(frequency);
}
