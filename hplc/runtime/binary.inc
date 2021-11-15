; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		binary.inc
;		Purpose :	Binary include
;		Date :		15th November 2021
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************
;
; 		This is in every binary operation, see binary.asm for examples. 
;
; 		Entered at the top, or skipping the SCF with CC, it gets the following word
;		in the return code into DE, if CS does an indirect DE = (DE)
;
; 		Trying to avoid variable Macro syntax *and* CALL overheads.
;
		scf 								; variable version enters here.
		ex 		(sp),hl 					; old value on TOS, HL is address of parameter
		ld 		e,(hl) 						; fetch parameter, DE
		inc 	hl
		ld 		d,(hl)
		inc 	hl
		jr 		nc,.+8 						; if constant skip the read.

		ld 		a,(de) 						; low byte -> B
		ld 		b,a
		inc 	de
		ld 		a,(de) 						; high byte -> A
		ld 		d,a 						; put in DE.
		ld 		e,b 

		ex 		(sp),hl 					; return address TOS, HL is current, DE parameter.

