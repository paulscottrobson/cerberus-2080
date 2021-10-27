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

Behaviour is not identical as the CPUs are not seperated, the emulator shell was written for a one CPU system :)

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
cerberus <bin>		Loads bin to $202 in Z80 mode and enters debugger
cerberus <bin> run 	Loads and runs binary.

F3 is an incode to debugger breakpoint. 
	Z80 	: DI which is meaningless as no IRQ.
	65C02 	: Single byte NOP.

To switch to 6502 mode use the opcode $FB as the first instruction. This can be removed from final build or
simply left in, as it is a one byte NOP on a 65C02. FB will cause a direct switch to running 65C02 code.

All files are kept in the 'storage' subdirectory.

Windows requires the two DLLs in the emulator directory, which are built into the release zips.

Paul Robson October 2021
paul@robsons.org.uk
