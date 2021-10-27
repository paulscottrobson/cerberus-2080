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

// ****************************************************************************
//								Load file in
// ****************************************************************************

WORD16 HWXLoadFile(char * fileName,BYTE8 *target) {
	char fullName[128];
	if (fileName[0] == 0) return 1;
	MKSTORAGE();
	sprintf(fullName,"%sstorage%c%s",SDL_GetBasePath(),FILESEP,fileName);
	FILE *f = fopen(fullName,"rb");
	//printf("%s\n",fullName);
	if (f != NULL) {
		while (!feof(f)) {
			BYTE8 data = fgetc(f);
			*target++ = data;
		}
		fclose(f);
	}
	return (f != NULL) ? 0 : 1;
}

// ****************************************************************************
//							  Load Directory In
// ****************************************************************************

void HWXLoadDirectory(BYTE8 *target) {
	DIR *dp;
	struct dirent *ep;
	char fullName[128];
	MKSTORAGE();
	sprintf(fullName,"%sstorage",SDL_GetBasePath());
	dp = opendir(fullName);
	if (dp != NULL) {
		while (ep = readdir(dp)) {
			if (ep->d_name[0] != '.') {
				char *p = ep->d_name;
				while (*p != '\0') *target++ =*p++;
				*target++ = '\0';
			}
		}
		closedir(dp);
	}
	*target = '\0';
}

// ****************************************************************************
//								Save file out
// ****************************************************************************

WORD16 HWXSaveFile(char *fileName,BYTE8 *data,WORD16 size) {
	char fullName[128];
	MKSTORAGE();
	sprintf(fullName,"%sstorage%c%s",SDL_GetBasePath(),FILESEP,fileName);
	printf("%s\n",fileName);
	FILE *f = fopen(fullName,"wb");
	if (f != NULL) {
		for (int i = 0;i < size;i++) {
			fputc(*data++,f);
		}
		fclose(f);
	}
	return (f != NULL) ? 0 : 1;
}

