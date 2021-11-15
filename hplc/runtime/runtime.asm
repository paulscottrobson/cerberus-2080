; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		runtime.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th November 2021
;		Purpose :	HPLC Runtime
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;									Runtime start.
;
; ***************************************************************************************

		.org 	$202

RuntimeStart:
		ld 		hl,RuntimeStart 			; Identify the base address
		ld 		hl,EndRuntime 				; Point HL to the end of the runtime
		ld 		sp,$F000 					; initialise the stack to High Memory
Start:
		jp		Start 						; patched to jump to main()


RTF_System_Halt:
		halt 
		jr 		RTF_System_Halt

RTF_System_Not:
		ld 		a,h 						; Set Z flag if HL = 0
		or 		l
		dec 	hl 							; if HL is zero, now -1
		ret 	z 							; correct answer if zero
		ld 		hl,0 						; otherwise return
		ret
		
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


RTF_System_Jump:
RTF_System_Jump_Zero:
RTF_System_Jump_NonZero:
		ret

EndRuntime:		