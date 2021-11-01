
		org 	$202

;
;	 	Defining SPRLowSprite sets the lowest UDG used by sprites. This is a constant
; 		so if this is $A0, then $00-$9F are background, and $A0-$FF are used for sprites.
;
SPRLowSprite = $80 								

		jp 		start
		.include "xsprite.asm"

;
; 		Copy a lightweight pattern to the screen.
;
start:
		ld 		sp,$F000
		ld 		hl,$F800+40*30
_fill:	dec 	hl	
 		ld 		(hl),$20
 		ld 		a,l
 		add 	a,2
 		and 	3
 		jr 		nz,_fill3
; 		ld 		(hl),1
_fill3: 		
 		bit 	3,h
 		jr 		nz,_fill

 		ld 		hl,$F008
_fill4:	ld 		(hl),1
		inc 	hl
		bit 	3,l
		jr 		nz,_fill4 		

 		call 	SPRInitialise
 		ld 		ix,SpriteDemo
 		call 	DoRow
 		ld 		ix,SpriteDemo2
 		call 	DoRow
_stop:	di
		jr		_stop 		

DoRow:
 		ld 		b,8
_dloop: 		
 		call 	SpriteXDraw
 		ld 		a,(ix+6)
 		add 	a,32
 		and 	$7F
 		ld 		(ix+6),a
 		res 	7,(ix+7)

 		ld	 	a,(ix+0)
 		add 	a,28
 		ld 		(ix+0),a
 		djnz	_dloop
		ret		

; *********************************************************************************************
;										Test data
; *********************************************************************************************

SpriteDemo:		
		.dw 	4 							; X
		.dw 	10 							; Y
		.dw 	SpriteGraphic4 				; Graphics
		.dw 	$00 						; Control

SpriteGraphic:
		.db 	$FF,$81,$81,$81,$81,$81,$81,$FF

SpriteDemo2:		
		.dw 	19 							; X
		.dw 	28 							; Y
		.dw 	SpriteGraphic3	 			; Graphics
		.dw 	$03							; Control

SpriteGraphic2:
		.dw 	$FFFF,$8001,$F001,$8001,$8001,$8001,$8001,$AAAA
		.dw 	$5555,$C003,$C003,$E007,$F00F,$F81F,$FC3F,$03C0

SpriteGraphic3:
		.dw 	$8000,$4000,$2000,$1000,$0800,$0400,$0200,$0100
		.dw 	$0080,$0040,$0020,$0010,$0008,$000C,$000E,$000F

SpriteGraphic4:
		.db 	$80,$40,$20,$10,8,12,14,15