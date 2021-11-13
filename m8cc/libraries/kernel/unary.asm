; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		unary.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Unary operators (A ? B -> A)
;
; ***************************************************************************************
; ***************************************************************************************

;; [MACRO]	---
		dec 	hl
		dec 	hl
;; [END]

; ***************************************************************************************

;; [MACRO] 	--
		dec 	hl
;; [END]

; ***************************************************************************************

;; [MACRO] 	++
		inc 	hl
;; [END]

; ***************************************************************************************

;; [MACRO]	+++
		inc 	hl
		inc 	hl
;; [END]

; ***************************************************************************************

;; [CALL] 	0-
__negate:
		ld 		a,h
		cpl 
		ld 		h,a
		ld 		a,l
		cpl
		ld 		l,a
		inc 	hl
		ret
;; [END]

; ***************************************************************************************

;; [CALL] 	0<
		bit 	7,h
		ld 		hl,$0000
		ret 	z
		dec 	hl
		ret
;; [END]

; ***************************************************************************************

;; [CALL] 	0=
		ld 		a,h
		or 		l
		ld 		hl,$0000
		ret 	nz
		dec 	hl
		ret
;; [END]

; ***************************************************************************************

;; [MACRO]	2* 
		add 	hl,hl
;; [END]

;; [MACRO]	4* 
		add 	hl,hl
		add 	hl,hl
;; [END]

;; [MACRO]	8* 
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
;; [END]

;; [MACRO]	16*
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
;; [END]

;; [MACRO]	256* 
		ld 		h,l
		ld		l,0
;; [END]

; ***************************************************************************************

;; [MACRO]	2/ 
		sra 	h
		rr 		l
;; [END]

;; [CALL]	4/
		sra 	h
		rr 		l
		sra 	h
		rr 		l
;; [END]

;; [CALL]	8/
		sra 	h
		rr 		l
		sra 	h
		rr 		l
		sra 	h
		rr 		l
;; [END]

;; [CALL]	16/
		sra 	h
		rr 		l
		sra 	h
		rr 		l
		sra 	h
		rr 		l
		sra 	h
		rr 		l
;; [END]

;; [MACRO]	256/ 
		ld 		l,h
		ld 		h,0
;; [END]

; ***************************************************************************************

;; [CALL] 	abs
		bit 	7,h
		ret		z
		jp 		__negate
;; [END]

; ***************************************************************************************

;; [MACRO]	bswap	
		ld 		a,l
		ld 		l,h
		ld 		h,a
;; [END]

; ***************************************************************************************

;; [CALL] 	not
		ld 		a,h
		cpl 
		ld 		h,a
		ld 		a,l
		cpl
		ld 		l,a
		ret
;; [END]

; ***************************************************************************************

;; [CALL] strlen
		push 	de
		ex 		de,hl
		ld 		hl,0
_SLNLoop:
		ld 		a,(de)
		or 		a
		jr 		z,_SLNExit
		inc 	de
		inc 	hl
		jr 		_SLNLoop
_SLNExit:
		pop 	de
		ret
;; [END] 
				
; ***************************************************************************************

;; [CALL] 	random
	ex 		de,hl
	push 	bc
    ld 		hl,(_randomSeed1)
    ld 		b,h
    ld 		c,l
    add 	hl,hl
    add 	hl,hl
    inc 	l
    add 	hl,bc
    ld 		(_randomSeed1),hl
    ld 		hl,(_randomSeed2)
    add 	hl,hl
    sbc 	a,a
    and 	%00101101
    xor 	l
    ld 		l,a
    ld 		(_randomSeed2),hl
    add 	hl,bc
    pop 	bc
    ret

_randomSeed1:
	.dw 	$ABCD
_randomSeed2:
	.dw 	$FDB9

