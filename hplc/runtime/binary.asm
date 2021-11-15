; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		binary.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th November 2021
;		Purpose :	Binary operators
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;							Four standard operators + Modulus
;
; ***************************************************************************************

RTF_System_Add_Const:
		xor 	a
		jr 		z,.+3
RTF_System_Add_Var:
		.include "binary.inc"
		add 	hl,de
		ret

RTF_System_Sub_Const:
		xor 	a
		jr 		z,.+3
RTF_System_Sub_Var:
		.include "binary.inc"
		xor 	a
		sbc 	hl,de
		ret

RTF_System_Mlt_Const:
		xor 	a
		jr 		z,.+3
RTF_System_Mlt_Var:
		.include "binary.inc"
		jp 		MULTMultiply16

RTF_System_Div_Const:
		xor 	a
		jr 		z,.+3
RTF_System_Div_Var:
		.include "binary.inc"
		call 	DIVDivideMod16
		ex 		de,hl
		ret

RTF_System_Mod_Const:
		xor 	a
		jr 		z,.+3
RTF_System_Mod_Var:
		.include "binary.inc"
		call 	DIVDivideMod16
		ret

; ***************************************************************************************
;
;									3 Logical Operators
;
; ***************************************************************************************

RTF_System_And_Const:
		xor 	a
		jr 		z,.+3
RTF_System_And_Var:
		.include "binary.inc"
		ld 		a,h
		and 	d
		ld 		h,a
		ld 		a,l
		and 	e
		ld 		l,a
		ret

RTF_System_Or_Const:
		xor 	a
		jr 		z,.+3
RTF_System_Or_Var:
		.include "binary.inc"
		ld 		a,h
		or 	 	d
		ld 		h,a
		ld 		a,l
		or 		e
		ld 		l,a
		ret
		
RTF_System_Xor_Const:
		xor 	a
		jr 		z,.+3
RTF_System_Xor_Var:
		.include "binary.inc"
		ld 		a,h
		xor 	d
		ld 		h,a
		ld 		a,l
		xor 	e
		ld 		l,a
		ret
		