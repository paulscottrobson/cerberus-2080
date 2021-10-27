Notes
=====
Prebuild executables are in directory "release"

Build Requirements
	gcc, SDL2, ruby, make

Windows 
	mingw make (from chocolatey)
	c:\SDL2 needs to be the 64 bit development directory from the SDL2 mingw developer archive.
	The folder to copy is called x86_64-w64-mingw32 and should be placed in root and renamed SDL2
	(should have four subdirectories bin include lib share)
	
	Builds were done on VirtualBox install of 8.1, so no idea if it works in Windows paintjob etc.

Behaviour is not identical as the CPUs are not seperated, the emulator shell was written for a one CPU system,
and the CPU generators are completely different and glued together to work.

	ESC Exit emulator
	TAB (does ESC in machine)
	F1 Reset CPU
	F5 Run
	F6 Stop
	F7 Step
	F8 Step over
	F9 Set Break

Probably builds on a Macintosh but don't have one.

cerberus 			Runs in console mode
cerberus <bin>		Loads bin to $202 in 6502/Z80 mode and enters debugger
					(a 6502 mode file contains the characters "65" in it's name somewhere)
cerberus <bin> run 	Loads and runs binary.

F3 is an incode to debugger breakpoint. 
	Z80 	: DI which is meaningless as no IRQ.
	65C02 	: Single byte NOP.

All files are kept in the 'storage' subdirectory.

Windows requires the two DLLs in the emulator directory, which are built into the release zips.

Paul Robson October 2021
paul@robsons.org.uk
