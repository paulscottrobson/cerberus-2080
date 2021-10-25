// ****************************************************************************
// ****************************************************************************
//
//		Name:		hardware_esp.c
//		Purpose:	Hardware Emulation (ESP32 Specific)
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ****************************************************************************
// ****************************************************************************

#include <Arduino.h>
#include "sys_processor.h"
#include "gfxkeys.h"
#include "hardware.h"
#include "espinclude.h"

// ****************************************************************************
//								Storage type
// ****************************************************************************

char *HWXGetStorageType(void) {
	return (char *)"SPIFFS";
}

// ****************************************************************************
//							  Sync Hardware
// ****************************************************************************


void HWXSyncImplementation(LONG32 iCount) {
}

// ****************************************************************************
//						Get System time in 1/1000s
// ****************************************************************************

LONG32 HWXGetSystemClock(void) {
	return millis();
}

// ****************************************************************************
//	 						Set sound pitch, 0 = off
// ****************************************************************************

void HWXSetFrequency(int frequency) {
	HWESPSetFrequency(frequency);
}

// ****************************************************************************
// 									Load file
// ****************************************************************************

WORD16 HWXLoadFile(char * fName,BYTE8 *target) {
	char fullName[64];
	sprintf(fullName,"/%s",fName);									// SPIFFS doesn't do dirs
	//fabgl::suspendInterrupts();										// And doesn't like interrupts
	WORD16 exists = SPIFFS.exists(fullName);						// If file exitst
	if (exists != 0) {
		File file = SPIFFS.open(fullName);							// Open it
		while (file.available()) {									// Read body in
			BYTE8 b = file.read();
			*target++ = b;
		}
		file.close();
	}
	//fabgl::resumeInterrupts();
	return exists == 0;
}

// ****************************************************************************
//						Directory of SPIFFS root
// ****************************************************************************

void HWXLoadDirectory(BYTE8 *target) {
	//fabgl::suspendInterrupts();
  	File root = SPIFFS.open("/");									// Open directory
   	File file = root.openNextFile();								// Work throughfiles
   	while(file){
       	if(!file.isDirectory()){									// Write non directories out
           	const char *p = file.name();							// Then name
           	while (*p != '\0') {	
           		if (*p != '/') *target++ = *p;
           		p++;
           	}
	       	*target++ = '\0';
       	}
       	file.close();
       	file = root.openNextFile();
   	}
    *target = '\0';
    root.close();
	//fabgl::resumeInterrupts();
}

// ****************************************************************************
//
//							Save file to SPIFFS
//
// ****************************************************************************

WORD16 HWXSaveFile(char *fName,BYTE8 *data,WORD16 size) {
	char fullName[64];
	sprintf(fullName,"/%s",fName);									// No directories or interrupts
	//fabgl::suspendInterrupts();
	File file = SPIFFS.open(fullName,FILE_WRITE);					// Open to write
	WORD16 r = (file != 0) ? 0 : 1;
	if (file != 0) {
		for (int i = 0;i < size;i++) {
			file.write(*data++);
		}
		file.close();
	}
	//fabgl::resumeInterrupts();
	return r;
}


