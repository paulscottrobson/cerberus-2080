// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		main.c
//		Purpose:	Main program
//		Created:	25th October 2021
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <stdio.h>
#include "gfx.h"
#include "cat.h"
#include "sys_processor.h"
#include "sys_debug_system.h"
#include "debugger.h"

int main(int argc,char *argv[]) {
	DEBUG_RESET();
	DEBUG_ARGUMENTS(argc,argv);
	CatSetup();
	GFXOpenWindow(WIN_TITLE,WIN_WIDTH,WIN_HEIGHT,WIN_BACKCOLOUR);
	GFXStart(argc == 3 || argc == 1);
	CPUEndRun();
	GFXCloseWindow();
	return(0);
}


