


		org 	$202


;
;	 	Defining SPRLowSprite sets the lowest UDG used by sprites. This is a constant
; 		so if this is $A0, then $00-$9F are background, and $A0-$FF are used for sprites.
;
SPRLowSprite = $C0 								

		jp 		start
		.include "xsprite.asm"

;
; 		Copy a lightweight pattern to the screen.
;
start:
		ld 		sp,$F000
		ld 		hl,$F800+40*30
_fill:	dec 	hl	
		ld 		a,l
 		and  	3
 		or 		$2C
 		ld 		(hl),a
; 		ld 		(hl),$20
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
 		ld 		ix,SpriteDemo2
 		ld 		hl,1
_dloop: 		
 		call 	SpriteXDraw
 		dec 	hl
 		ld 		a,h
 		or 		l
 		jr 		nz,_dloop

_stop:	di
		jr		_stop 		

; *********************************************************************************************
;										Test data
; *********************************************************************************************

SpriteDemo:		
		.dw 	4 							; X
		.dw 	10 							; Y
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

