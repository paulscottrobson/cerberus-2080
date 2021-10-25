// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		z80_cpu_support.h
//		Purpose:	CPU Support file , functions and macros included.
//		Created:	25th October 2021
//		Author:	Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

// *******************************************************************************************************************************
//
//			Build Parity Flag table (1 if value is even,0 when odd)
//
// *******************************************************************************************************************************

static BYTE8 parityFlagValue[256];												// A look up table for the P Flag for ALU etc

static void BuildParityTable(void) {
	for (int i = 0;i < 256;i++) {
		int n = i;
		int isEven = 0;
		while (n != 0) {
			if (n & 1) isEven++;
			n = n >> 1;
		}
		parityFlagValue[i] = (isEven & 1) == 0; 
	}
}
// *******************************************************************************************************************************
//
// 								Construct the F value out of the components
//
// *******************************************************************************************************************************

static BYTE8 ConstructStatusByte(void) {
	BYTE8 f = 0;												
	if (s_Flag != 0) f |= 0x80;													// Get S value Bit 7
	if (z_Flag != 0) f |= 0x40;													// Get Z value Bit 6 
	if (h_Flag != 0) f |= 0x10;													// Get H value Bit 4
	if (p_Flag != 0) f |= 0x04; 												// Get P/V value Bit 2
	if (n_Flag != 0) f |= 0x02; 												// Get N value Bit 1 (1 = subtract)
	if (c_Flag != 0) f |= 0x01;													// Get C value Bit 0
	return f;
}

// *******************************************************************************************************************************
//
//									Put Status Flag back into the components
//
// *******************************************************************************************************************************

static void ExplodeStatusByte(BYTE8 f) {
	s_Flag = (f & 0x80) != 0;													// Bit 7, sign
	z_Flag = (f & 0x40) != 0;													// Bit 6, if zero flag clear make value nz 
	h_Flag = (f & 0x10) != 0;													// Bit 4 H
	p_Flag = (f & 0x04) != 0;													// Bit 2 P/V
	n_Flag = (f & 0x02) != 0;													// Bit 1 N Flag
	c_Flag = (f & 0x01) != 0;													// Bit 0 Carry Flag
}

// *******************************************************************************************************************************
//
//											16 Bit Accessors/Mutators
//
// *******************************************************************************************************************************

#define MAKE16(r1,r2) 	(((r1) << 8) | (r2))

#define AF() MAKE16(A,ConstructStatusByte())
#define BC() MAKE16(B,C)
#define DE() MAKE16(D,E)
#define HL() MAKE16(H,L)
#define SP() SP

#define SET16(r1,r2,n) { r1 = ((n) >> 8);r2 = ((n) & 0xFF); }

#define SETAF(n) { A = ((n) >> 8);ExplodeStatusByte((n) & 0xFF); }
#define SETBC(n) SET16(B,C,n)
#define SETDE(n) SET16(D,E,n)
#define SETHL(n) SET16(H,L,n)
#define SETSP(n) SP = n

// *******************************************************************************************************************************
//		
//											IX IY support functions
//
// *******************************************************************************************************************************

#define IZ() (*pIXY) 															// Current index register
#define FETCHDISP8() _Fetch8Signed()  											// Fetch and sign extend to 16 bits.

#define IZDISP8() (IZ()+FETCHDISP8()) 											// IX/Y EAC : Index Register + Sign Extended Displacement

static inline WORD16 _Fetch8Signed(void) { 										// Support function.
	WORD16 w1 = FETCH8();
	return (w1 & 0x80) ? (w1|0xFF00) : w1;
}

// *******************************************************************************************************************************
//
//													Push and Pop
//
// *******************************************************************************************************************************

#define PUSH(v) 		_Push(v)
#define POP()  			_Pop()

static inline void _Push(WORD16 d) {
	SP -= 2;
	WRITE16(SP,d);
}

static inline WORD16 _Pop(void) {
	WORD16 d = READ16(SP);
	SP += 2;
	return d;
}

// *******************************************************************************************************************************
//
//											  Increment/Decrement 16
//
// *******************************************************************************************************************************

#define INC16(r1,r2) 	{ r2++;if (r2 == 0) r1++; }
#define DEC16(r1,r2) 	{ if (r2 == 0) {r1--;}  r2--; }

#define INCBC()  	INC16(B,C)
#define INCDE()  	INC16(D,E)
#define INCHL()  	INC16(H,L)
#define INCSP()  	SP++

#define DECBC()  	DEC16(B,C)
#define DECDE()  	DEC16(D,E)
#define DECHL()  	DEC16(H,L)
#define DECSP()  	SP--

// *******************************************************************************************************************************
//
//											  Increment/Decrement 8
//
// *******************************************************************************************************************************

#define INC8(r) 		{ r++;SETNZ(r);SETHALFCARRY((r & 0x0F) == 0x0);SETNFLAG(0);SETOVERFLOW(r == 0x80); }
#define DEC8(r) 		{ r--;SETNZ(r);SETHALFCARRY((r & 0x0F) == 0xF);SETNFLAG(1);SETOVERFLOW(r == 0x7F); }

// *******************************************************************************************************************************
//
// 													Flag stuff
//
// *******************************************************************************************************************************

#define SETNZ(v) 		{ s_Flag = ((v) & 0x80);z_Flag = ((v) == 0);}
#define SETCARRY(v) 	{ c_Flag = (v); }
#define SETHALFCARRY(v) { h_Flag = (v); }
#define SETNFLAG(v) 	{ n_Flag = (v); }

#define SETOVERFLOW(v) 	{ p_Flag = (v); }
#define SETPARITY(n) 	{ p_Flag = parityFlagValue[n]; }

// *******************************************************************************************************************************
//
//											  Arithmetic/Logic 8 bit
//
// *******************************************************************************************************************************

#define ALUADD(n) 		{ A = _add(n,0); }
#define ALUADC(n) 		{ A = _add(n,c_Flag ? 1 : 0); }
#define ALUSUB(n) 		{ A = _sub(n,0); }
#define ALUSBC(n) 		{ A = _sub(n,c_Flag ? 1 : 0); }
#define ALUCP(n) 		{ _sub(n,0); }

#define ALUAND(n) 		ALU_LOGIC(A & (n),1)
#define ALUOR(n) 		ALU_LOGIC(A | (n),0)
#define ALUXOR(n) 		ALU_LOGIC(A ^ (n),0)

#define ALU_LOGIC(r,h) 	{ A = (r);c_Flag = n_Flag = 0;h_Flag = h; SETNZ(A);SETPARITY(A); }

static BYTE8 _add(BYTE8 n,BYTE8 c) {
	temp16 = A + n + c;
	c_Flag = (temp16 & 0x100) != 0;
	n_Flag = 0;
	SETNZ(temp16);
	SETOVERFLOW((A & 0x80) == (n & 0x80) && (temp16 & 0x80) != (n & 0x80));
	SETCARRY((temp16 & 0x100) != 0);
	SETNFLAG(0);
	SETHALFCARRY(((A & 0xF)+(n & 0xF) + c) >= 0x10);
	return temp16;
}

static BYTE8 _sub(BYTE8 n,BYTE8 c) {
	temp16 = A - n - c;
	c_Flag = (temp16 & 0x100) != 0;
	n_Flag = 1;
	SETNZ(temp16);
	SETOVERFLOW((A & 0x80) == ((n ^ 0x80) & 0x80) && (temp16 & 0x80) != (A & 0x80));
	SETCARRY((temp16 & 0x100) != 0);
	SETHALFCARRY((((A & 0xF)-(n & 0xF) - c) & 0x100) != 0);
	SETNFLAG(1);
	return temp16;
}

static void DAA()
{
   int t = 0;
    
   if(h_Flag != 0 || (A & 0xF) > 9) {
         t++;
    }
    
   if(c_Flag != 0 || A > 0x99)
   {
         t += 2;
         c_Flag = 1;
   }
    
   // builds final H flag
   if (n_Flag != 0 && h_Flag == 0) {
      h_Flag = 0;
   }
   else
   {
       if (n_Flag != 0 && h_Flag != 0)
          h_Flag = (((A & 0x0F)) < 6);
       else
          h_Flag = ((A & 0x0F) >= 0x0A);
   }
    
   switch(t)
   {
        case 1:
            A += (n_Flag != 0)?0xFA:0x06; // -6:6
            break;
        case 2:
            A += (n_Flag != 0)?0xA0:0x60; // -0x60:0x60
            break;
        case 3:
            A += (n_Flag != 0)?0x9A:0x66; // -0x66:0x66
            break;
   }

	SETNZ(A);    
	SETPARITY(A);
}

// *******************************************************************************************************************************
//
//											  Arithmetic/Logic 16 bit
//
// *******************************************************************************************************************************

static WORD16 add16(WORD16 r1,WORD16 r2) {
	long r = r1 + r2;
	SETHALFCARRY((r1 & 0xFFF)+(r2 & 0xFFF) >= 0x1000);
	SETNFLAG(0);
	SETCARRY((r & 0x10000) != 0);
	return r;
}

static void _setNZ16(WORD16 w) {
	if (w & 0x8000) {
		SETNZ(0x80);
	} else {
		SETNZ(w == 0 ? 0 : 1);
	}
}

static WORD16 adc16(WORD16 r1,WORD16 r2) {
	temp32 = r1 + r2 + (c_Flag ? 1 : 0);
	_setNZ16(temp32 & 0xFFFF);
	SETHALFCARRY((r1 & 0xFFF)+(r2 & 0xFFF)+(c_Flag ? 1 : 0) >= 0x1000);
	SETOVERFLOW((r1 & 0x8000) == (r2 & 0x8000) && (temp32 & 0x8000) != (r1 & 0x8000));
	SETNFLAG(0);
	SETCARRY((temp32 & 0x10000) != 0);
	return temp32 & 0xFFFF;
}

static WORD16 sbc16(WORD16 r1,WORD16 r2) {
	temp32 = r1 - r2 - (c_Flag ? 1 : 0);
	_setNZ16(temp32 & 0xFFFF);
	SETHALFCARRY((((r1 & 0xFFF)-(r2 & 0xFFF)-(c_Flag ? 1 : 0)) & 0x8000) != 0);
	SETOVERFLOW((r1 & 0x8000) == ((r2 ^ 0x8000) & 0x8000) && (temp32 & 0x8000) != (r1 & 0x8000));
	SETNFLAG(1);
	SETCARRY((temp32 & 0x10000) != 0);
	return temp32 & 0xFFFF;
}

// *******************************************************************************************************************************
//
//												CB Shift Rotates
//
// *******************************************************************************************************************************

static BYTE8 _RotateMake(BYTE8 v,BYTE8 c) {
	SETNZ(v);
	SETHALFCARRY(0);
	SETPARITY(v);
	SETNFLAG(0);
	SETCARRY(c != 0);
	return v;
}

#define SRRLC(a) 	_RotateMake((a << 1)|(a >> 7),a & 0x80)
#define SRRRC(a) 	_RotateMake((a >> 1)|(a << 7),a & 0x01)
#define SRRL(a) 	_RotateMake((a << 1) | (c_Flag ? 0x01:0x00),a & 0x80)
#define SRRR(a) 	_RotateMake((a >> 1) | (c_Flag ? 0x80:0x00),a & 0x01)
#define SRSLA(a) 	_RotateMake(a << 1,a & 0x80)
#define SRSRA(a) 	_RotateMake((a >> 1) | (a & 0x80),a & 0x01)
#define SRSRL(a) 	_RotateMake(a >> 1,a & 0x01)

// *******************************************************************************************************************************
//
//												Bit Test Operation
//
// *******************************************************************************************************************************

static void bitOp(BYTE8 test) {
	SETNZ(test);
	SETHALFCARRY(1);
	SETNFLAG(0);
	SETPARITY(test);
}

// *******************************************************************************************************************************
//
//												Jump and Call stuff
//
// *******************************************************************************************************************************

#define 	JUMP(t) 	{ temp16 = FETCH16(); if (t) { PC = temp16; }}
#define 	JUMPR(t) 	{ temp16 = FETCHDISP8(); if (t) { PC += temp16;CYCLES(5); }}

#define 	CALL(t) 	{ temp16 = FETCH16(); if (t) { PUSH(PC);PC = temp16;CYCLES(7); }}
#define 	RETURN(t) 	{ if (t) { PC = POP();CYCLES(6); }}

#define 	TESTNZ() 	(z_Flag == 0)
#define 	TESTNC()	(c_Flag == 0)
#define 	TESTPO() 	(p_Flag == 0)
#define 	TESTP() 	(s_Flag == 0)

#define 	TESTZ() 	(z_Flag != 0)
#define 	TESTC()		(c_Flag != 0)
#define 	TESTPE() 	(p_Flag != 0)
#define 	TESTM() 	(s_Flag != 0)

// *******************************************************************************************************************************
//
//												Group Handlers
//
// *******************************************************************************************************************************

static void ExecuteCBGroup(void) {
	BYTE8 n = FETCH8();
	switch(n) {
		#include "z80/_code_group_cb.h"
		default:
			FAILOPCODE("CB",n);
	}
}

static void ExecuteEDGroup(void) {
	BYTE8 n = FETCH8();
	switch(n) {
		#include "z80/_code_group_ed.h"
		default:
			FAILOPCODE("ED",n);
	}
}

static void ExecuteDDCBGroup(void) {
	int offset = FETCH8();
	BYTE8 n = FETCH8();
	offset = (offset & 0x80) ? 0xFF00|offset:offset;
	switch(n) {
		#include "z80/_code_group_ddcb.h"
		default:
			FAILOPCODE("DDCB",n);
	}
}

static void ExecuteDDGroup(void) {
	BYTE8 n = FETCH8();
	switch(n) {
		#include "z80/_code_group_dd.h"
		default:
			FAILOPCODE("DD",n);
	}
}

