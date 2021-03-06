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

		.include "binary.asm"
		.include "multiply.asm"
		.include "divide.asm"
		.include "miscellany.asm"


RTF_System_Jump:
RTF_System_Jump_Zero:
RTF_System_Jump_NonZero:
		ret

EndRuntime:		