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

;; [CALL] 	copy
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
;; [END]

; ***************************************************************************************

;; [CALL] 	fill
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
;; [END]

; ***************************************************************************************

;; [CALL] 	halt
__halt_loop:
		di
		halt 	
		jr 		__halt_loop
;; [END]

; ***************************************************************************************

;; [MACRO] 	break
		db 		$76
;; [END]

