	.org $202
M8_C_boot:
	ld sp,$F000
	jp $202
; ***************************************************************************************
; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		binary.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Binary operators (A ? B -> A)
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************

M8_C__c60_:
	ld 		a,h 								 	; check if signs different.
	xor 	d
	add 	a,a 									; CS if different
	jr 		nc,__less_samesign
	ld 		a,d 									; different. set CS to sign of B
	add 	a,a 									; if set (negative) B must be < A as A is +ve
	jr 		__less_returnc
__less_samesign:
	push 	de 										; save DE
	ex 		de,hl 									; -1 if B < A
	sbc 	hl,de 									; calculate B - A , hencs CS if < (Carry clear by add a,a)
	pop 	de 										; restore DE
__less_returnc:
	ld 		a,0 									; A 0
	sbc 	a,0 									; A $FF if CS.
	ld 		l,a 									; put in HL
	ld 		h,a
	ret
M8_C__c60__end:

; ***************************************************************************************

M8_C__c61_:
	ld 		a,h 									; H = H ^ D
	xor 	d
	ld 		h,a
	ld 		a,l 									; A = (L ^ E) | (H ^ D)
	xor 	e
	or 		h 										; if A == 0 they are the same.
	ld 		hl,$0000 								; return 0 if different
	ret 	nz
	dec 	hl 										; return -1
	ret
M8_C__c61__end:

; ***************************************************************************************

M8_C__c45_:
	push 	de 										; save DE
	ex 		de,hl 									; HL = B, DE = A
	xor 	a  										; clear carry
	sbc 	hl,de 									; calculate B-A
	pop 	de 										; restore DE
	ret
M8_C__c45__end:

; ***************************************************************************************

M8_M__c43_:
	add 	hl,de
M8_M__c43__end:

; ***************************************************************************************

M8_C_and:
	ld 		a,h
	and 	d
	ld 		h,a
	ld 		a,l
	and 	e
	ld 		l,a
	ret
M8_C_and_end:

; ***************************************************************************************

M8_C_or:
	ld 		a,h
	or 		d
	ld 		h,a
	ld 		a,l
	or 		e
	ld 		l,a
	ret
M8_C_or_end:

; ***************************************************************************************

M8_C_xor:
	ld 		a,h
	xor 	d
	ld 		h,a
	ld 		a,l
	xor 	e
	ld 		l,a
	ret
M8_C_xor_end:

; ***************************************************************************************
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

M8_C__c47_:
	push 	de
	call 	DIVDivideMod16
	ex 		de,hl
	pop 	de
	ret
M8_C__c47__end:

; ***************************************************************************************

M8_C_mod:
	push 	de
	call 	DIVDivideMod16
	pop 	de
	ret
M8_C_mod_end:

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


; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		memory.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Memory operators
;
; ***************************************************************************************
; ***************************************************************************************

M8_M__c33_:
		ld 		(hl),e
		inc 	hl
		ld 		(hl),d
		dec 	hl
M8_M__c33__end:

; ***************************************************************************************

M8_M__c64_:
		ld 		a,(hl)
		inc 	hl
		ld		h,(hl)
		ld		l,a
M8_M__c64__end:

; ***************************************************************************************

M8_C__c43__c33_:
		ld 		a,(hl)
		add 	a,e
		ld 		(hl),a
		inc 	hl
		ld 		a,(hl)
		adc 	a,d
		ld 		(hl),a
		dec 	hl
		ret
M8_C__c43__c33__end:

; ***************************************************************************************

M8_M_c_c33_:
		ld 		(hl),e
M8_M_c_c33__end:

; ***************************************************************************************

M8_M_c_c64_:
		ld 		l,(hl)
		ld 		h,0
M8_M_c_c64__end:

; ***************************************************************************************

M8_C_p_c64_:
		push 	bc
		ld		b,h
		ld 		c,l
		in 		l,(c)
		ld 		h,0
		pop 	bc
		ret
M8_C_p_c64__end:

; ***************************************************************************************

M8_C_p_c33_:
		push 	bc
		push 	hl
		ld 		a,e
		ld		b,h
		ld 		c,l
		out 	(c),a
		pop 	hl
		pop 	bc
		ret
M8_C_p_c33__end:


; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		miscellany.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Miscellaneous words
;
; ***************************************************************************************
; ***************************************************************************************

M8_C_copy:
		ld 		a,b 								; exit if C = 0
		or 		c
		ret 	z

		push 	bc 									; BC count
		push 	de 									; DE target
		push 	hl 									; HL source

		xor 	a 									; Clear C
		sbc 	hl,de 								; check overlap ?
		jr 		nc,__copy_gt_count 					; if source after target
		add 	hl,de 								; undo subtract

		add 	hl,bc 								; add count to HL + DE
		ex 		de,hl
		add 	hl,bc
		ex 		de,hl
		dec 	de 									; dec them, so now at the last byte to copy
		dec 	hl
		lddr 										; do it backwards
		jr 		__copy_exit

__copy_gt_count:
		add 	hl,de 								; undo subtract
		ldir										; do the copy
__copy_exit:
		pop 	hl 									; restore registers
		pop 	de
		pop 	bc
		ret
M8_C_copy_end:

; ***************************************************************************************

M8_C_fill:
		ld 		a,b 								; exit if C = 0
		or 		c
		ret 	z

		push 	bc 									; BC count
		push 	de 									; DE target, L byte
__fill_loop:
		ld 		a,l 								; copy a byte
		ld 		(de),a
		inc 	de 									; bump pointer
		dec 	bc 									; dec counter and loop
		ld 		a,b
		or 		c
		jr 		nz,__fill_loop
		pop 	de 									; restore
		pop 	bc
		ret
M8_C_fill_end:

; ***************************************************************************************

M8_C_halt:
__halt_loop:
		di
		halt
		jr 		__halt_loop
M8_C_halt_end:

; ***************************************************************************************

M8_M_break:
		db 		$76
M8_M_break_end:

; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		multiply.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Multiplication
;
; ***************************************************************************************
; ***************************************************************************************


M8_C__c42_:
	jp  	MULTMultiply16
M8_C__c42__end:

; *********************************************************************************
;
;								Does HL = HL * DE
;
; *********************************************************************************

MULTMultiply16:
		push 	bc
		push 	de
		ld 		b,h 							; get multipliers in DE/BC
		ld 		c,l
		ld 		hl,0 							; zero total
__Core__Mult_Loop:
		bit 	0,c 							; lsb of shifter is non-zero
		jr 		z,__Core__Mult_Shift
		add 	hl,de 							; add adder to total
__Core__Mult_Shift:
		srl 	b 								; shift BC right.
		rr 		c
		ex 		de,hl 							; shift DE left
		add 	hl,hl
		ex 		de,hl
		ld 		a,b 							; loop back if BC is nonzero
		or 		c
		jr 		nz,__Core__Mult_Loop
		pop 	de
		pop 	bc
		ret
; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		register.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Register manipulation
;
; ***************************************************************************************
; ***************************************************************************************

M8_M_swap:
		ex 		de,hl
M8_M_swap_end:

; ***************************************************************************************

M8_M_a_c62_b:
		ld 		d,h
		ld 		e,l
M8_M_a_c62_b_end:

M8_M_a_c62_c:
		ld 		b,h
		ld 		c,l
M8_M_a_c62_c_end:

; ***************************************************************************************

M8_M_b_c62_a:
		ld 		h,d
		ld 		l,e
M8_M_b_c62_a_end:

M8_M_b_c62_c:
		ld 		b,d
		ld 		c,e
M8_M_b_c62_c_end:

; ***************************************************************************************

M8_M_c_c62_a:
		ld 		h,b
		ld 		l,c
M8_M_c_c62_a_end:

M8_M_c_c62_b:
		ld 		d,b
		ld 		e,c
M8_M_c_c62_b_end:

; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		stack.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		31st October 2021
;		Purpose :	Stack words
;
; ***************************************************************************************
; ***************************************************************************************

M8_M_push:
	push 	hl
M8_M_push_end:

M8_M_pop:
	ex 		de,hl
	pop 	hl
M8_M_pop_end:

; ***************************************************************************************

M8_M_a_c62_r:
	push 	hl
M8_M_a_c62_r_end:

M8_M_r_c62_a:
	pop 	hl
M8_M_r_c62_a_end:

; ***************************************************************************************

M8_M_b_c62_r:
	push 	de
M8_M_b_c62_r_end:

M8_M_r_c62_b:
	pop 	de
M8_M_r_c62_b_end:

; ***************************************************************************************

M8_M_c_c62_r:
	push 	bc
M8_M_c_c62_r_end:

M8_M_r_c62_c:
	pop 	bc
M8_M_r_c62_c_end:


; ***************************************************************************************

M8_M_ab_c62_r:
	push 	de
	push 	hl
M8_M_ab_c62_r_end:

M8_M_r_c62_ab:
	pop 	hl
	pop 	de
M8_M_r_c62_ab_end:

; ***************************************************************************************

M8_M_abc_c62_r:
	push 	bc
	push 	de
	push 	hl
M8_M_abc_c62_r_end:

M8_M_r_c62_abc:
	pop 	hl
	pop 	de
	pop 	bc
M8_M_r_c62_abc_end:
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

M8_M__c45__c45__c45_:
		dec 	hl
		dec 	hl
M8_M__c45__c45__c45__end:

; ***************************************************************************************

M8_M__c45__c45_:
		dec 	hl
M8_M__c45__c45__end:

; ***************************************************************************************

M8_M__c43__c43_:
		inc 	hl
M8_M__c43__c43__end:

; ***************************************************************************************

M8_M__c43__c43__c43_:
		inc 	hl
		inc 	hl
M8_M__c43__c43__c43__end:

; ***************************************************************************************

M8_C_0_c45_:
__negate:
		ld 		a,h
		cpl
		ld 		h,a
		ld 		a,l
		cpl
		ld 		l,a
		inc 	hl
		ret
M8_C_0_c45__end:

; ***************************************************************************************

M8_C_0_c60_:
		bit 	7,h
		ld 		hl,$0000
		ret 	z
		dec 	hl
		ret
M8_C_0_c60__end:

; ***************************************************************************************

M8_C_0_c61_:
		ld 		a,h
		or 		l
		ld 		hl,$0000
		ret 	nz
		dec 	hl
		ret
M8_C_0_c61__end:

; ***************************************************************************************

M8_M_2_c42_:
		add 	hl,hl
M8_M_2_c42__end:

M8_M_4_c42_:
		add 	hl,hl
		add 	hl,hl
M8_M_4_c42__end:

M8_M_8_c42_:
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
M8_M_8_c42__end:

M8_M_16_c42_:
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
M8_M_16_c42__end:

M8_M_256_c42_:
		ld 		h,l
		ld		l,0
M8_M_256_c42__end:

; ***************************************************************************************

M8_M_2_c47_:
		sra 	h
		rr 		l
M8_M_2_c47__end:

M8_M_4_c47_:
		sra 	h
		rr 		l
		sra 	h
		rr 		l
M8_M_4_c47__end:

M8_C_8_c47_:
		sra 	h
		rr 		l
		sra 	h
		rr 		l
		sra 	h
		rr 		l
M8_C_8_c47__end:

M8_C_16_c47_:
		sra 	h
		rr 		l
		sra 	h
		rr 		l
		sra 	h
		rr 		l
		sra 	h
		rr 		l
M8_C_16_c47__end:

M8_M_256_c47_:
		ld 		l,h
		ld 		h,0
M8_M_256_c47__end:

; ***************************************************************************************

M8_C_abs:
		bit 	7,h
		ret		z
		jp 		__negate
M8_C_abs_end:

; ***************************************************************************************

M8_M_bswap:
		ld 		a,l
		ld 		l,h
		ld 		h,a
M8_M_bswap_end:

; ***************************************************************************************

M8_C_not:
		ld 		a,h
		cpl
		ld 		h,a
		ld 		a,l
		cpl
		ld 		l,a
		ret
M8_C_not_end:

; ***************************************************************************************

M8_C_strlen:
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
M8_C_strlen_end:

; ***************************************************************************************

M8_C_random:
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
