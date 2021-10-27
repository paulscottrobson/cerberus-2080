case 0x00: /* $00 BRK */
	CYCLES(7);brkCode();break;
case 0x01: /* $01 ORA ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8);sValue = zValue = a = a | READ8(eac);break;
case 0x02: /* $02 STOP */
	CYCLES(1);CPUExit();break;
case 0x04: /* $04 TSB $1 */
	CYCLES(3);eac = FETCH8(); trsbCode(eac,1);break;
case 0x05: /* $05 ORA $1 */
	CYCLES(3);eac = FETCH8();sValue = zValue = a = a | READ8(eac);break;
case 0x06: /* $06 ASL $1 */
	CYCLES(5);eac = FETCH8(); WRITE8(eac,aslCode(READ8(eac)));break;
case 0x07: /* $07 RMB0 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 0)^0xFF);WRITE8(eac,temp8);break;
case 0x08: /* $08 PHP */
	CYCLES(3);Push(constructFlagRegister());break;
case 0x09: /* $09 ORA #$1 */
	CYCLES(2);eac = PC++;sValue = zValue = a = a | READ8(eac);break;
case 0x0a: /* $0a ASL A */
	CYCLES(2);a = aslCode(a);break;
case 0x0c: /* $0c TSB $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16; trsbCode(eac,1);break;
case 0x0d: /* $0d ORA $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;sValue = zValue = a = a | READ8(eac);break;
case 0x0e: /* $0e ASL $2 */
	CYCLES(6);temp16 = FETCH16();eac = temp16; WRITE8(eac,aslCode(READ8(eac)));break;
case 0x0f: /* $0f BBR0 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 0)) == 0);break;
case 0x10: /* $10 BPL $O */
	CYCLES(2);Branch((sValue & 0x80) == 0);break;
case 0x11: /* $11 ORA ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF;sValue = zValue = a = a | READ8(eac);break;
case 0x12: /* $12 ORA ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8);sValue = zValue = a = a | READ8(eac);break;
case 0x14: /* $14 TRB $1 */
	CYCLES(3);eac = FETCH8(); trsbCode(eac,0);break;
case 0x15: /* $15 ORA $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;sValue = zValue = a = a | READ8(eac);break;
case 0x16: /* $16 ASL $1,X */
	CYCLES(6);eac = (FETCH8()+x) & 0xFF; WRITE8(eac,aslCode(READ8(eac)));break;
case 0x17: /* $17 RMB1 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 1)^0xFF);WRITE8(eac,temp8);break;
case 0x18: /* $18 CLC */
	CYCLES(2);carryFlag = 0;break;
case 0x19: /* $19 ORA $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = a | READ8(eac);break;
case 0x1a: /* $1a INC */
	CYCLES(2);sValue = zValue = a = (a + 1) & 0xFF;break;
case 0x1c: /* $1c TRB $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16; trsbCode(eac,0);break;
case 0x1d: /* $1d ORA $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = a | READ8(eac);break;
case 0x1e: /* $1e ASL $2,X */
	CYCLES(6);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF; WRITE8(eac,aslCode(READ8(eac)));break;
case 0x1f: /* $1f BBR1 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 1)) == 0);break;
case 0x20: /* $20 JSR $2 */
	CYCLES(6);temp16 = FETCH16();eac = temp16;PC--;Push(PC >> 8);Push(PC & 0xFF);PC = eac;break;
case 0x21: /* $21 AND ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8); a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x24: /* $24 BIT $1 */
	CYCLES(2);eac = FETCH8(); bitCode(READ8(eac));break;
case 0x25: /* $25 AND $1 */
	CYCLES(3);eac = FETCH8(); a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x26: /* $26 ROL $1 */
	CYCLES(3);eac = FETCH8(); WRITE8(eac,rolCode(READ8(eac)));break;
case 0x27: /* $27 RMB2 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 2)^0xFF);WRITE8(eac,temp8);break;
case 0x28: /* $28 PLP */
	CYCLES(4);explodeFlagRegister(Pop());break;
case 0x29: /* $29 AND #$1 */
	CYCLES(2);eac = PC++; a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x2a: /* $2a ROL A */
	CYCLES(2);a = rolCode(a);break;
case 0x2c: /* $2c BIT $2 */
	CYCLES(3);temp16 = FETCH16();eac = temp16; bitCode(READ8(eac));break;
case 0x2d: /* $2d AND $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16; a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x2e: /* $2e ROL $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16; WRITE8(eac,rolCode(READ8(eac)));break;
case 0x2f: /* $2f BBR2 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 2)) == 0);break;
case 0x30: /* $30 BMI $O */
	CYCLES(2);Branch((sValue & 0x80) != 0);break;
case 0x31: /* $31 AND ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF; a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x32: /* $32 AND ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8); a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x34: /* $34 BIT $1,X */
	CYCLES(3);eac = (FETCH8()+x) & 0xFF; bitCode(READ8(eac));break;
case 0x35: /* $35 AND $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF; a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x36: /* $36 ROL $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF; WRITE8(eac,rolCode(READ8(eac)));break;
case 0x37: /* $37 RMB3 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 3)^0xFF);WRITE8(eac,temp8);break;
case 0x38: /* $38 SEC */
	CYCLES(2);carryFlag = 1;break;
case 0x39: /* $39 AND $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF; a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x3a: /* $3a DEC */
	CYCLES(2);sValue = zValue = a = (a - 1) & 0xFF;break;
case 0x3c: /* $3c BIT $2,X */
	CYCLES(3);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF; bitCode(READ8(eac));break;
case 0x3d: /* $3d AND $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF; a = a & READ8(eac) ; sValue = zValue = a;break;
case 0x3e: /* $3e ROL $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF; WRITE8(eac,rolCode(READ8(eac)));break;
case 0x3f: /* $3f BBR3 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 3)) == 0);break;
case 0x40: /* $40 RTI */
	CYCLES(6);explodeFlagRegister(Pop());PC = Pop();PC = PC | (((WORD16)Pop()) << 8);break;
case 0x41: /* $41 EOR ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8);sValue = zValue = a = a ^ READ8(eac);break;
case 0x45: /* $45 EOR $1 */
	CYCLES(3);eac = FETCH8();sValue = zValue = a = a ^ READ8(eac);break;
case 0x46: /* $46 LSR $1 */
	CYCLES(3);eac = FETCH8(); WRITE8(eac,lsrCode(READ8(eac)));break;
case 0x47: /* $47 RMB4 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 4)^0xFF);WRITE8(eac,temp8);break;
case 0x48: /* $48 PHA */
	CYCLES(3);Push(a);break;
case 0x49: /* $49 EOR #$1 */
	CYCLES(2);eac = PC++;sValue = zValue = a = a ^ READ8(eac);break;
case 0x4a: /* $4a LSR A */
	CYCLES(2);a = lsrCode(a);break;
case 0x4c: /* $4c JMP $2 */
	CYCLES(3);temp16 = FETCH16();eac = temp16;PC = eac;break;
case 0x4d: /* $4d EOR $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;sValue = zValue = a = a ^ READ8(eac);break;
case 0x4e: /* $4e LSR $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16; WRITE8(eac,lsrCode(READ8(eac)));break;
case 0x4f: /* $4f BBR4 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 4)) == 0);break;
case 0x50: /* $50 BVC $O */
	CYCLES(2);Branch(overflowFlag == 0);break;
case 0x51: /* $51 EOR ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF;sValue = zValue = a = a ^ READ8(eac);break;
case 0x52: /* $52 EOR ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8);sValue = zValue = a = a ^ READ8(eac);break;
case 0x55: /* $55 EOR $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;sValue = zValue = a = a ^ READ8(eac);break;
case 0x56: /* $56 LSR $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF; WRITE8(eac,lsrCode(READ8(eac)));break;
case 0x57: /* $57 RMB5 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 5)^0xFF);WRITE8(eac,temp8);break;
case 0x58: /* $58 CLI */
	CYCLES(2);interruptDisableFlag = 0;break;
case 0x59: /* $59 EOR $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = a ^ READ8(eac);break;
case 0x5a: /* $5a PHY */
	CYCLES(3);Push(y);break;
case 0x5d: /* $5d EOR $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = a ^ READ8(eac);break;
case 0x5e: /* $5e LSR $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF; WRITE8(eac,lsrCode(READ8(eac)));break;
case 0x5f: /* $5f BBR5 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 5)) == 0);break;
case 0x60: /* $60 RTS */
	CYCLES(6);PC = Pop();PC = PC | (((WORD16)Pop()) << 8);PC++;break;
case 0x61: /* $61 ADC ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8);sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x64: /* $64 STZ $1 */
	CYCLES(3);eac = FETCH8();WRITE8(eac,0);break;
case 0x65: /* $65 ADC $1 */
	CYCLES(3);eac = FETCH8();sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x66: /* $66 ROR $1 */
	CYCLES(3);eac = FETCH8(); WRITE8(eac,rorCode(READ8(eac)));break;
case 0x67: /* $67 RMB6 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 6)^0xFF);WRITE8(eac,temp8);break;
case 0x68: /* $68 PLA */
	CYCLES(4);a = sValue = zValue = Pop();break;
case 0x69: /* $69 ADC #$1 */
	CYCLES(2);eac = PC++;sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x6a: /* $6a ROR A */
	CYCLES(2);a = rorCode(a);break;
case 0x6c: /* $6c JMP ($2) */
	CYCLES(5);temp16 = FETCH16();eac = READ16(temp16);PC = eac;break;
case 0x6d: /* $6d ADC $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x6e: /* $6e ROR $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16; WRITE8(eac,rorCode(READ8(eac)));break;
case 0x6f: /* $6f BBR6 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 6)) == 0);break;
case 0x70: /* $70 BVS $O */
	CYCLES(2);Branch(overflowFlag != 0);break;
case 0x71: /* $71 ADC ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF;sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x72: /* $72 ADC ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8);sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x74: /* $74 STZ $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;WRITE8(eac,0);break;
case 0x75: /* $75 ADC $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x76: /* $76 ROR $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF; WRITE8(eac,rorCode(READ8(eac)));break;
case 0x77: /* $77 RMB7 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)&((1 << 7)^0xFF);WRITE8(eac,temp8);break;
case 0x78: /* $78 SEI */
	CYCLES(2);interruptDisableFlag = 1;break;
case 0x79: /* $79 ADC $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x7a: /* $7a PLY */
	CYCLES(4);y = sValue = zValue = Pop();break;
case 0x7c: /* $7c JMP ($2,X) */
	CYCLES(5);temp16 = FETCH16();temp16 = (temp16+x) & 0xFFFF;eac = READ16(temp16);PC = eac;break;
case 0x7d: /* $7d ADC $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = add8Bit(a,READ8(eac),decimalFlag);break;
case 0x7e: /* $7e ROR $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF; WRITE8(eac,rorCode(READ8(eac)));break;
case 0x7f: /* $7f BBR7 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 7)) == 0);break;
case 0x80: /* $80 BRA $O */
	CYCLES(2);Branch(1);break;
case 0x81: /* $81 STA ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8);WRITE8(eac,a);break;
case 0x84: /* $84 STY $1 */
	CYCLES(3);eac = FETCH8();WRITE8(eac,y);break;
case 0x85: /* $85 STA $1 */
	CYCLES(3);eac = FETCH8();WRITE8(eac,a);break;
case 0x86: /* $86 STX $1 */
	CYCLES(3);eac = FETCH8();WRITE8(eac,x);break;
case 0x87: /* $87 SMB0 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 0);WRITE8(eac,temp8);break;
case 0x88: /* $88 DEY */
	CYCLES(2);sValue = zValue = y = (y - 1) & 0xFF;break;
case 0x89: /* $89 BIT #$1 */
	CYCLES(3);bitCode(FETCH8());break;
case 0x8a: /* $8a TXA */
	CYCLES(2);sValue = zValue = a = x;break;
case 0x8c: /* $8c STY $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;WRITE8(eac,y);break;
case 0x8d: /* $8d STA $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;WRITE8(eac,a);break;
case 0x8e: /* $8e STX $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;WRITE8(eac,x);break;
case 0x8f: /* $8f BBS0 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 0)) != 0);break;
case 0x90: /* $90 BCC $O */
	CYCLES(2);Branch(carryFlag == 0);break;
case 0x91: /* $91 STA ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF;WRITE8(eac,a);break;
case 0x92: /* $92 STA ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8);WRITE8(eac,a);break;
case 0x94: /* $94 STY $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;WRITE8(eac,y);break;
case 0x95: /* $95 STA $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;WRITE8(eac,a);break;
case 0x96: /* $96 STX $1,Y */
	CYCLES(4);eac = (FETCH8()+y) & 0xFF;WRITE8(eac,x);break;
case 0x97: /* $97 SMB1 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 1);WRITE8(eac,temp8);break;
case 0x98: /* $98 TYA */
	CYCLES(2);sValue = zValue = a = y;break;
case 0x99: /* $99 STA $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;WRITE8(eac,a);break;
case 0x9a: /* $9a TXS */
	CYCLES(2);s = x;break;
case 0x9c: /* $9c STZ $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;WRITE8(eac,0);break;
case 0x9d: /* $9d STA $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;WRITE8(eac,a);break;
case 0x9e: /* $9e STZ $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;WRITE8(eac,0);break;
case 0x9f: /* $9f BBS1 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 1)) != 0);break;
case 0xa0: /* $a0 LDY #$1 */
	CYCLES(2);eac = PC++;y = sValue = zValue = READ8(eac);break;
case 0xa1: /* $a1 LDA ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8);a = sValue = zValue = READ8(eac);break;
case 0xa2: /* $a2 LDX #$1 */
	CYCLES(2);eac = PC++;x = sValue = zValue = READ8(eac);break;
case 0xa4: /* $a4 LDY $1 */
	CYCLES(3);eac = FETCH8();y = sValue = zValue = READ8(eac);break;
case 0xa5: /* $a5 LDA $1 */
	CYCLES(3);eac = FETCH8();a = sValue = zValue = READ8(eac);break;
case 0xa6: /* $a6 LDX $1 */
	CYCLES(3);eac = FETCH8();x = sValue = zValue = READ8(eac);break;
case 0xa7: /* $a7 SMB2 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 2);WRITE8(eac,temp8);break;
case 0xa8: /* $a8 TAY */
	CYCLES(2);sValue = zValue = y = a;break;
case 0xa9: /* $a9 LDA #$1 */
	CYCLES(2);eac = PC++;a = sValue = zValue = READ8(eac);break;
case 0xaa: /* $aa TAX */
	CYCLES(2);sValue = zValue = x = a;break;
case 0xac: /* $ac LDY $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;y = sValue = zValue = READ8(eac);break;
case 0xad: /* $ad LDA $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;a = sValue = zValue = READ8(eac);break;
case 0xae: /* $ae LDX $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;x = sValue = zValue = READ8(eac);break;
case 0xaf: /* $af BBS2 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 2)) != 0);break;
case 0xb0: /* $b0 BCS $O */
	CYCLES(2);Branch(carryFlag != 0);break;
case 0xb1: /* $b1 LDA ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF;a = sValue = zValue = READ8(eac);break;
case 0xb2: /* $b2 LDA ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8);a = sValue = zValue = READ8(eac);break;
case 0xb4: /* $b4 LDY $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;y = sValue = zValue = READ8(eac);break;
case 0xb5: /* $b5 LDA $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;a = sValue = zValue = READ8(eac);break;
case 0xb6: /* $b6 LDX $1,Y */
	CYCLES(4);eac = (FETCH8()+y) & 0xFF;x = sValue = zValue = READ8(eac);break;
case 0xb7: /* $b7 SMB3 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 3);WRITE8(eac,temp8);break;
case 0xb8: /* $b8 CLV */
	CYCLES(2);overflowFlag = 0;break;
case 0xb9: /* $b9 LDA $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;a = sValue = zValue = READ8(eac);break;
case 0xba: /* $ba TSX */
	CYCLES(2);sValue = zValue = x = s;break;
case 0xbc: /* $bc LDY $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;y = sValue = zValue = READ8(eac);break;
case 0xbd: /* $bd LDA $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;a = sValue = zValue = READ8(eac);break;
case 0xbe: /* $be LDX $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;x = sValue = zValue = READ8(eac);break;
case 0xbf: /* $bf BBS3 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 3)) != 0);break;
case 0xc0: /* $c0 CPY #$1 */
	CYCLES(2);eac = PC++;carryFlag = 1;sValue = zValue = sub8Bit(y,READ8(eac),0);break;
case 0xc1: /* $c1 CMP ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8);carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xc4: /* $c4 CPY $1 */
	CYCLES(3);eac = FETCH8();carryFlag = 1;sValue = zValue = sub8Bit(y,READ8(eac),0);break;
case 0xc5: /* $c5 CMP $1 */
	CYCLES(3);eac = FETCH8();carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xc6: /* $c6 DEC $1 */
	CYCLES(5);eac = FETCH8();sValue = zValue = (READ8(eac)-1) & 0xFF; WRITE8(eac,sValue);break;
case 0xc7: /* $c7 SMB4 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 4);WRITE8(eac,temp8);break;
case 0xc8: /* $c8 INY */
	CYCLES(2);sValue = zValue = y = (y + 1) & 0xFF;break;
case 0xc9: /* $c9 CMP #$1 */
	CYCLES(2);eac = PC++;carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xca: /* $ca DEX */
	CYCLES(2);sValue = zValue = x = (x - 1) & 0xFF;break;
case 0xcb: /* $cb WAI */
	CYCLES(48);PC--;break;
case 0xcc: /* $cc CPY $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;carryFlag = 1;sValue = zValue = sub8Bit(y,READ8(eac),0);break;
case 0xcd: /* $cd CMP $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xce: /* $ce DEC $2 */
	CYCLES(6);temp16 = FETCH16();eac = temp16;sValue = zValue = (READ8(eac)-1) & 0xFF; WRITE8(eac,sValue);break;
case 0xcf: /* $cf BBS4 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 4)) != 0);break;
case 0xd0: /* $d0 BNE $O */
	CYCLES(2);Branch(zValue != 0);break;
case 0xd1: /* $d1 CMP ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF;carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xd2: /* $d2 CMP ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8);carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xd5: /* $d5 CMP $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xd6: /* $d6 DEC $1,X */
	CYCLES(6);eac = (FETCH8()+x) & 0xFF;sValue = zValue = (READ8(eac)-1) & 0xFF; WRITE8(eac,sValue);break;
case 0xd7: /* $d7 SMB5 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 5);WRITE8(eac,temp8);break;
case 0xd8: /* $d8 CLD */
	CYCLES(2);decimalFlag = 0;break;
case 0xd9: /* $d9 CMP $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xda: /* $da PHX */
	CYCLES(3);Push(x);break;
case 0xdd: /* $dd CMP $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;carryFlag = 1;sValue = zValue = sub8Bit(a,READ8(eac),0);break;
case 0xde: /* $de DEC $1,X */
	CYCLES(6);eac = (FETCH8()+x) & 0xFF;sValue = zValue = (READ8(eac)-1) & 0xFF; WRITE8(eac,sValue);break;
case 0xdf: /* $df BBS5 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 5)) != 0);break;
case 0xe0: /* $e0 CPX #$1 */
	CYCLES(2);eac = PC++;carryFlag = 1;sValue = zValue = sub8Bit(x,READ8(eac),0);break;
case 0xe1: /* $e1 SBC ($1,X) */
	CYCLES(7);temp8 = (FETCH8()+x) & 0xFF;eac = READ16(temp8);sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xe4: /* $e4 CPX $1 */
	CYCLES(3);eac = FETCH8();carryFlag = 1;sValue = zValue = sub8Bit(x,READ8(eac),0);break;
case 0xe5: /* $e5 SBC $1 */
	CYCLES(3);eac = FETCH8();sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xe6: /* $e6 INC $1 */
	CYCLES(5);eac = FETCH8();sValue = zValue = (READ8(eac)+1) & 0xFF; WRITE8(eac, sValue);break;
case 0xe7: /* $e7 SMB6 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 6);WRITE8(eac,temp8);break;
case 0xe8: /* $e8 INX */
	CYCLES(2);sValue = zValue = x = (x + 1) & 0xFF;break;
case 0xe9: /* $e9 SBC #$1 */
	CYCLES(2);eac = PC++;sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xea: /* $ea NOP */
	CYCLES(2);{};break;
case 0xec: /* $ec CPX $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;carryFlag = 1;sValue = zValue = sub8Bit(x,READ8(eac),0);break;
case 0xed: /* $ed SBC $2 */
	CYCLES(4);temp16 = FETCH16();eac = temp16;sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xee: /* $ee INC $2 */
	CYCLES(6);temp16 = FETCH16();eac = temp16;sValue = zValue = (READ8(eac)+1) & 0xFF; WRITE8(eac, sValue);break;
case 0xef: /* $ef BBS6 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 6)) != 0);break;
case 0xf0: /* $f0 BEQ $O */
	CYCLES(2);Branch(zValue == 0);break;
case 0xf1: /* $f1 SBC ($1),Y */
	CYCLES(6);temp8 = FETCH8();eac = (READ16(temp8)+y) & 0xFFFF;sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xf2: /* $f2 SBC ($1) */
	CYCLES(6);temp8 = FETCH8();eac = READ16(temp8);sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xf5: /* $f5 SBC $1,X */
	CYCLES(4);eac = (FETCH8()+x) & 0xFF;sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xf6: /* $f6 INC $1,X */
	CYCLES(6);eac = (FETCH8()+x) & 0xFF;sValue = zValue = (READ8(eac)+1) & 0xFF; WRITE8(eac, sValue);break;
case 0xf7: /* $f7 SMB7 $1 */
	CYCLES(3);eac = FETCH8();temp8 = READ8(eac)|(1 << 7);WRITE8(eac,temp8);break;
case 0xf8: /* $f8 SED */
	CYCLES(2);decimalFlag = 1;break;
case 0xf9: /* $f9 SBC $2,Y */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xfa: /* $fa PLX */
	CYCLES(4);x = sValue = zValue = Pop();break;
case 0xfd: /* $fd SBC $2,X */
	CYCLES(4);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = sub8Bit(a,READ8(eac),decimalFlag);break;
case 0xfe: /* $fe INC $2,X */
	CYCLES(6);temp16 = FETCH16();eac = (temp16+x) & 0xFFFF;sValue = zValue = (READ8(eac)+1) & 0xFF; WRITE8(eac, sValue);break;
case 0xff: /* $ff BBS7 $1,@R */
	CYCLES(5);eac = FETCH8();Branch((READ8(eac) & (1 << 7)) != 0);break;
