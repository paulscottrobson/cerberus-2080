// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		c6502_cpu_support.h
//		Purpose:	CPU Support file , functions and macros included.
//		Created:	27th October 2021
//		Author:	Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

static WORD16 inline EACIMM(void) {
	return 0;
}

static WORD16 inline EACZERO(void) {
	return 0;
}

static WORD16 inline EACZEROX(void) {
	return 0;
}

static WORD16 inline EACZEROY(void) {
	return 0;
}

static WORD16 inline EACABS(void) {
	return 0;
}

static WORD16 inline EACABSX(void) {
	return 0;
}

static WORD16 inline EACABSY(void) {
	return 0;
}

static WORD16 inline EACIND(void) {
	return 0;
}

static WORD16 inline EACINDX(void) {
	return 0;
}

static WORD16 inline EACINDY(void) {
	return 0;
}

#define CCMP2(v1,v2) {}

#define CALUADC() {}
#define CALUSBC() {}
#define CALUCMP() CCMP2(A,READ8(temp16))
#define CALUORA() {}
#define CALUEOR() {}
#define CALUAND() {}
#define CALULDA() {}

#define CBIT(n) {}

#define CINC(n) (n)
#define CDEC(n) (n)

#define CROL(n) (n)
#define CROR(n) (n)
#define CASL(n) (n)
#define CLSR(n) (n)
