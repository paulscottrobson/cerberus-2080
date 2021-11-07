; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		structure.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th November 2021
;		Purpose :	Structure handler
;
; ***************************************************************************************
; ***************************************************************************************

;; [CALL] 		tend.handler 
		exx 								; use alt registers
		pop 	hl 							; return/offset address.
		pop 	de 							; this is the count
		ld 		a,d 						; check if it is zero.
		or 		e
		jr 		nz,_tend_loop 				; if non zero, loop back
		;
		inc 	hl 							; exit loop, skip the count back.
		push 	hl 							; push return address back on stack
		exx 								; get original registers back and exit
		ret 								

_tend_loop:									; we are going round the loop, return HL count DE
		ld 		c,(hl) 						; get the loop offset into BC
		ld 		b,0
		xor 	a 							; subtract from HL
		sbc 	hl,bc
		push 	hl 	 						; push loop address on stack
		dec 	de 							; decrement counter
		push 	de  						; push new count on stack
		exx 								; original registers
		pop 	hl 							; count into HL
		ret 								; and exit

;; [END]
