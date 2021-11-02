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

M8_M_a_c62_x:
		push 	hl
		pop 	ix
M8_M_a_c62_x_end:

M8_M_x_c62_a:
		push 	ix
		pop 	hl
M8_M_x_c62_a_end:

M8_M_a_c62_y:
		push 	hl
		pop 	iy
M8_M_a_c62_y_end:

M8_M_y_c62_a:
		push 	iy
		pop 	hl
M8_M_y_c62_a_end:
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

M8_M_bc_c62_r:
	push 	bc
	push 	de
M8_M_bc_c62_r_end:

M8_M_r_c62_bc:
	pop 	de
	pop 	bc
M8_M_r_c62_bc_end:

; ***************************************************************************************

M8_M_x_c62_r:
	push 	ix
M8_M_x_c62_r_end:

M8_M_r_c62_x:
	pop 	ix
M8_M_r_c62_x_end:

; ***************************************************************************************

M8_M_y_c62_r:
	push 	iy
M8_M_y_c62_r_end:

M8_M_r_c62_y:
	pop 	iy
M8_M_r_c62_y_end:
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

; *********************************************************************************************
; *********************************************************************************************
;
;		Name:		spritemanager.asm
;		Purpose:	Sprite Manager
;		Created:	1st November 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; *********************************************************************************************
; *********************************************************************************************
;
;		Sprite Record:
;
;			Copy data:
;				0..6 	X:2 	Y:2 	Graphics:2 	Control:1
;				7 		Change flag
; 			Current Data: (as per xsprite.asm)
;				8..14 	X:2 	Y:2 	Graphics:2 	Control:1
;				15 		Status byte
;
;		When being updated, if the change flag is set, then the sprite is removed, then data
;		(0-6) is copied to (8-14), then the sprite redrawn
;
;		The option also exists to erase all sprites ; the point of such being that one can update
;		the background. This sets all the change flags so the sprites are redrawn on the next sync.
;
; *********************************************************************************************
;
;
;			Reset Sprite Manager. HL points to data block, DE is number of sprites
;
;
; *********************************************************************************************

M8_C_spr_c46_reset:

SPMReset:
		push 	af
		push 	bc
		push 	de
		push 	hl
		ld 		(SPMData),hl 				; save count and address
		ld 		a,e
		ld 		(SPMCount),a
		add 	a,a 						; double, as we clear it twice (2 x 8 byte blocks)
		ld 		b,a
_SPMClear:
		ld 		c,6 						; write out 6 $FFs to position and graphic
_SPMClear2:
		ld 		(hl),$FF
		inc 	hl
		dec 	c
		jr 		nz,_SPMClear2
		ld 		(hl),c 						; followed by 2 zeros (control and status/change byte)
		inc 	hl
		ld 		(hl),c
		inc 	hl
		djnz 	_SPMClear
		ld 		hl,SPMUnused 				; no current selection
		ld 		(SPMCurrent),hl
		call 	SPRInitialise 				; erase the sprite control records.
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

M8_C_spr_c46_reset_end:

; *********************************************************************************************
;
;		Sprite functions/words. A sprite is selected via SPMSelect and then moved, graphics
; 		set etc. by other functions. SPMUpdate updates all sprites. Parameters at L/HL then DE.
;
; *********************************************************************************************

M8_C_spr_c46_select:

SPMSelect:
		push 	af
		push 	bc
		push 	hl
		ld		a,(SPMCount)
		cp 		l 							; compare max vs selected.
		jr 		z,_SPMSFail 				; must be >
		jp 		m,_SPMSFail

		add 	hl,hl 						; x 16
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
		ld 		de,(SPMData) 				; add base address
		add 	hl,de
		jr 		_SPMSExit 					; write and exit

_SPMSFail:
		ld 		hl,SPMUnused
_SPMSExit:
		ld 		(SPMCurrent),hl
		pop 	hl
		pop 	de
		pop 	af
		ret
M8_C_spr_c46_select_end:

; *********************************************************************************************
;
;										X Y SPR.MOVE
;
; *********************************************************************************************

M8_C_spr_c46_move:
SPMMove:
		push 	ix
		ld 		ix,(SPMCurrent)
		ld 		(ix+0),e 					; write X
		ld 		(ix+1),d
		ld 		(ix+2),l 					; write Y
		ld 		(ix+3),h
_SPMGeneralExit:
		set 	7,(ix+7)
		pop 	ix
		ret
M8_C_spr_c46_move_end:

; *********************************************************************************************
;
;									   GDATA SPR.IMAGE
;
; *********************************************************************************************

M8_C_spr_c46_image:
		push 	ix
		ld 		ix,(SPMCurrent)
		ld 		(ix+4),l
		ld 		(ix+5),h
		jr 		_SPMGeneralExit
M8_C_spr_c46_image_end:

; *********************************************************************************************
;
;									   CBYTE SPR.CONTROL
;
; *********************************************************************************************

M8_C_spr_c46_ctrl:
		push 	ix
		ld 		ix,(SPMCurrent)
		ld 		(ix+6),l
		jr 		_SPMGeneralExit
M8_C_spr_c46_ctrl_end:

; *********************************************************************************************
;
;							   <bool> SPR.VFLIP / HFLIP
;
; *********************************************************************************************

M8_C_spr_c46_hflip:
		push 	af
		push 	ix
		ld 		ix,(SPMCurrent)
		res 	5,(ix+6)
		ld 		a,l
		or 		h
		jr 		z,_SPCTExit
		set 	5,(ix+6)
		jr 		_SPCTExit
M8_C_spr_c46_hflip_end:

M8_C_spr_c46_vflip:
		push 	af
		push 	ix
		ld 		ix,(SPMCurrent)
		res 	6,(ix+6)
		ld 		a,l
		or 		h
		jr 		z,_SPCTExit
		set 	7,(ix+6)
_SPCTExit:
		set 	7,(ix+7)
		pop 	ix
		pop 	af
		ret
M8_C_spr_c46_vflip_end:

; *********************************************************************************************
;
;										Update all sprites
;
; *********************************************************************************************

M8_C_spr_c46_update:

SPMUpdate:
		push 	af
		push 	bc
		push 	de
		push 	hl
		push 	ix

		ld 		a,(SPMCount)
		ld 		b,a
		ld 		ix,(SPMData)
_SPMUpdateLoop:
		ld 		a,(ix+7) 					; check redraw flag
		or 		a
		call 	nz,_SPMUpdateOne 			; if non zero update this one
		ld 		de,16
		add 	ix,de
		djnz 	_SPMUpdateLoop

		pop 	ix
		pop 	hl
		pop 	bc
		pop 	de
		pop 	af
		ret
;
;		Updates one sprite from new data if redraw flag found set.
;
_SPMUpdateOne:
		push 	bc
		ld 		(ix+7),0 					; clear the redraw flag.
		call 	SpriteXErase 				; remove sprite
		push 	ix 							; from address in DE
		pop 	de
		ld 		hl,8
		add 	hl,de 						; from in DE, to in HL
		ex 		de,hl 						; to in DE , from in HL
		ld 		bc,7 						; copy 7 bytes over
		ldir
		call 	SpriteXDraw 				; redraw sprite
		pop 	bc
		ret
M8_C_spr_c46_update_end:

; *********************************************************************************************
;
;							Hide all sprites (to change background)
;
; *********************************************************************************************

M8_C_spr_c46_hide_c46_all:

SPMHideAll:
		push 	af
		push 	bc
		push 	de
		push 	ix
		ld 	 	a,(SPMCount)
		ld 		b,a
		ld 		ix,(SPMData)
		ld 		de,16
_SPMHideLoop:
		call 	SpriteXErase 				; remove sprite
		set 	7,(ix+7) 					; force redraw next update
		add 	ix,de
		djnz 	_SPMHideLoop
		pop 	hl
		pop 	bc
		pop 	de
		pop 	af
		ret
M8_C_spr_c46_hide_c46_all_end:

SPMData: 									; address of sprite
		.dw 	0
SPMCount: 									; number of sprites
		.dw 	0
SPMCurrent: 								; currently selected sprite (may point to unused junk space)
		.dw 	0
SPMUnused: 									; space for junk writes.
		.ds 	16,0
; *********************************************************************************************
; *********************************************************************************************
;
;		Name:		xsprite.asm
;		Purpose:	XOR Sprite Drawer
;		Created:	29th October 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; *********************************************************************************************
; *********************************************************************************************

; *********************************************************************************************
;
;		This is an XOR drawing sprite system. This is useful because the draw is self
;		cancelling, and this means you don't have to repaint multiple sprites to restore
; 		the display state. The downside is that it doesn't work well on collisions or
; 		especially backgrounds.
;
;		The original design, which was a simpler draw all/erase all design, was binned
;		because I thought on real hardware it would create too much flash on the display.
;
;		I don't yet have a real machine so can't evaluate this in practice, as the emulator
; 		snapshots the display at 60Mhz, so the effects of endlessly messing with the
;		CRAM and VRAM is largely hidden.
;
;		At 4Mhz it does about 330 draws/erases a second on a 16x16 sprites, twice as fast on
;		8 pixel high sprites.
;
;		It eats UDGs - a single 16x16 sprite needs 9 UDGs if it doesn't overlap with another.
;
; *********************************************************************************************
;
;		How it works.
;
;			When drawing a sprite, it will try to allocate UDGs from its pool for the space
; 			to draw the sprite. When drawing or erasing it then XORs the bit patterns into this
; 			as far as it can. When erased, UDGs are returned to the pool if no longer required.
;
; *********************************************************************************************
;
;		Offsets from IX.
;
;			+0,+1 		Horizontal position (0..319)
;			+2,+3 		Vertical position (0..239)
;			+4,+5 		Pointer to graphic image data.
;							Width : 8  	one byte per row
;							Width : 16 	two bytes per row left-right order
;			+6 			Control
;							Bit 7: 		Set if sprite disabled
;							Bit 6: 		Vertical flip
;							Bit 5:		Horizontal flip
;							Bit 4..2:	0
;							Bit 1:		Double width
;							Bit 0: 		Double height
;			+7 			Status
;							Bit 7:		Set when drawn on screen
;							Bit 6..0:	0
;
;			Changes should only be made when the sprite is not drawn, otherwise chaos
;			will ensue.
;
;			Draws will not fail, however, they may not visually work either. If there are more
;			UDGs required than available graphics will not be drawn, or possibly drawn
;			erratically. It is advised to minimise the number of sprites both for CPU time
;			and UDG usage.
;
;			Use specific UDGs for static/slow objects. For (say) Pacman the only sprites should
;			be the player character and chasing ghosts.
;
; *********************************************************************************************
;
;								  Sprite Record entries
;
; *********************************************************************************************

SPRx 	= 0 								; horizontal position, pixels
SPRy 	= 2 								; vertical position, pixels
SPRgraphics = 4 							; bitmap data
SPRcontrol = 6 								; 0:width 1:height 5:HFlip 6:VFlip 7:hidden
											; (others are zero)
SPRstatus = 7 								; 7:currently drawn

; *********************************************************************************************
;
; 								Initialise the sprite system.
;
; 	At this point sprite records should all have their "currently drawn" bit clear, it will
; 	get very confused otherwise.
;
; *********************************************************************************************

SPRInitialise:
		push 	af
		push 	hl
		;
		; 		Clear the main data area.
		;
		ld 		hl,SPRDataBlock
_SPRZeroBlock:
		ld 		(hl),$00
		inc 	hl
		ld 		a,h
		cp 		SPRDataBlockEnd >> 8
		jr 		nz,_SPRZeroBlock
		;
		; 		Set all possible original characters to $FF, indicating they are available.
		;
		ld 		a,(_SPRFirstUDGSprite)
		ld 		l,a
		ld 		h,SPROriginalChar >> 8
_SPRUsageReset:
		ld 		(hl),$FF
		inc 	l
		jr 		nz,_SPRUsageReset
		pop 	hl
		pop 	af
		ret

; *********************************************************************************************
;
;						Draw, or Erase, the sprite whose raw data is at IX
;
; *********************************************************************************************

SpriteXDraw: 								; draw only
		bit 	7,(ix+SPRstatus)
		ret 	nz
		jr 		SpriteXToggle
SpriteXErase:								; erase only
		bit 	7,(ix+SPRstatus)
		ret 	z
SpriteXToggle:								; flip state
		push 	af 							; save registers
		push 	bc
		push 	de
		push 	hl
		push 	iy
		;
		; 		Check actually visible
		;
		bit 	7,(ix+SPRcontrol)
		jp 		nz,_SPRExit
		;
		; 		Check range.
		;
		ld 		a,(ix+SPRx+1) 				; MSB of X must be 0 or 1
		ld 		b,a 						; save in B
		and 	$FE
		or 		a,(ix+SPRy+1) 				; MSB of Y must be zero.
		jr 		nz,_SPRRangeFail
		;
		ld 		a,(ix+SPRy) 				; check Y < 240
		cp 		8*30
		jr 		nc,_SPRRangeFail
		;
		dec 	b 							; if MSB X was 1, now zero
		jr 		nz,_SPRCalcPosition
		;
		ld 		a,(ix+SPRx) 				; X.MSB was 1, so must be X.LSB < 64
		cp 		64
		jr 		c,_SPRCalcPosition
_SPRRangeFail:
		jp 		_SPRExit
		;
		;		Calculate position in IY
		;
_SPRCalcPosition:
		ld 		h,0							; Y position in HL, with lower 3 bits masked, so already x 8
		ld 		a,(ix+SPRy)
		and 	$F8
		ld 		l,a
		ld 		d,h 						; DE = Y x 8
		ld 		e,l
		add 	hl,hl 						; HL = Y x 32
		add 	hl,hl
		add 	hl,de 						; HL = Y x 40
		ld 		iy,$F800 					; IY = $F800 + Y x 40
		ex 		de,hl
		add 	iy,de

		ld 		e,(ix+SPRx)					; DE = X position
		ld 		d,(ix+SPRx+1)
		srl 	d 							; / 8 (after first in range 0-255 hence SRL E)
		rr 		e
		srl 	e
		srl 	e
		ld 		d,0 						; add to screen position.
		add 	iy,de
		;
		; 		Calculate and patch the fine horizontal shift jump which adjusts the
		; 		number of 24 bit left shifts we do to the graphics data.
		;
		ld 		a,(ix+SPRx)
		and 	7
		add 	a,a
		ld 		(_SPRFineHorizontalShift+1),a
		;
		; 		Calculate the horizontal offset which makes it start drawing part way through a UDG
		;
		ld 		a,(ix+SPRy)
		and 	7
		ld 		(_SPRInitialYOffset),a
		;
		; 		Calculate the row count from bit 1 of the control byte
		; 		(the number of vertical pixels down)
		;
		ld 		a,8
		bit 	1,(ix+SPRcontrol)
		jr 		z,_SPRSingleHeight
		add 	a,a
_SPRSingleHeight:
		ld 		(_SPRRowCount),a
		;
		;		Set the sprite graphic address and incrementer.
		;
		ld 		l,(ix+SPRgraphics) 			; data address
		ld 		h,(ix+SPRgraphics+1)
		ld 		de,1 						; increment/decrement
		bit 	0,(ix+SPRcontrol)
		jr 		z,_SPRSGANotDoubleWidth
		inc 	de 							; 2 if double width
_SPRSGANotDoubleWidth:
		bit 	6,(ix+SPRcontrol) 			; check for vertical flip.
		jr 		z,_SPRSGANotVFlip
		;
		ex 		de,hl 						; DE = address, HL = increment x 8
		push 	hl
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
		bit 	1,(ix+SPRcontrol) 			; x 16 if double height
		jr 		z,_SPRSGANotDoubleHeight
		add 	hl,hl
_SPRSGANotDoubleHeight:
		add 	hl,de 						; add 8/16 x increment to start
		pop 	bc 							; original increment -> BC
		push 	hl 							; save new start on stack.
		ld 		hl,0 						; HL = - increment
		xor 	a
		sbc 	hl,bc
		pop 	de 							; DE = new start off stack
		ex 		de,hl 						; swap them back so HL = address, DE = -increment
		add 	hl,de 						; points HL to the last sprite entry.
_SPRSGANotVFlip:
		ld 		(_SPRFetchGraphicPtr+1),hl 	; write out start address in HL and incrementer in DE.
		ld 		(_SPRAdjustGraphicPtr+1),de
		;
		; 		Try to allocate UDGs for the current row at IY, 2 or 3 UDGs.
		;
_SPRStartNextCharacterRow:
		call 	_SPRAllocateRow 			; try to allocate the whole row.
		jp 		c,_SPRExit					; it didn't work, so we abandon drawing here.
		;
		; 		Adjust the usage counters.
		;
		push 	iy
		call 	SPRAdjustUsageCounter
		inc 	iy
		call 	SPRAdjustUsageCounter
		bit 	0,(ix+SPRcontrol)
		jr 		z,_SPRAuNotRight
		inc 	iy
		call 	SPRAdjustUsageCounter
_SPRAuNotRight:
		pop 	iy
		;
		;		Get the graphics for the next *pixel* line. into ADE
		;
_SPRNextRowUDG:
		;
_SPRFetchGraphicPtr:
		ld 		hl,$0000
		ld 		e,0							; DE = $00:(HL)
		ld 		d,(hl)
		bit 	0,(ix+SPRcontrol) 			; is the width 1 ?
		jr 		z,_SPRHaveGraphicData
		inc 	hl
		ld 		e,d  						; DE = (HL+1):(HL)
		ld 		d,(hl)
		dec 	hl
_SPRHaveGraphicData:
		;
_SPRAdjustGraphicPtr:
		ld 		bc,$0000 					; this is changed to account for size and
		add 	hl,bc 						; direction.
		ld 		(_SPRFetchGraphicPtr+1),hl
		;
		; 		Check for Horizontal Flip
		;
		bit 	5,(ix+SPRcontrol)			; if HFlip bit set
		jr 		z,_SPRNoHFlip
		call 	SPRFlipDE 					; Flip DE
_SPRNoHFlip:
		xor 	a 							; ADE contains 24 bit graphic data.
		ex 		de,hl 						; we put it in AHL
_SPRFineHorizontalShift:
		jr 		$+2 						; this is altered to do the fine horizontal shift
		add 	hl,hl
		adc 	a,a
		add 	hl,hl
		adc 	a,a
		add 	hl,hl
		adc 	a,a
		add 	hl,hl
		adc 	a,a
		add 	hl,hl
		adc 	a,a
		add 	hl,hl
		adc 	a,a
		add 	hl,hl
		adc 	a,a
		add 	hl,hl
		adc 	a,a
		ex 		de,hl 						; put it back in ADE
		;
		;		Now XOR the data with the previously calculated addresses.
		;		If (ix+5)[0] is clear then don't do the third one, it's an 8x8 sprite
		;
		;		These addresses (the ld hl,xxxx ones) are modified in situ.
		;
_SPRLeftUDGPosition:
		ld 		hl,$F000+$C1*8
		xor 	(hl)
		ld 		(hl),a
_SPRMiddleUDGPosition:
		ld 		hl,$F000+$C2*8
		ld 		a,d
		xor 	(hl)
		ld 		(hl),a
		bit 	0,(ix+SPRcontrol) 					; if width 1, skip the last draw
		jr 		z,_SPRDrawEnd
_SPRRightUDGPosition:
		ld 		hl,$F000+$C3*8
		ld 		a,e
		xor 	(hl)
		ld 		(hl),a
_SPRDrawEnd:
		;
		; 		Check if we have done all the rows
		;
		ld 		hl,_SPRRowCount
		dec 	(hl)
		jr 		z,_SPRExit
		;
		; 		Now go to the next line down. Initially this just advances the vertical offset
		;		in the UDG pointers
		;
		ld 		hl,_SPRMiddleUDGPosition+1
		inc 	(hl)
		ld 		hl,_SPRRightUDGPosition+1 	; not guaranteed initialised.
		inc 	(hl)
		ld 		hl,_SPRLeftUDGPosition+1
		inc 	(hl)
		;
		ld 		a,(hl) 						; check crossed 8 byte boundary
		and 	7
		jr 		nz,_SPRNextRowUDG 			; if not complete it.

		xor 	a 							; clear the initial offset
		ld 		(_SPRInitialYOffset),a


		ld 		de,40 						; advance down one row.
		add 	iy,de

		ld 		de,$F800+40*30 				; the end of the physical display
		push 	iy
		pop 	hl
		scf
		sbc 	hl,de
		jr 		nc,_SPRExit 				; past the bottom,exit.

		jp 		_SPRStartNextCharacterRow 	; do the next character row.

_SPRExit:
		ld 		a,(ix+SPRstatus) 			; toggle the drawn status bit
		xor 	$80
		ld 		(ix+SPRstatus),a

		pop 	iy 							; restore registers
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

; *********************************************************************************************
;
;		Allocate 0-3 UDGs to the character space according to need and availability.
; 		Fail with CS if can't.
;		If possible,
;			all new UDGs should have the copied graphic from the background and the
;			old background set up.
;			the UDGs should replace the graphics in IY.
;
; *********************************************************************************************

_SPRAllocateRow:
		push 	bc 							; save BC.
		push 	iy 							; save IY
		ld 		(_SPRAllocSPTemp),sp		; save SP as we are using it for temp.

		bit 	7,(ix+SPRstatus) 			; are we erasing ?
		jr 		z,_SPRARNotErasing

		ld 		a,(_SPRFirstUDGSprite)		; B = first sprite useable
		ld 		b,a
		ld 		a,(iy+0) 					; if erasing, check if row is drawn on UDGs
		cp 		b
		jr 		c,_SPRAllocateExit 			; and if so don't allocate the row, exit.

_SPRARNotErasing:
		ld 		hl,$0000 					; we save all the allocated so far on the stack
		push 	hl 		 					; this is the end marker.
		;
		; 		Do 2 or 3. For each overwrite the XOR code addresses and save
		;		it on the stack. If it fails, then unwind everything.
		;
		call 	_SPRAllocateOne 			; do (IY)
		jr 		c,_SPRAllocateUndo 			; if done, then Undo.
		ld 		(_SPRLeftUDGPosition+1),hl 	; overwrite the code.
		push 	hl

		inc 	iy
		call 	_SPRAllocateOne 			; do (IY+1)
		jr 		c,_SPRAllocateUndo 			; if done, then Undo.
		ld 		(_SPRMiddleUDGPosition+1),hl ; overwrite the code.
		push 	hl

		bit 	0,(ix+SPRcontrol) 			; if 8 width then we are done.
		jr 		z,_SPRAllocateOkay

		inc 	iy
		call 	_SPRAllocateOne 			; do (IY+2)
		jr 		c,_SPRAllocateUndo 			; if done, then Undo.
		ld 		(_SPRRightUDGPosition+1),hl ; overwrite the code.
		jr 		_SPRAllocateOkay
		;
		; 		Failed, so pop the saved UDG addresses on the stack and reset
		;	 	as if we hadn't allocated it. We haven't bumped the usage count yet.
		;
_SPRAllocateUndo:
		pop 	de 							; address of UDG into DE
		ld 		a,d 						; have we done the whole lot ?
		or 		e
		scf
		jr 		z,_SPRAllocateExit 			; if so, e.g. popped $0000 with carry set.

		srl 	d 							; divide by 8 - will put the UDG number into E
		rr 		e
		srl 	d
		rr 		e
		srl 	d
		rr 		e
		;
		ld 		l,e 						; HL is the address of the original character for this UDG.
		ld 		h,SPROriginalChar >> 8
		ld 		a,(hl) 						; character the UDG replaced
		ld 		(hl),$FF 					; mark that UDG as now available

		ld 		h,SPRLowAddress >> 8 		; get screen address into DE
		ld 		e,(hl)
		ld 		h,SPRHighAddress >> 8
		ld 		d,(hl)

		ld 		(de),a 						; fix up screen

		jr 		_SPRAllocateUndo 			; and see if there are any more to undo
		;
		; 		Worked, exit with carry clear.
		;
_SPRAllocateOkay: 							; clear carry flag and exit.
		xor 	a
_SPRAllocateExit:
		ld 		sp,(_SPRAllocSPTemp)		; get SP back
		pop 	iy 							; restore BC IY
		pop 	bc
		ret

; *********************************************************************************************
;
; 		Allocate a single UDG sprite, overwriting (IY), saving the original and copying
; 		the definition. On exit HL points to its graphic definition.
;
; *********************************************************************************************

_SPRAllocateOne:
		ld 		a,(_SPRFirstUDGSprite)		; L = first sprite UDG
		ld 		l,a
		ld 		a,(iy+0) 					; is it a UDG already
		cp 		l 							; if so, we don't need to do anything.
		jr 		nc,_SPRAllocateOneExit
		;
		; 		Look for a free UDG, e.g. one where the stored character is $FF.
		;
		ld 		h,SPROriginalChar >> 8
_SPRAOFind: 								; look for an available UDG.
		ld 		a,(hl)
		cp 		$FF
		jr 		z,_SPRAOFound
		inc 	l
		jr 		nz,_SPRAOFind
		scf 								; nope, we just can't do this one.
		ret
;
;  		Found a sprite we can allocate
;
_SPRAOFound:
		;
		; 		Store the character overwritten by the UDG
		;
		ld 		a,(iy+0) 					; this is the original character e.g. what is underneath
		ld 		(hl),a 						; put in storage slot for original character
		;
		push 	iy 							; save the address of that character so we can restore it.
		pop 	bc 							; when it drops to zero.
		ld 		h,SPRLowAddress >> 8
		ld 		(hl),c
		ld 		h,SPRHighAddress >> 8
		ld 		(hl),b
		;
		; 		Copy the graphic definition of the original character into the UDG.
		;

		ld 		a,(iy+0) 					; get the original character , e.g. the non UDG
		ld 		(iy+0),l 					; override it.
		;
		call 	_SPRCalculateDefinitionAddr ; HL is the graphic of the original character
		ex 		de,hl
		ld 		a,(iy+0) 					; HL is the graphic of the UDG
		call 	_SPRCalculateDefinitionAddr
		ex 		de,hl 						; we want it copied there
		ld 		bc,8 						; copy 8 bytes
		ldir

		ld 		a,(iy+0) 					; get the address of the UDG and exit with CC
_SPRAllocateOneExit;
		call 	_SPRCalculateDefinitionAddr ; get the definition address in HL
		ld 		a,(_SPRInitialYOffset) 		; adjust for initial Y offset
		or 		l
		ld 		l,a
		xor 	a 							; clear carry.
		ret
;
; 		A is a character #, point HL to CRAM Address
;
_SPRCalculateDefinitionAddr:
		ld 		l,a
		ld 		h,$F0/8
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
		ret

; *********************************************************************************************
;
;							Adjust usage counter for (IY)
;
; *********************************************************************************************

SPRAdjustUsageCounter:
		ld 		l,(iy+0) 					; point HL to the usage counter
		ld 		h,SPRUsageCount >> 8
		bit 	7,(ix+SPRstatus)			; if drawn status is non-zero we are erasing
		jr 		nz,_SPRDecrementUsage
		inc 	(hl)						; increment usage counter and exit
		ret
;
_SPRDecrementUsage:
		dec 	(hl) 						; one fewer usage
		ret 	nz 							; still in use.
		;
		; 		Count zero, free up. Could consider delaying this until actually needed?
		;
		ld 		h,SPRLowAddress >> 8 		; display address in DE
		ld 		e,(hl)
		ld 		h,SPRHighAddress >> 8
		ld 		d,(hl)
		ld 		h,SPROriginalChar >> 8 		; original character written to DE
		ld 		a,(hl)
		ld 		(de),a

		ld 		(hl),$FF 					; mark the UDG as free again.
		ret


; *********************************************************************************************
;
;						Flip ADE - byteflip D or DE and swap.
;
; *********************************************************************************************

SPRFlipDE:
		ld 	 	a,d 						; flip D
		call 	_SPRFlipA
		ld 		d,a
		bit 	0,(IX+SPRcontrol)  			; if width 1 exit.
		ret 	z

		ld 		l,e 						; save E
		ld 		e,a 						; put flipped D into E
		ld 		a,l 						; get old E, flip into D
		call 	_SPRFlipA
		ld 		d,a
		ret
;
; 		Flip A
;
_SPRFlipA:
		or 		a 							; shortcut, reverse zero.
		ret 	z
		call 	_SPRFlipLow 				; flip the low nibble
		rrca 								; swap halves
		rrca
		rrca
		rrca 								; then fall through to flip high nibble.
_SPRFlipLow:
		push 	af 							; save original
		and 	$0F 						; access the flip value.
		add 	_SPRFlipTable & $FF
		ld 		l,a
		ld 		h,_SPRFlipTable >> 8
		pop 	af 							; restore original
		and 	$F0 						; replace lower nibble
		or 		(hl)
		ret
;
;		One Nibble Reversed.
;
		.align 	16,0 						; all in one page.

_SPRFlipTable:
		.db 	0,8,4,12,2,10,6,14
		.db 	1,9,5,13,3,11,7,15

; *********************************************************************************************
;
; 									General Data
;
; *********************************************************************************************

_SPRRowCount: 								; down counter for completed rows.
		.db 	0

_SPRInitialYOffset: 						; the initial vertical offset.
		.db 	0

_SPRAllocSPTemp: 							; save SP when storing interim results on stack
		.dw 	0

_SPRFirstUDGSprite: 						; first sprite available as UDG.
		.db 	$80

; *********************************************************************************************
;
;		Sprite/UDG Specific Data. Each of these is a 256 byte array aligned
; 		on a page. This is a bit wasteful if you don't have many sprites but quicker.
;
; *********************************************************************************************

		.align 	256,0

SPRDataBlock:

;
;		This is the original value stored the UDG replaced. When $FF it means
; 		this UDG is not in use.
;
SPROriginalChar:
		.ds 	256,0
;
;
; 		This is the number of sprites using the given UDG, indexed on zero.
;
SPRUsageCount:
		.ds 	256,0
;
; 		The address of that replaced UDG.
;
SPRLowAddress:
		.ds 	256,0
SPRHighAddress:
		.ds 	256,0

SPRDataBlockEnd: