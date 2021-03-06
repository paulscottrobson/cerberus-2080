//
//	This file is automatically generated
//
case 0x00: /**** $00:rlc b ****/
	B = ZSRRLC(B);
	CYCLES(8);break;

case 0x01: /**** $01:rlc c ****/
	C = ZSRRLC(C);
	CYCLES(8);break;

case 0x02: /**** $02:rlc d ****/
	D = ZSRRLC(D);
	CYCLES(8);break;

case 0x03: /**** $03:rlc e ****/
	E = ZSRRLC(E);
	CYCLES(8);break;

case 0x04: /**** $04:rlc h ****/
	H = ZSRRLC(H);
	CYCLES(8);break;

case 0x05: /**** $05:rlc l ****/
	L = ZSRRLC(L);
	CYCLES(8);break;

case 0x06: /**** $06:rlc (hl) ****/
	temp8 = READ8(HL()); temp8 = ZSRRLC(temp8); WRITE8(HL(),temp8);;
	CYCLES(15);break;

case 0x07: /**** $07:rlc a ****/
	A = ZSRRLC(A);
	CYCLES(8);break;

case 0x08: /**** $08:rrc b ****/
	B = ZSRRRC(B);
	CYCLES(8);break;

case 0x09: /**** $09:rrc c ****/
	C = ZSRRRC(C);
	CYCLES(8);break;

case 0x0a: /**** $0a:rrc d ****/
	D = ZSRRRC(D);
	CYCLES(8);break;

case 0x0b: /**** $0b:rrc e ****/
	E = ZSRRRC(E);
	CYCLES(8);break;

case 0x0c: /**** $0c:rrc h ****/
	H = ZSRRRC(H);
	CYCLES(8);break;

case 0x0d: /**** $0d:rrc l ****/
	L = ZSRRRC(L);
	CYCLES(8);break;

case 0x0e: /**** $0e:rrc (hl) ****/
	temp8 = READ8(HL()); temp8 = ZSRRRC(temp8); WRITE8(HL(),temp8);;
	CYCLES(15);break;

case 0x0f: /**** $0f:rrc a ****/
	A = ZSRRRC(A);
	CYCLES(8);break;

case 0x10: /**** $10:rl b ****/
	B = ZSRRL(B);
	CYCLES(8);break;

case 0x11: /**** $11:rl c ****/
	C = ZSRRL(C);
	CYCLES(8);break;

case 0x12: /**** $12:rl d ****/
	D = ZSRRL(D);
	CYCLES(8);break;

case 0x13: /**** $13:rl e ****/
	E = ZSRRL(E);
	CYCLES(8);break;

case 0x14: /**** $14:rl h ****/
	H = ZSRRL(H);
	CYCLES(8);break;

case 0x15: /**** $15:rl l ****/
	L = ZSRRL(L);
	CYCLES(8);break;

case 0x16: /**** $16:rl (hl) ****/
	temp8 = READ8(HL()); temp8 = ZSRRL(temp8); WRITE8(HL(),temp8);;
	CYCLES(15);break;

case 0x17: /**** $17:rl a ****/
	A = ZSRRL(A);
	CYCLES(8);break;

case 0x18: /**** $18:rr b ****/
	B = ZSRRR(B);
	CYCLES(8);break;

case 0x19: /**** $19:rr c ****/
	C = ZSRRR(C);
	CYCLES(8);break;

case 0x1a: /**** $1a:rr d ****/
	D = ZSRRR(D);
	CYCLES(8);break;

case 0x1b: /**** $1b:rr e ****/
	E = ZSRRR(E);
	CYCLES(8);break;

case 0x1c: /**** $1c:rr h ****/
	H = ZSRRR(H);
	CYCLES(8);break;

case 0x1d: /**** $1d:rr l ****/
	L = ZSRRR(L);
	CYCLES(8);break;

case 0x1e: /**** $1e:rr (hl) ****/
	temp8 = READ8(HL()); temp8 = ZSRRR(temp8); WRITE8(HL(),temp8);;
	CYCLES(15);break;

case 0x1f: /**** $1f:rr a ****/
	A = ZSRRR(A);
	CYCLES(8);break;

case 0x20: /**** $20:sla b ****/
	B = ZSRSLA(B);
	CYCLES(8);break;

case 0x21: /**** $21:sla c ****/
	C = ZSRSLA(C);
	CYCLES(8);break;

case 0x22: /**** $22:sla d ****/
	D = ZSRSLA(D);
	CYCLES(8);break;

case 0x23: /**** $23:sla e ****/
	E = ZSRSLA(E);
	CYCLES(8);break;

case 0x24: /**** $24:sla h ****/
	H = ZSRSLA(H);
	CYCLES(8);break;

case 0x25: /**** $25:sla l ****/
	L = ZSRSLA(L);
	CYCLES(8);break;

case 0x26: /**** $26:sla (hl) ****/
	temp8 = READ8(HL()); temp8 = ZSRSLA(temp8); WRITE8(HL(),temp8);;
	CYCLES(15);break;

case 0x27: /**** $27:sla a ****/
	A = ZSRSLA(A);
	CYCLES(8);break;

case 0x28: /**** $28:sra b ****/
	B = ZSRSRA(B);
	CYCLES(8);break;

case 0x29: /**** $29:sra c ****/
	C = ZSRSRA(C);
	CYCLES(8);break;

case 0x2a: /**** $2a:sra d ****/
	D = ZSRSRA(D);
	CYCLES(8);break;

case 0x2b: /**** $2b:sra e ****/
	E = ZSRSRA(E);
	CYCLES(8);break;

case 0x2c: /**** $2c:sra h ****/
	H = ZSRSRA(H);
	CYCLES(8);break;

case 0x2d: /**** $2d:sra l ****/
	L = ZSRSRA(L);
	CYCLES(8);break;

case 0x2e: /**** $2e:sra (hl) ****/
	temp8 = READ8(HL()); temp8 = ZSRSRA(temp8); WRITE8(HL(),temp8);;
	CYCLES(15);break;

case 0x2f: /**** $2f:sra a ****/
	A = ZSRSRA(A);
	CYCLES(8);break;

case 0x38: /**** $38:srl b ****/
	B = ZSRSRL(B);
	CYCLES(8);break;

case 0x39: /**** $39:srl c ****/
	C = ZSRSRL(C);
	CYCLES(8);break;

case 0x3a: /**** $3a:srl d ****/
	D = ZSRSRL(D);
	CYCLES(8);break;

case 0x3b: /**** $3b:srl e ****/
	E = ZSRSRL(E);
	CYCLES(8);break;

case 0x3c: /**** $3c:srl h ****/
	H = ZSRSRL(H);
	CYCLES(8);break;

case 0x3d: /**** $3d:srl l ****/
	L = ZSRSRL(L);
	CYCLES(8);break;

case 0x3e: /**** $3e:srl (hl) ****/
	temp8 = READ8(HL()); temp8 = ZSRSRL(temp8); WRITE8(HL(),temp8);;
	CYCLES(15);break;

case 0x3f: /**** $3f:srl a ****/
	A = ZSRSRL(A);
	CYCLES(8);break;

case 0x40: /**** $40:bit 0,b ****/
	zBitOp(B & 1);
	CYCLES(8);break;

case 0x41: /**** $41:bit 0,c ****/
	zBitOp(C & 1);
	CYCLES(8);break;

case 0x42: /**** $42:bit 0,d ****/
	zBitOp(D & 1);
	CYCLES(8);break;

case 0x43: /**** $43:bit 0,e ****/
	zBitOp(E & 1);
	CYCLES(8);break;

case 0x44: /**** $44:bit 0,h ****/
	zBitOp(H & 1);
	CYCLES(8);break;

case 0x45: /**** $45:bit 0,l ****/
	zBitOp(L & 1);
	CYCLES(8);break;

case 0x46: /**** $46:bit 0,(hl) ****/
	zBitOp(READ8(HL()) & 1);
	CYCLES(12);break;

case 0x47: /**** $47:bit 0,a ****/
	zBitOp(A & 1);
	CYCLES(8);break;

case 0x48: /**** $48:bit 1,b ****/
	zBitOp(B & 2);
	CYCLES(8);break;

case 0x49: /**** $49:bit 1,c ****/
	zBitOp(C & 2);
	CYCLES(8);break;

case 0x4a: /**** $4a:bit 1,d ****/
	zBitOp(D & 2);
	CYCLES(8);break;

case 0x4b: /**** $4b:bit 1,e ****/
	zBitOp(E & 2);
	CYCLES(8);break;

case 0x4c: /**** $4c:bit 1,h ****/
	zBitOp(H & 2);
	CYCLES(8);break;

case 0x4d: /**** $4d:bit 1,l ****/
	zBitOp(L & 2);
	CYCLES(8);break;

case 0x4e: /**** $4e:bit 1,(hl) ****/
	zBitOp(READ8(HL()) & 2);
	CYCLES(12);break;

case 0x4f: /**** $4f:bit 1,a ****/
	zBitOp(A & 2);
	CYCLES(8);break;

case 0x50: /**** $50:bit 2,b ****/
	zBitOp(B & 4);
	CYCLES(8);break;

case 0x51: /**** $51:bit 2,c ****/
	zBitOp(C & 4);
	CYCLES(8);break;

case 0x52: /**** $52:bit 2,d ****/
	zBitOp(D & 4);
	CYCLES(8);break;

case 0x53: /**** $53:bit 2,e ****/
	zBitOp(E & 4);
	CYCLES(8);break;

case 0x54: /**** $54:bit 2,h ****/
	zBitOp(H & 4);
	CYCLES(8);break;

case 0x55: /**** $55:bit 2,l ****/
	zBitOp(L & 4);
	CYCLES(8);break;

case 0x56: /**** $56:bit 2,(hl) ****/
	zBitOp(READ8(HL()) & 4);
	CYCLES(12);break;

case 0x57: /**** $57:bit 2,a ****/
	zBitOp(A & 4);
	CYCLES(8);break;

case 0x58: /**** $58:bit 3,b ****/
	zBitOp(B & 8);
	CYCLES(8);break;

case 0x59: /**** $59:bit 3,c ****/
	zBitOp(C & 8);
	CYCLES(8);break;

case 0x5a: /**** $5a:bit 3,d ****/
	zBitOp(D & 8);
	CYCLES(8);break;

case 0x5b: /**** $5b:bit 3,e ****/
	zBitOp(E & 8);
	CYCLES(8);break;

case 0x5c: /**** $5c:bit 3,h ****/
	zBitOp(H & 8);
	CYCLES(8);break;

case 0x5d: /**** $5d:bit 3,l ****/
	zBitOp(L & 8);
	CYCLES(8);break;

case 0x5e: /**** $5e:bit 3,(hl) ****/
	zBitOp(READ8(HL()) & 8);
	CYCLES(12);break;

case 0x5f: /**** $5f:bit 3,a ****/
	zBitOp(A & 8);
	CYCLES(8);break;

case 0x60: /**** $60:bit 4,b ****/
	zBitOp(B & 16);
	CYCLES(8);break;

case 0x61: /**** $61:bit 4,c ****/
	zBitOp(C & 16);
	CYCLES(8);break;

case 0x62: /**** $62:bit 4,d ****/
	zBitOp(D & 16);
	CYCLES(8);break;

case 0x63: /**** $63:bit 4,e ****/
	zBitOp(E & 16);
	CYCLES(8);break;

case 0x64: /**** $64:bit 4,h ****/
	zBitOp(H & 16);
	CYCLES(8);break;

case 0x65: /**** $65:bit 4,l ****/
	zBitOp(L & 16);
	CYCLES(8);break;

case 0x66: /**** $66:bit 4,(hl) ****/
	zBitOp(READ8(HL()) & 16);
	CYCLES(12);break;

case 0x67: /**** $67:bit 4,a ****/
	zBitOp(A & 16);
	CYCLES(8);break;

case 0x68: /**** $68:bit 5,b ****/
	zBitOp(B & 32);
	CYCLES(8);break;

case 0x69: /**** $69:bit 5,c ****/
	zBitOp(C & 32);
	CYCLES(8);break;

case 0x6a: /**** $6a:bit 5,d ****/
	zBitOp(D & 32);
	CYCLES(8);break;

case 0x6b: /**** $6b:bit 5,e ****/
	zBitOp(E & 32);
	CYCLES(8);break;

case 0x6c: /**** $6c:bit 5,h ****/
	zBitOp(H & 32);
	CYCLES(8);break;

case 0x6d: /**** $6d:bit 5,l ****/
	zBitOp(L & 32);
	CYCLES(8);break;

case 0x6e: /**** $6e:bit 5,(hl) ****/
	zBitOp(READ8(HL()) & 32);
	CYCLES(12);break;

case 0x6f: /**** $6f:bit 5,a ****/
	zBitOp(A & 32);
	CYCLES(8);break;

case 0x70: /**** $70:bit 6,b ****/
	zBitOp(B & 64);
	CYCLES(8);break;

case 0x71: /**** $71:bit 6,c ****/
	zBitOp(C & 64);
	CYCLES(8);break;

case 0x72: /**** $72:bit 6,d ****/
	zBitOp(D & 64);
	CYCLES(8);break;

case 0x73: /**** $73:bit 6,e ****/
	zBitOp(E & 64);
	CYCLES(8);break;

case 0x74: /**** $74:bit 6,h ****/
	zBitOp(H & 64);
	CYCLES(8);break;

case 0x75: /**** $75:bit 6,l ****/
	zBitOp(L & 64);
	CYCLES(8);break;

case 0x76: /**** $76:bit 6,(hl) ****/
	zBitOp(READ8(HL()) & 64);
	CYCLES(12);break;

case 0x77: /**** $77:bit 6,a ****/
	zBitOp(A & 64);
	CYCLES(8);break;

case 0x78: /**** $78:bit 7,b ****/
	zBitOp(B & 128);
	CYCLES(8);break;

case 0x79: /**** $79:bit 7,c ****/
	zBitOp(C & 128);
	CYCLES(8);break;

case 0x7a: /**** $7a:bit 7,d ****/
	zBitOp(D & 128);
	CYCLES(8);break;

case 0x7b: /**** $7b:bit 7,e ****/
	zBitOp(E & 128);
	CYCLES(8);break;

case 0x7c: /**** $7c:bit 7,h ****/
	zBitOp(H & 128);
	CYCLES(8);break;

case 0x7d: /**** $7d:bit 7,l ****/
	zBitOp(L & 128);
	CYCLES(8);break;

case 0x7e: /**** $7e:bit 7,(hl) ****/
	zBitOp(READ8(HL()) & 128);
	CYCLES(12);break;

case 0x7f: /**** $7f:bit 7,a ****/
	zBitOp(A & 128);
	CYCLES(8);break;

case 0x80: /**** $80:res 0,b ****/
	B &= (~1);
	CYCLES(8);break;

case 0x81: /**** $81:res 0,c ****/
	C &= (~1);
	CYCLES(8);break;

case 0x82: /**** $82:res 0,d ****/
	D &= (~1);
	CYCLES(8);break;

case 0x83: /**** $83:res 0,e ****/
	E &= (~1);
	CYCLES(8);break;

case 0x84: /**** $84:res 0,h ****/
	H &= (~1);
	CYCLES(8);break;

case 0x85: /**** $85:res 0,l ****/
	L &= (~1);
	CYCLES(8);break;

case 0x86: /**** $86:res 0,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~1));;
	CYCLES(12);break;

case 0x87: /**** $87:res 0,a ****/
	A &= (~1);
	CYCLES(8);break;

case 0x88: /**** $88:res 1,b ****/
	B &= (~2);
	CYCLES(8);break;

case 0x89: /**** $89:res 1,c ****/
	C &= (~2);
	CYCLES(8);break;

case 0x8a: /**** $8a:res 1,d ****/
	D &= (~2);
	CYCLES(8);break;

case 0x8b: /**** $8b:res 1,e ****/
	E &= (~2);
	CYCLES(8);break;

case 0x8c: /**** $8c:res 1,h ****/
	H &= (~2);
	CYCLES(8);break;

case 0x8d: /**** $8d:res 1,l ****/
	L &= (~2);
	CYCLES(8);break;

case 0x8e: /**** $8e:res 1,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~2));;
	CYCLES(12);break;

case 0x8f: /**** $8f:res 1,a ****/
	A &= (~2);
	CYCLES(8);break;

case 0x90: /**** $90:res 2,b ****/
	B &= (~4);
	CYCLES(8);break;

case 0x91: /**** $91:res 2,c ****/
	C &= (~4);
	CYCLES(8);break;

case 0x92: /**** $92:res 2,d ****/
	D &= (~4);
	CYCLES(8);break;

case 0x93: /**** $93:res 2,e ****/
	E &= (~4);
	CYCLES(8);break;

case 0x94: /**** $94:res 2,h ****/
	H &= (~4);
	CYCLES(8);break;

case 0x95: /**** $95:res 2,l ****/
	L &= (~4);
	CYCLES(8);break;

case 0x96: /**** $96:res 2,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~4));;
	CYCLES(12);break;

case 0x97: /**** $97:res 2,a ****/
	A &= (~4);
	CYCLES(8);break;

case 0x98: /**** $98:res 3,b ****/
	B &= (~8);
	CYCLES(8);break;

case 0x99: /**** $99:res 3,c ****/
	C &= (~8);
	CYCLES(8);break;

case 0x9a: /**** $9a:res 3,d ****/
	D &= (~8);
	CYCLES(8);break;

case 0x9b: /**** $9b:res 3,e ****/
	E &= (~8);
	CYCLES(8);break;

case 0x9c: /**** $9c:res 3,h ****/
	H &= (~8);
	CYCLES(8);break;

case 0x9d: /**** $9d:res 3,l ****/
	L &= (~8);
	CYCLES(8);break;

case 0x9e: /**** $9e:res 3,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~8));;
	CYCLES(12);break;

case 0x9f: /**** $9f:res 3,a ****/
	A &= (~8);
	CYCLES(8);break;

case 0xa0: /**** $a0:res 4,b ****/
	B &= (~16);
	CYCLES(8);break;

case 0xa1: /**** $a1:res 4,c ****/
	C &= (~16);
	CYCLES(8);break;

case 0xa2: /**** $a2:res 4,d ****/
	D &= (~16);
	CYCLES(8);break;

case 0xa3: /**** $a3:res 4,e ****/
	E &= (~16);
	CYCLES(8);break;

case 0xa4: /**** $a4:res 4,h ****/
	H &= (~16);
	CYCLES(8);break;

case 0xa5: /**** $a5:res 4,l ****/
	L &= (~16);
	CYCLES(8);break;

case 0xa6: /**** $a6:res 4,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~16));;
	CYCLES(12);break;

case 0xa7: /**** $a7:res 4,a ****/
	A &= (~16);
	CYCLES(8);break;

case 0xa8: /**** $a8:res 5,b ****/
	B &= (~32);
	CYCLES(8);break;

case 0xa9: /**** $a9:res 5,c ****/
	C &= (~32);
	CYCLES(8);break;

case 0xaa: /**** $aa:res 5,d ****/
	D &= (~32);
	CYCLES(8);break;

case 0xab: /**** $ab:res 5,e ****/
	E &= (~32);
	CYCLES(8);break;

case 0xac: /**** $ac:res 5,h ****/
	H &= (~32);
	CYCLES(8);break;

case 0xad: /**** $ad:res 5,l ****/
	L &= (~32);
	CYCLES(8);break;

case 0xae: /**** $ae:res 5,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~32));;
	CYCLES(12);break;

case 0xaf: /**** $af:res 5,a ****/
	A &= (~32);
	CYCLES(8);break;

case 0xb0: /**** $b0:res 6,b ****/
	B &= (~64);
	CYCLES(8);break;

case 0xb1: /**** $b1:res 6,c ****/
	C &= (~64);
	CYCLES(8);break;

case 0xb2: /**** $b2:res 6,d ****/
	D &= (~64);
	CYCLES(8);break;

case 0xb3: /**** $b3:res 6,e ****/
	E &= (~64);
	CYCLES(8);break;

case 0xb4: /**** $b4:res 6,h ****/
	H &= (~64);
	CYCLES(8);break;

case 0xb5: /**** $b5:res 6,l ****/
	L &= (~64);
	CYCLES(8);break;

case 0xb6: /**** $b6:res 6,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~64));;
	CYCLES(12);break;

case 0xb7: /**** $b7:res 6,a ****/
	A &= (~64);
	CYCLES(8);break;

case 0xb8: /**** $b8:res 7,b ****/
	B &= (~128);
	CYCLES(8);break;

case 0xb9: /**** $b9:res 7,c ****/
	C &= (~128);
	CYCLES(8);break;

case 0xba: /**** $ba:res 7,d ****/
	D &= (~128);
	CYCLES(8);break;

case 0xbb: /**** $bb:res 7,e ****/
	E &= (~128);
	CYCLES(8);break;

case 0xbc: /**** $bc:res 7,h ****/
	H &= (~128);
	CYCLES(8);break;

case 0xbd: /**** $bd:res 7,l ****/
	L &= (~128);
	CYCLES(8);break;

case 0xbe: /**** $be:res 7,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8 & (~128));;
	CYCLES(12);break;

case 0xbf: /**** $bf:res 7,a ****/
	A &= (~128);
	CYCLES(8);break;

case 0xc0: /**** $c0:set 0,b ****/
	B |= 1;
	CYCLES(8);break;

case 0xc1: /**** $c1:set 0,c ****/
	C |= 1;
	CYCLES(8);break;

case 0xc2: /**** $c2:set 0,d ****/
	D |= 1;
	CYCLES(8);break;

case 0xc3: /**** $c3:set 0,e ****/
	E |= 1;
	CYCLES(8);break;

case 0xc4: /**** $c4:set 0,h ****/
	H |= 1;
	CYCLES(8);break;

case 0xc5: /**** $c5:set 0,l ****/
	L |= 1;
	CYCLES(8);break;

case 0xc6: /**** $c6:set 0,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|1);;
	CYCLES(12);break;

case 0xc7: /**** $c7:set 0,a ****/
	A |= 1;
	CYCLES(8);break;

case 0xc8: /**** $c8:set 1,b ****/
	B |= 2;
	CYCLES(8);break;

case 0xc9: /**** $c9:set 1,c ****/
	C |= 2;
	CYCLES(8);break;

case 0xca: /**** $ca:set 1,d ****/
	D |= 2;
	CYCLES(8);break;

case 0xcb: /**** $cb:set 1,e ****/
	E |= 2;
	CYCLES(8);break;

case 0xcc: /**** $cc:set 1,h ****/
	H |= 2;
	CYCLES(8);break;

case 0xcd: /**** $cd:set 1,l ****/
	L |= 2;
	CYCLES(8);break;

case 0xce: /**** $ce:set 1,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|2);;
	CYCLES(12);break;

case 0xcf: /**** $cf:set 1,a ****/
	A |= 2;
	CYCLES(8);break;

case 0xd0: /**** $d0:set 2,b ****/
	B |= 4;
	CYCLES(8);break;

case 0xd1: /**** $d1:set 2,c ****/
	C |= 4;
	CYCLES(8);break;

case 0xd2: /**** $d2:set 2,d ****/
	D |= 4;
	CYCLES(8);break;

case 0xd3: /**** $d3:set 2,e ****/
	E |= 4;
	CYCLES(8);break;

case 0xd4: /**** $d4:set 2,h ****/
	H |= 4;
	CYCLES(8);break;

case 0xd5: /**** $d5:set 2,l ****/
	L |= 4;
	CYCLES(8);break;

case 0xd6: /**** $d6:set 2,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|4);;
	CYCLES(12);break;

case 0xd7: /**** $d7:set 2,a ****/
	A |= 4;
	CYCLES(8);break;

case 0xd8: /**** $d8:set 3,b ****/
	B |= 8;
	CYCLES(8);break;

case 0xd9: /**** $d9:set 3,c ****/
	C |= 8;
	CYCLES(8);break;

case 0xda: /**** $da:set 3,d ****/
	D |= 8;
	CYCLES(8);break;

case 0xdb: /**** $db:set 3,e ****/
	E |= 8;
	CYCLES(8);break;

case 0xdc: /**** $dc:set 3,h ****/
	H |= 8;
	CYCLES(8);break;

case 0xdd: /**** $dd:set 3,l ****/
	L |= 8;
	CYCLES(8);break;

case 0xde: /**** $de:set 3,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|8);;
	CYCLES(12);break;

case 0xdf: /**** $df:set 3,a ****/
	A |= 8;
	CYCLES(8);break;

case 0xe0: /**** $e0:set 4,b ****/
	B |= 16;
	CYCLES(8);break;

case 0xe1: /**** $e1:set 4,c ****/
	C |= 16;
	CYCLES(8);break;

case 0xe2: /**** $e2:set 4,d ****/
	D |= 16;
	CYCLES(8);break;

case 0xe3: /**** $e3:set 4,e ****/
	E |= 16;
	CYCLES(8);break;

case 0xe4: /**** $e4:set 4,h ****/
	H |= 16;
	CYCLES(8);break;

case 0xe5: /**** $e5:set 4,l ****/
	L |= 16;
	CYCLES(8);break;

case 0xe6: /**** $e6:set 4,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|16);;
	CYCLES(12);break;

case 0xe7: /**** $e7:set 4,a ****/
	A |= 16;
	CYCLES(8);break;

case 0xe8: /**** $e8:set 5,b ****/
	B |= 32;
	CYCLES(8);break;

case 0xe9: /**** $e9:set 5,c ****/
	C |= 32;
	CYCLES(8);break;

case 0xea: /**** $ea:set 5,d ****/
	D |= 32;
	CYCLES(8);break;

case 0xeb: /**** $eb:set 5,e ****/
	E |= 32;
	CYCLES(8);break;

case 0xec: /**** $ec:set 5,h ****/
	H |= 32;
	CYCLES(8);break;

case 0xed: /**** $ed:set 5,l ****/
	L |= 32;
	CYCLES(8);break;

case 0xee: /**** $ee:set 5,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|32);;
	CYCLES(12);break;

case 0xef: /**** $ef:set 5,a ****/
	A |= 32;
	CYCLES(8);break;

case 0xf0: /**** $f0:set 6,b ****/
	B |= 64;
	CYCLES(8);break;

case 0xf1: /**** $f1:set 6,c ****/
	C |= 64;
	CYCLES(8);break;

case 0xf2: /**** $f2:set 6,d ****/
	D |= 64;
	CYCLES(8);break;

case 0xf3: /**** $f3:set 6,e ****/
	E |= 64;
	CYCLES(8);break;

case 0xf4: /**** $f4:set 6,h ****/
	H |= 64;
	CYCLES(8);break;

case 0xf5: /**** $f5:set 6,l ****/
	L |= 64;
	CYCLES(8);break;

case 0xf6: /**** $f6:set 6,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|64);;
	CYCLES(12);break;

case 0xf7: /**** $f7:set 6,a ****/
	A |= 64;
	CYCLES(8);break;

case 0xf8: /**** $f8:set 7,b ****/
	B |= 128;
	CYCLES(8);break;

case 0xf9: /**** $f9:set 7,c ****/
	C |= 128;
	CYCLES(8);break;

case 0xfa: /**** $fa:set 7,d ****/
	D |= 128;
	CYCLES(8);break;

case 0xfb: /**** $fb:set 7,e ****/
	E |= 128;
	CYCLES(8);break;

case 0xfc: /**** $fc:set 7,h ****/
	H |= 128;
	CYCLES(8);break;

case 0xfd: /**** $fd:set 7,l ****/
	L |= 128;
	CYCLES(8);break;

case 0xfe: /**** $fe:set 7,(hl) ****/
	temp8 = READ8(HL()); WRITE8(HL(),temp8|128);;
	CYCLES(12);break;

case 0xff: /**** $ff:set 7,a ****/
	A |= 128;
	CYCLES(8);break;


