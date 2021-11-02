
		org 	$202

;
;	 	Defining SPRLowSprite sets the lowest UDG used by sprites. This is a constant
; 		so if this is $A0, then $00-$9F are background, and $A0-$FF are used for sprites.
;
SPRLowSprite = $80 								
SpriteCount = 8

		jp 		start
		.include 	"spritemanager.asm"
		.include 	"xsprite.asm"

start:
		di
		ld 		hl,SpriteData
		ld 		de,SpriteCount
		call 	SPMReset


; *********************************************************************************************
;										Test data
; *********************************************************************************************

SpriteData:
		.ds 	16*SPMCount

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

