; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		miscellany.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th November 2021
;		Purpose :	Odds and ends
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;									Stop the CPU
;
; ***************************************************************************************

RTF_System_Halt:
		halt 
		jr 		RTF_System_Halt

; ***************************************************************************************
;
;								Logical Not (e.g. 0=)
;
; ***************************************************************************************

RTF_System_Not:
		ld 		a,h 						; Set Z flag if HL = 0
		or 		l
		dec 	hl 							; if HL is zero, now -1
		ret 	z 							; correct answer if zero
		ld 		hl,0 						; otherwise return
		ret
		

