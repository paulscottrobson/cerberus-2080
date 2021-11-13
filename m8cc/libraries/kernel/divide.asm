; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		divide.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Division
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************

;; [CALL]	/
	push 	de
	call 	DIVDivideMod16
	ex 		de,hl
	pop 	de
	ret
;; [END]

; ***************************************************************************************

;; [CALL]	mod
	push 	de
	call 	DIVDivideMod16
	pop 	de
	ret
;; [END]

; *********************************************************************************
;
;			Calculates DE / HL. On exit DE = result, HL = remainder
;
; *********************************************************************************

DIVDivideMod16:
	push 	bc
	ld 		b,d 				; DE 
	ld 		c,e
	ex 		de,hl
	ld 		hl,0
	ld 		a,b
	ld 		b,8
Div16_Loop1:
	rla
	adc 	hl,hl
	sbc 	hl,de
	jr 		nc,Div16_NoAdd1
	add 	hl,de
Div16_NoAdd1:
	djnz 	Div16_Loop1
	rla
	cpl
	ld 		b,a
	ld 		a,c
	ld 		c,b
	ld 		b,8
Div16_Loop2:
	rla
	adc 	hl,hl
	sbc 	hl,de
	jr 		nc,Div16_NoAdd2
	add 	hl,de
Div16_NoAdd2:
	djnz 	Div16_Loop2
	rla
	cpl
	ld 		d,c
	ld 		e,a
	pop 	bc
	ret
		
		
