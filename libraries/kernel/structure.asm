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

; ***************************************************************************************
;
;		Handles NEXT. The loop counter is on TOS below the return address of this call
;
; ***************************************************************************************

;; [CALL] 		next.handler 
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

; ***************************************************************************************
;
;			Branches Forwards/Backwards Zero/Positive tests and Always
;
; ***************************************************************************************


;; [CALL] 	brzero.fwd
		xor 	a
		jr 		_zeroBranch
;; [END]


;; [CALL] 	brzero.bwd
		scf
		jr 		_zeroBranch
;; [END]

;; [CALL] 	brpos.fwd
		xor 	a
		jr 		_posBranch
;; [END]

;; [CALL] 	brpos.bwd
		scf
		jr 		_posBranch
;; [END]

;; [CALL] 	br.fwd
		xor 	a
		jr 		_Branch
;; [END]

;; [CALL] 	br.bwd
		scf
		jr 		_Branch
;; [END]


_zeroBranch:
		ex 		af,af' 						; save the direction in AF' (CC FWD, CS BWD)
		ld 		a,h 						; check HL is zero
		or 		l
		jr 		z,_Branch
		jr 		_NoBranch

_posBranch:
		ex 		af,af' 						; save the direction in AF' (CC FWD, CS BWD)
		bit 	7,h 						; check HL is +ve or zero
		jr 		z,_Branch
;
; 		Not Branching code
;
_NoBranch:
		ex 		(sp),hl 					; skip over the return address
		inc 	hl
		ex 		(sp),hl
		ret
;
; 		Branching code.
;
_Branch:
		exx 								; save registers.
		ex 		(sp),hl 					; get the branch offset into DE, position into HL
		ld 		e,(hl)
		ld 		d,0
		ex 		af,af' 						; get the direction flag back
		jr 		c,_BranchBackwards

_BranchForwards:
		add 	hl,de  						; calculate the new address
		ex 		(sp),hl 					; fix up return address
		exx 								; restore registers and exit
		ret

_BranchBackwards:
		xor 	a 							; calculate new address
		sbc 	hl,de				
		ex 		(sp),hl 					; fix up return address
		exx 								; restore registers and exit
		ret
		