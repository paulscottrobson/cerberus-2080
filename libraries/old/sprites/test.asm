;
;		TODO:
;			Restore
;			Range Check
;			Wrap
;
;		At 4Mhz
; 			Can draw 500/sec
;			Going to be very flickery.
;			Need to go for minimum change.
;

		org 	$202
;
; 		Copy a predicatable pattern using the block graphics to the screen.
;
		ld 		sp,$F000

		ld 		hl,$F800
		ld 		b,8
fill:	ld 		(hl),l
		res 	7,(hl)
		ld 		b,' '
		inc 	hl
		ld 		a,h	
		cp 		$FD
		jr 		nz,fill

		ld 		ix,graphictestdata

		ld 		bc,5000
l1:		
		push 	bc
		ld 		c,3
		ld 		de,10
		ld 		hl,2
		call 	DrawSprite
		pop 	bc
		dec 	bc
		ld 		a,b
		or 		c
		jr 		nz,l1

h1:		di
		jp 		h1

spriteLowUDG: 								; lowest sprite available.
		.db 	$80

spriteNextUDG: 								; next sprite available.
		.db 	$80

spriteInitialYOffset: 						; first time Y offset, used for fine vertical positioning.
			.db 	0

;
; 		HL 	Vertical coordinates
; 		DE 	Horizontal Coordinates
; 		IX 	address of bitmap data.		
;		C 	Bit 0, width 1/2
;			Bit 1, height 1/2
;			Bit 2..7 , zero
;

DrawSprite:
		push 	af
		push 	bc
		push 	de
		push 	hl
		push 	ix
		push 	iy
;
; 		Set fine initial Y offset
;
		ld 		a,l
		and 	7
		ld 		(spriteInitialYOffset),a
;
; 		Work the out the left shift for fine horizontal scrolling.
;
		ld 		a,e
		and 	7 							; this is the number of shifts to skip.
		add 	a,a 						; because its ADD HL,HL ; ADC A,A
		ld 		(spriteShiftJumpPatch+1),a 	; patch the jump.
;
; 		Calculate the screen position and put into IY
;
		srl 	e 							; divide DE by 8 and push on stack.
		srl 	e
		srl 	e
		push 	de

		ld 		a,l 						; HL already x 8, so we clear bits 0..2 to make it a boundary
		and 	$F8
		ld 		l,a

		ld 		d,h 						; DE <= HL		
		ld 		e,l
		add 	hl,hl 						; HL x 16
		add 	hl,hl 						; HL x 32
		add 	hl,de 						; HL x 40
		pop 	de 							; get X/8 back
		add 	hl,de  						
		ld 		de,$F800 					; point to screen
		add 	hl,de

		push 	hl 							; and put in IY
		pop 	iy
;
; 		Work out lines to draw in B, based on C bit 1
;
		ld 		b,8
		bit 	1,c
		jr 		z,spriteIsSingleHeight
		ld 		b,16
spriteIsSingleHeight:		
;
; 		Do the next line of the graphics - this is one line on the character display
; 		with up to 8 rows of pixels.
;
;				IX points to the graphics data.	
;				IY points to the character data, left most.
;
spriteNextLine:
;
; 		First thing is to make the characters underneath UDGs in range if they aren't already
; 		We overwrite the drawing addresses in the OR section below.
;
;		If it can't do the UDG conversion, then it will simply give up, as there's not enough
;		graphics characters to draw what is wanted.
;
		push 	iy
		call 	spriteMakeUDG 				; do left
		jr 		c,spriteFail
		ld 		(spriteInstrL+1),hl
		inc 	iy

		call 	spriteMakeUDG 				; do middle
		jr 		c,spriteFail
		ld 		(spriteInstrM+1),hl
		bit 	0,c  						; do right if double width.
		jr 		z,spriteNotDouble 
		inc 	iy
		call 	spriteMakeUDG
		jr 		c,spriteFail
		ld 		(spriteInstrR+1),hl
spriteNotDouble:
		pop 	iy 							; IY is back again.		
;
;		Get the graphic data into AHL
;
spriteDoNextUDGLine:
		xor 	a 							; zero the upper and lower bit
		ld 		l,a
		ld 		h,(ix+0)					; get first graphic byte
		inc 	ix
		bit 	0,c 						; if 1 char width ready for shifting.
		jr 		z,spriteShift
		ld 		l,h 						; that is the LSB
		ld 		h,(ix+0) 					; get the second graphic byte
		inc 	ix
spriteShift:		
;
;		Shift the graphic data
;
spriteShiftJumpPatch:
		jr 		$+2		

		add 	hl,hl 						; 8 24 bit shifts of AHL
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


;
; 		Now the sprite data is in A H L, or into the memory as set up.
;		
l		ex 		de,hl 						; graphic data in A D E
spriteInstrL:
		ld 		hl,$F400 					; the left most byte in A first.
		or 		(hl)
		ld 		(hl),a
		;
spriteInstrM:		
		ld 		hl,$F408 					; the middle byte in D
		ld 		a,d
		or 		(hl)
		ld 		(hl),a
		;
		bit 	0,c 						; are we only doing 8 wide sprites
		jr 		z,spriteDown 				; if so, don't do the right most byte.
		;
spriteInstrR:	 							; the right byte in E
		ld 		hl,$F410
		ld 		a,e
		or 		(hl)
		ld 		(hl),a
;
; 		Advance all the write addresses by 1, e.g. 1 line down.
;
spriteDown:
		dec 	b 							; have we done all the vertical lines
		jr 		z,spriteDrawn

		ld 		hl,spriteInstrL+1
		inc 	(hl)
		ld 		hl,spriteInstrM+1
		inc 	(hl)
		ld 		hl,spriteInstrR+1 			
		inc 	(hl)
		;
		ld 		a,(hl) 						; have we switched bytes, e.g. done 7.
		and 	7
		jr 		nz,spriteDoNextUDGLine 		; no, we can carry on copying.

		ld 		(spriteInitialYOffset),a 	; reset the initial Y offset to zero from here on.

		ld 		de,40 						; advance the on screen pointer by one line
		add 	iy,de
		jr 		spriteNextLine 				; and keep drawing out.

spriteFail:
		pop 	iy

spriteDrawn:
		pop 	iy
		pop 	ix
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

;
; 		Convert the character at IY to a UDG in the allocated space.
; 		Return HL = Data address, CC if okay, CS if failed.
;		Preserves BC.
;
spriteMakeUDG:
		ld 		a,(iy+0) 					; get the character there
		ld 		hl,spriteLowUDG 			; if >= spriteLowUDG it is *already* a UDG.
		cp 		(hl)
		jr 		nc,spriteCalcExit 			; calculate the position and exit.

		ld 		hl,spriteNextUDG			; number of next free UDG into A.
		ld 		a,(hl) 
		or 		a 					
		scf 								; if zero, we are out, so return with carry set, we can't convert it.
		ret 	z

		inc 	(hl) 						; bump the next free UDG element
		ld 		l,a 						; put the number into L
		ld 		h,spriteOldCharOriginal/256	; going to save the character we are replacing.
		ld 		a,(iy+0)   
		ld 		(hl),a
		push 	af 							; save that character
		;
		push 	iy 							; put the address of that character into DE and write that out.
		pop 	de
		ld 		h,spriteOldCharLow/256
		ld 		(hl),e
		ld 		h,spriteOldCharHigh/256
		ld 		(hl),d
		;
		ld 		(iy+0),l 					; replace the screen character with the UDG.

		ld 		a,l 						; DE = Graphic image of character we have just used
		call 	spriteDefinitionToHL		
		ex 		de,hl
		pop 	af 							; HL = Graphic image of original character
		call 	spriteDefinitionToHL
		push 	bc 							; copy original image to newly acquired UDG, thus preserving the background.
		ld 		bc,8
		ldir 
		pop 	bc 

		ld 		a,(iy+0) 					; get the graphic to use back

spriteCalcExit:
		call 	spriteDefinitionToHL 		; get its address

		ld 		a,(spriteInitialYOffset)	; add the initial Y sprite offset to HL. It can't carry out of bit 7, address
		add 	a,l 						; is divisible by 8.	
		ld 		l,a

		xor 	a 							; return with CC
		ret
;
; 		Sprite # in A to address of UDG in HL.
;
spriteDefinitionToHL:
		ld 		l,a 						; put UDG# in L
		ld 		h,$F0/8 					; as we're going to x 8, this will go back to F0
		add 	hl,hl
		add 	hl,hl
		add 	hl,hl
		ret


		.align 	256,0
spriteOldCharLow: 							; screen addresses that have been replaced (Low)
		.ds 	256
spriteOldCharHigh:
		.ds 	256
spriteOldCharOriginal:
		.ds 	256

graphictestdata:

		.dw 	$FFFF
		.dw 	$5555
		.dw 	$AAAA
		.dw 	$8801

		.dw 	$8801
		.dw 	$8801
		.dw 	$8801
		.dw 	$FFFF

		.dw 	$8001
		.dw 	$C003
		.dw 	$E007
		.dw 	$F00F

		.dw 	$F81F
		.dw 	$FC3F
		.dw 	$FE7F
		.dw 	$FFFF

gtd2:
		.db 	$18
		.db 	$3C
		.db 	$7E
		.db 	$FF
		.db 	$FF
		.db 	$7E
		.db 	$3C
		.db 	$18
		.db 	$18
		.db 	$3C
		.db 	$7E
		.db 	$FF
		.db 	$FF
		.db 	$7E
		.db 	$3C
		.db 	$18

