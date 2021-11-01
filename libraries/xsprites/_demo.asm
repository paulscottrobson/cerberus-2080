
		org 	$202

;
;	 	Defining SPRLowSprite sets the lowest UDG used by sprites. This is a constant
; 		so if this is $A0, then $00-$9F are background, and $A0-$FF are used for sprites.
;
SPRLowSprite = $40 								

SpriteCount = 16	

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
 		ld 		(hl),1
_fill3: 		
 		bit 	3,h
 		jr 		nz,_fill

 		ld 		hl,$F008
_fill4:	ld 		(hl),1
		inc 	hl
		bit 	3,l
		jr 		nz,_fill4 		

		ld 		a,1
		ld 		($F000+32*8+4),a
 		call 	SPRInitialise

 		ld 		ix,SpriteBuffer
 		ld 		b,SpriteCount
_create:
		ld 		a,b
		add 	a,a
		add 	a,a		
		add 	a,a
		add 	a,8
		ld 		(ix+0),a
		ld 		(ix+1),0
		add 	a,a
		ld 		(ix+2),a
		ld 		(ix+3),0
		ld 		(ix+4),SpriteGraphic & 0xFF
		ld 		(ix+5),SpriteGraphic >> 8
		ld 		(ix+6),$3
		ld 		(ix+7),0
		ld 		(ix+8),1 				; xi
		bit 	0,b
		jr 		z,_create1
		ld 		(ix+8),255 
_create1:		
		ld 		(ix+9),1 				; yi
		bit 	1,b
		jr 		z,_create2
		ld 		(ix+9),255
_create2:		
 		ld 		de,10
 		add 	ix,de
 		djnz 	_create

 		ld 		hl,0
 		ld 		($0100),hl

_loop1:	ld 		ix,SpriteBuffer
		ld 		b,SpriteCount
_loop2:	
		call 	SpriteXErase
		call 	moveOne
		call 	SpriteXDraw

		ld 		hl,($0100)
		inc 	hl
		inc 	hl
 		ld 		($0100),hl

 		ld 		de,10
 		add 	ix,de
		djnz 	_loop2
		jr 		_loop1

_stop:	di
		jr		_stop 		

moveOne:
		ld 		a,(ix+8)
		call 	advance
		ld 		(ix+8),a
		ld 		a,(ix+9)
		push 	ix
		inc 	ix
		inc 	ix
		call 	advance
		pop 	ix		
		ld 		(ix+9),a

		ld 		a,(ix+6)
		and 	#$9F
		bit 	7,(ix+8)
		jr 		z,_notright
		set 	5,a
_notright:		
		bit 	7,(ix+9)
		jr 		z,_notleft
		set 	6,a
_notleft:		
		ld 		(ix+6),a

		ld 	 	hl,SpriteGraphic
		bit 	4,(ix+0)
		jr 		z,_anim1
		ld 		hl,SpriteGraphic2
_anim1:		
		ld 		(ix+4),l
		ld 		(ix+5),h
		ret

advance:ld 		c,a
		add 	a,a
		add 	a,a
		add 	a,(ix+0)
		ld 		(ix+0),a
		cp 		16
		jr 		c,_adv2
		cp 		240
		jr 		nc,_adv2
		ld 		a,c
		ret
_adv2:
		ld 		a,c
		neg
		ret

; *********************************************************************************************
;										Test data
; *********************************************************************************************

SpriteBuffer:		
		.ds 	SpriteCount * 20


SpriteGraphic:
		.dw 	$0FF0,$1008,$2004,$4002,$8001,$8001,$8001,$8001
		.dw 	$80FF,$8080,$8080,$8080,$4080,$2080,$1080,$0F80

SpriteGraphic2:
		.dw 	$0FF0,$1008,$2004,$4002,$8001,$8001,$8001,$8001
		.dw 	$8001,$8001,$8001,$8001,$4002,$2004,$1008,$0FF0

