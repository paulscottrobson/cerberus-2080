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
		ld 		hl,0 						; no current selection
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
		ld 		hl,$0000
_SPMSExit:
		ld 		(SPMCurrent),hl
		pop 	hl
		pop 	de
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


;; [END]

SPMData: 									; address of sprite
		.dw 	0
SPMCount: 									; number of sprites
		.dw 	0
SPMCurrent: 								; currently selected sprite (0 = None.)
		.dw 	0		
