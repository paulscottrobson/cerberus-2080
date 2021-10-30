


		org 	$202

;
;	 	Defining SPRLowSprite sets the lowest UDG used by sprites. This is a constant
; 		so if this is $A0, then $00-$9F are background, and $A0-$FF are used for sprites.
;
SPRLowSprite = $C0 								

;
; 		Copy a lightweight pattern to the screen.
;
		ld 		sp,$F000
		ld 		hl,$F800+40*30
_fill:	dec 	hl	
		ld 		a,l
 		and  	3
 		or 		$2C
 		ld 		(hl),a
 		ld 		(hl),$20
 		bit 	3,h
 		jr 		nz,_fill
;
;		Clear all the sprite UDGs (testing only requires this)
;
 		ld 		hl,$F000+SPRLowSprite*8
_fill2:	ld 		(hl),0
		inc 	hl
		bit 	3,h
		jr 		z,_fill2

 		call 	SPRInitialise

 		ld 		ix,SpriteDemo
 		call 	SpriteXDraw
 		di
 		call 	SpriteXDraw
_stop:	jr		_stop 		


SPRx 	= 0 								; horizontal position
SPRy 	= 2 								; vertical position
SPRgraphics = 4 							; bitmap data
SPRcontrol = 6 								; 0:width 1,2:height others zero
SPRstatus = 7 								; 7:currently drawn

; *********************************************************************************************
;
; 								Initialise the sprite system.
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
		ld 		hl,SPROriginalChar+SPRLowSprite
_SPRUsageReset:			 					
		ld 		(hl),$FF
		inc 	l
		jr 		nz,_SPRUsageReset
		pop 	hl
		pop 	af
		ret

; *********************************************************************************************
;
;
;
; *********************************************************************************************

SpriteXDraw:
		;
		;		Calculate position in IY
		;
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
		; 		Calculate the row count from bits 1 and 2 of the control byte.
		; 		(the number of vertical pixels down)
		;
		ld 		a,(ix+SPRcontrol)
		and 	$06
		ld 		b,a 						; B is 0,2,4,6 for 8,16,24,32
		xor 	a
_SPRCalcRows:
		add 	a,8
		dec 	b	
		dec 	b
		jp 		p,_SPRCalcRows	
		ld 		(_SPRRowCount),a
		;
		; 		Load BC with the sprite graphic data, we preserve this throughout
		; 		drawing.
		;
		ld 		c,(ix+SPRgraphics)
		ld 		b,(ix+SPRgraphics+1)
		;
		; 		Try to allocate UDGs for the current row at IY, 2 or 3 UDGs.
		;
_SPRStartNextCharacterRow:
		call 	_SPRAllocateRow 			; try to allocate the whole row.
		jr 		c,_SPRExit					; it didn't work, so we abandon drawing here.
		;
		;		Get the graphics for the next *pixel* line. into ADE
		;
_SPRNextRowUDG:		
		ld 		e,0							; DE = $00:BC
		ld 		a,(bc)
		ld 		d,a
		inc 	bc
		bit 	0,(ix+SPRcontrol) 					; is the width 1 ?
		jr 		z,_SPRHaveGraphicData
		ld 		e,d  						; DE = (BC+1):(BC)		
		ld 		a,(bc)
		ld 		d,a 
		inc 	bc
_SPRHaveGraphicData:		
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
		; 		Adjust the usage counters.
		;
		; TODO : Adjust usage counters.
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
		ld 		hl,_SPRLeftUDGPosition+1
		inc 	(hl)
		ld 		hl,_SPRMiddleUDGPosition+1
		inc 	(hl)
		ld 		hl,_SPRRightUDGPosition+1
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

		jr 		_SPRStartNextCharacterRow 	; do the next character row.

_SPRExit:
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
		ld 		l,a 						; HL is the address of the original character for this UDG.
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
		ld 		a,(iy+0) 					; is it a UDG already
		cp 		SPRLowSprite 				; if so, we don't need to do anything.
		jr 		nc,_SPRAllocateOneExit
		;
		; 		Look for a free UDG, e.g. one where the stored character is $FF.
		;
		ld 		hl,SPROriginalChar+SPRLowSprite
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
		;
		ld 		(iy+0),l 					; put the UDG on the screen.
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
; 									General Data
;
; *********************************************************************************************

_SPRRowCount: 								; down counter for completed rows.
		.db 	0

_SPRInitialYOffset: 						; the initial vertical offset.
		.db 	0

_SPRAllocSPTemp: 							; save SP when storing interim results on stack
		.dw 	0
		.org 	$6000

; *********************************************************************************************
;
;		Sprite/UDG Specific Data. Each of these is a 256 byte array aligned
; 		on a page.
;
; *********************************************************************************************

SPRDataBlock:

		.align 	256,0
;
;		This is the original value stored the UDG replaced. When $FF it means
; 		this UDG is not in use.
;
SPROriginalChar:
		.ds 	256
;
;
; 		This is the number of sprites using the given UDG, indexed on zero.
;
SPRUsageCount:
		.ds 	256
;
; 		The address of that replaced UDG. 
;
SPRLowAddress:
		.ds 	256
SPRHighAddress:
		.ds 	256

SPRDataBlockEnd:

; *********************************************************************************************
;										Test data
; *********************************************************************************************

		.org 	$7000
SpriteDemo:		
		.dw 	0 							; X
		.dw 	0 							; Y
		.dw 	SpriteGraphic 				; Graphics
		.dw 	$00 						; 2,1:Height 0:Width others 0.

SpriteGraphic:
		.db 	$FF,$81,$81,$81,$81,$81,$81,$FF

SpriteDemo2:		
		.dw 	19 							; X
		.dw 	28 							; Y
		.dw 	SpriteGraphic2 				; Graphics
		.dw 	$03							; 2,1:Height 0:Width others 0.

SpriteGraphic2:
		.dw 	$FFFF,$8001,$F001,$8001,$8001,$8001,$8001,$AAAA
		.dw 	$5555,$C003,$C003,$E007,$F00F,$F81F,$FC3F,$03C0

