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
; 									Allocate lowest UDG
;
; *********************************************************************************************

;; [CALL] SPRITE.UDG.BASE!
SpriteSetLowestUDG:
		push 	af
		ld 		a,l
		ld 		(_SPRFirstUDGSprite),a
		pop 	af
		ret
;; [END]

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
