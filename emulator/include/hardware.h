// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		hardware.h
//		Purpose:	Hardware Emulation Header
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#ifndef _HARDWARE_H
#define _HARDWARE_H

void HWReset(void);
void HWSync(void);

void HWXSyncImplementation(LONG32 iCount);
LONG32 HWXGetSystemClock(void);
void HWXSetFrequency(int frequency);

#ifdef LINUX
#define FILESEP '/'
#else
#define FILESEP '\\'
#endif

#endif
