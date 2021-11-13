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
; 			Current Data: (as per xsprite.asm)
;				0..6 	X:2 	Y:2 	Graphics:2 	Control:1
;				7 		Status byte
;			To Copy data:
;				8..14 	X:2 	Y:2 	Graphics:2 	Control:1
;				15 		Change flag
;
;		When being updated, if the change flag is set, then the sprite is removed, then data 
;		(8-14) is copied to (0-6), then the sprite redrawn
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

;; [CALL] 	SPR.RESET

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

;; [END]

; *********************************************************************************************
;
;		Sprite functions/words. A sprite is selected via SPMSelect and then moved, graphics 
; 		set etc. by other functions. SPMUpdate updates all sprites. Parameters at L/HL then DE.
;
; *********************************************************************************************

;; [CALL] 	SPR.SELECT

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
;; [END]

; *********************************************************************************************
;
;										X Y SPR.MOVE
;
; *********************************************************************************************

;; [CALL] SPR.MOVE
SPMMove:
		push 	ix
		ld 		ix,(SPMCurrent)
		ld 		(ix+8),e 					; write X
		ld 		(ix+9),d
		ld 		(ix+10),l 					; write Y
		ld 		(ix+11),h
_SPMGeneralExit:
		set 	7,(ix+15)
		pop 	ix
		ret
;;[END]

; *********************************************************************************************
;
;									   GDATA SPR.IMAGE
;
; *********************************************************************************************

;; [CALL] SPR.IMAGE
SPRImage:
		push 	ix
		ld 		ix,(SPMCurrent)
		ld 		(ix+12),l
		ld 		(ix+13),h
		jr 		_SPMGeneralExit
;; [END]

; *********************************************************************************************
;
;									   CBYTE SPR.CONTROL
;
; *********************************************************************************************

;; [CALL] SPR.CONTROL
SPMControl:
		push 	ix
		ld 		ix,(SPMCurrent)
		ld 		(ix+14),l
		jr 		_SPMGeneralExit
;; [END]

; *********************************************************************************************
;
;							   <bool> SPR.VFLIP / HFLIP
;
; *********************************************************************************************

;; [CALL] SPR.HFLIP
SPMHFlip:
		push 	af
		push 	ix
		ld 		ix,(SPMCurrent)
		res 	5,(ix+14)
		ld 		a,l
		or 		h
		jr 		z,_SPCTExit
		set 	5,(ix+14)
		jr 		_SPCTExit
;; [END]

;; [CALL] SPR.VFLIP
SPMVFlip:
		push 	af
		push 	ix
		ld 		ix,(SPMCurrent)
		res 	6,(ix+14)
		ld 		a,l
		or 		h
		jr 		z,_SPCTExit
		set 	7,(ix+14)
_SPCTExit:
		set 	7,(ix+15)
		pop 	ix
		pop 	af
		ret
;; [END]

; *********************************************************************************************
;
;										Update all sprites
;
; *********************************************************************************************

;; [CALL] 	SPR.UPDATE

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
		ld 		a,(ix+15) 					; check redraw flag
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
		ld 		(ix+15),0 					; clear the redraw flag.
		call 	SpriteXErase 				; erase sprite
		push 	ix 							; copy target address in DE
		pop 	de
		ld 		hl,8
		add 	hl,de 						; target DE, source HL
		ld 		bc,7 						; copy 7 bytes over
		ldir 
		call 	SpriteXDraw 				; redraw sprite
		pop 	bc
		ret
;; [END]

; *********************************************************************************************
;
;							Hide all sprites (to change background)
;
; *********************************************************************************************

;; [CALL] 	SPR.HIDE.ALL

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
		set 	7,(ix+15) 					; force redraw next update
		add 	ix,de
		djnz 	_SPMHideLoop
		pop 	hl
		pop 	bc
		pop 	de
		pop 	af
		ret		
;; [END]

SPMData: 									; address of sprite
		.dw 	0
SPMCount: 									; number of sprites
		.dw 	0
SPMCurrent: 								; currently selected sprite (may point to unused junk space)
		.dw 	0		
SPMUnused: 									; space for junk writes.
		.ds 	16,0
