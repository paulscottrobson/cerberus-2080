#
#	Automatically generated.
#
class RuntimeLibrary
	def getIndex
		return "0-,C,$389,$391::0<,C,$391,$399::0=,C,$399,$3a1::16/,C,$3c6,$3d6::4/,C,$3b2,$3ba::8/,C,$3ba,$3c6::*,C,$2e3,$2e6::+!,C,$286,$28f::-,C,$229,$230::/,C,$246,$24d::<,C,$208,$21d::=,C,$21d,$229::ABS,C,$3d9,$3df::AND,C,$231,$238::BOOT,C,$202,$0::BR.BWD,C,$35e,$361::BR.FWD,C,$35b,$35e::BRPOS.BWD,C,$358,$35b::BRPOS.FWD,C,$355,$358::BRZERO.BWD,C,$352,$355::BRZERO.FWD,C,$34f,$352::COPY,C,$2b2,$2cf::FILL,C,$2cf,$2df::HALT,C,$2df,$2e2::MOD,C,$24d,$253::NEXT.HANDLER,C,$338,$34f::NOT,C,$3e2,$3e9::OR,C,$238,$23f::P!,C,$29c,$2a6::P@,C,$293,$29c::RANDOM,C,$3f8,$0::SPR.CONTROL,C,$48a,$495::SPR.HFLIP,C,$495,$4aa::SPR.HIDE.ALL,C,$501,$521::SPR.IMAGE,C,$47c,$48a::SPR.MOVE,C,$463,$47c::SPR.RESET,C,$419,$442::SPR.SELECT,C,$442,$463::SPR.UPDATE,C,$4c5,$501::SPR.VFLIP,C,$4aa,$4c5::SPRITE.UDG.BASE!,C,$552,$559::STRING.INLINE,C,$2a7,$0::STRLEN,C,$3e9,$3f8::XOR,C,$23f,$246::16*,M,$3a7,$3ab::256*,M,$3ab,$3ae::256/,M,$3d6,$3d9::2*,M,$3a1,$3a2::2/,M,$3ae,$3b2::4*,M,$3a2,$3a4::8*,M,$3a4,$3a7::!,M,$27e,$282::+,M,$230,$231::++,M,$386,$387::+++,M,$387,$389::--,M,$385,$386::---,M,$383,$385::;,M,$2a6,$2a7::@,M,$282,$286::A>B,M,$301,$303::A>C,M,$303,$305::A>R,M,$31c,$31d::A>X,M,$30d,$310::A>Y,M,$313,$316::AB>R,M,$322,$324::ABC>R,M,$326,$329::B>A,M,$305,$307::B>C,M,$307,$309::B>R,M,$31e,$31f::BC>R,M,$32c,$32e::BREAK,M,$2e2,$2e3::BSWAP,M,$3df,$3e2::C!,M,$28f,$290::C>A,M,$309,$30b::C>B,M,$30b,$30d::C>R,M,$320,$321::C@,M,$290,$293::POP,M,$31a,$31c::PUSH,M,$319,$31a::R>A,M,$31d,$31e::R>AB,M,$324,$326::R>ABC,M,$329,$32c::R>B,M,$31f,$320::R>BC,M,$32e,$330::R>C,M,$321,$322::R>X,M,$332,$334::R>Y,M,$336,$338::SWAP,M,$300,$301::X>A,M,$310,$313::X>R,M,$330,$332::Y>A,M,$316,$319::Y>R,M,$334,$336"
	end

	def getCode
		return "31,0,f0,c3,2,2,7c,aa,87,30,4,7a,87,18,5,d5,eb,ed,52,d1,3e,0,de,0,6f,67,c9,7c,aa,67,7d,ab,b4,21,0,0,c0,2b,c9,d5,eb,af,ed,52,d1,c9,19,7c,a2,67,7d,a3,6f,c9,7c,b2,67,7d,b3,6f,c9,7c,aa,67,7d,ab,6f,c9,d5,cd,53,2,eb,d1,c9,d5,cd,53,2,d1,c9,c5,42,4b,eb,21,0,0,78,6,8,17,ed,6a,ed,52,30,1,19,10,f6,17,2f,47,79,48,6,8,17,ed,6a,ed,52,30,1,19,10,f6,17,2f,51,5f,c1,c9,73,23,72,2b,7e,23,66,6f,7e,83,77,23,7e,8a,77,2b,c9,73,6e,26,0,c5,44,4d,ed,68,26,0,c1,c9,c5,e5,7b,44,4d,ed,79,e1,c1,c9,c9,f3,eb,e3,e5,7e,23,b7,20,fb,e3,c9,78,b1,c8,c5,d5,e5,af,ed,52,30,b,19,9,eb,9,eb,1b,2b,ed,b8,18,3,19,ed,b0,e1,d1,c1,c9,78,b1,c8,c5,d5,7d,12,13,b,78,b1,20,f8,d1,c1,c9,76,18,fd,f3,c3,e6,2,c5,d5,44,4d,21,0,0,cb,41,28,1,19,cb,38,cb,19,eb,29,eb,78,b1,20,f0,d1,c1,c9,eb,54,5d,44,4d,62,6b,42,4b,60,69,50,59,e5,dd,e1,dd,e5,e1,e5,fd,e1,fd,e5,e1,e5,eb,e1,e5,e1,d5,d1,c5,c1,d5,e5,e1,d1,c5,d5,e5,e1,d1,c1,c5,d5,d1,c1,dd,e5,dd,e1,fd,e5,fd,e1,d9,e1,d1,7a,b3,20,4,23,e5,d9,c9,4e,6,0,af,ed,42,e5,1b,d5,d9,e1,c9,af,18,f,37,18,c,af,18,10,37,18,d,af,18,13,37,18,10,8,7c,b5,28,b,18,5,8,cb,7c,28,4,e3,23,e3,c9,d9,e3,5e,16,0,8,38,4,19,e3,d9,c9,af,ed,52,e3,d9,c9,2b,2b,2b,23,23,23,7c,2f,67,7d,2f,6f,23,c9,cb,7c,21,0,0,c8,2b,c9,7c,b5,21,0,0,c0,2b,c9,29,29,29,29,29,29,29,29,29,29,65,2e,0,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,cb,2c,cb,1d,6c,26,0,cb,7c,c8,c3,89,3,7d,6c,67,7c,2f,67,7d,2f,6f,c9,d5,eb,21,0,0,1a,b7,28,4,13,23,18,f8,d1,c9,eb,c5,2a,15,4,44,4d,29,29,2c,9,22,15,4,2a,17,4,29,9f,e6,2d,ad,6f,22,17,4,9,c1,c9,cd,ab,b9,fd,f5,c5,d5,e5,22,21,5,7b,32,23,5,87,47,e,6,36,ff,23,d,20,fa,71,23,71,23,10,f2,21,27,5,22,25,5,cd,37,5,e1,d1,c1,f1,c9,f5,c5,e5,3a,23,5,bd,28,e,fa,59,4,29,29,29,29,ed,5b,21,5,19,18,3,21,27,5,22,25,5,e1,d1,f1,c9,dd,e5,dd,2a,25,5,dd,73,8,dd,72,9,dd,75,a,dd,74,b,dd,cb,f,fe,dd,e1,c9,dd,e5,dd,2a,25,5,dd,75,c,dd,74,d,18,eb,dd,e5,dd,2a,25,5,dd,75,e,18,e0,f5,dd,e5,dd,2a,25,5,dd,cb,e,ae,7d,b4,28,19,dd,cb,e,ee,18,13,f5,dd,e5,dd,2a,25,5,dd,cb,e,b6,7d,b4,28,4,dd,cb,e,fe,dd,cb,f,fe,dd,e1,f1,c9,f5,c5,d5,e5,dd,e5,3a,23,5,47,dd,2a,21,5,dd,7e,f,b7,c4,e8,4,11,10,0,dd,19,10,f2,dd,e1,e1,c1,d1,f1,c9,c5,dd,36,f,0,cd,60,5,dd,e5,d1,21,8,0,19,1,7,0,ed,b0,cd,59,5,c1,c9,f5,c5,d5,dd,e5,3a,23,5,47,dd,2a,21,5,11,10,0,cd,60,5,dd,cb,f,fe,dd,19,10,f5,e1,c1,d1,f1,c9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,f5,e5,21,0,8,36,0,23,7c,fe,c,20,f8,3a,c4,7,6f,26,8,36,ff,2c,20,fb,e1,f1,c9,f5,7d,32,c4,7,f1,c9,dd,cb,7,7e,c0,18,5,dd,cb,7,7e,c8,f5,c5,d5,e5,fd,e5,dd,cb,6,7e,c2,a0,6,dd,7e,1,47,e6,fe,dd,b6,3,20,11,dd,7e,2,fe,f0,30,a,5,20,a,dd,7e,0,fe,40,38,3,c3,a0,6,26,0,dd,7e,2,e6,f8,6f,54,5d,29,29,19,fd,21,0,f8,eb,fd,19,dd,5e,0,dd,56,1,cb,3a,cb,1b,cb,3b,cb,3b,16,0,fd,19,dd,7e,0,e6,7,87,32,49,6,dd,7e,2,e6,7,32,c1,7,3e,8,dd,cb,6,4e,28,1,87,32,c0,7,dd,6e,4,dd,66,5,11,1,0,dd,cb,6,46,28,1,13,dd,cb,6,76,28,18,eb,e5,29,29,29,dd,cb,6,4e,28,1,29,19,c1,e5,21,0,0,af,ed,42,d1,eb,19,22,27,6,ed,53,37,6,cd,af,6,da,a0,6,fd,e5,cd,67,7,fd,23,cd,67,7,dd,cb,6,46,28,5,fd,23,cd,67,7,fd,e1,21,0,0,1e,0,56,dd,cb,6,46,28,4,23,5a,56,2b,1,0,0,9,22,27,6,dd,cb,6,6e,28,3,cd,83,7,af,eb,18,0,29,8f,29,8f,29,8f,29,8f,29,8f,29,8f,29,8f,29,8f,eb,21,8,f6,ae,77,21,10,f6,7a,ae,77,dd,cb,6,46,28,6,21,18,f6,7b,ae,77,21,c0,7,35,28,28,21,61,6,34,21,6d,6,34,21,5c,6,34,7e,e6,7,20,9d,af,32,c1,7,11,28,0,fd,19,11,b0,fc,fd,e5,e1,37,ed,52,30,3,c3,9,6,dd,7e,7,ee,80,dd,77,7,fd,e1,e1,d1,c1,f1,c9,c5,fd,e5,ed,73,c2,7,dd,cb,7,7e,28,a,3a,c4,7,47,fd,7e,0,b8,38,4c,21,0,0,e5,cd,1a,7,38,21,22,5c,6,e5,fd,23,cd,1a,7,38,16,22,61,6,e5,dd,cb,6,46,28,2d,fd,23,cd,1a,7,38,5,22,6d,6,18,21,d1,7a,b3,37,28,1c,cb,3a,cb,1b,cb,3a,cb,1b,cb,3a,cb,1b,6b,26,8,7e,36,ff,26,a,5e,26,b,56,12,18,df,af,ed,7b,c2,7,fd,e1,c1,c9,3a,c4,7,6f,fd,7e,0,bd,30,32,26,8,7e,fe,ff,28,5,2c,20,f8,37,c9,fd,7e,0,77,fd,e5,c1,26,a,71,26,b,70,fd,7e,0,fd,75,0,cd,60,7,eb,fd,7e,0,cd,60,7,eb,1,8,0,ed,b0,fd,7e,0,cd,60,7,3a,c1,7,b5,6f,af,c9,6f,26,1e,29,29,29,c9,fd,6e,0,26,9,dd,cb,7,7e,20,2,34,c9,35,c0,26,a,5e,26,b,56,26,8,7e,12,36,ff,c9,7a,cd,95,7,57,dd,cb,6,46,c8,6b,5f,7d,cd,95,7,57,c9,b7,c8,cd,9e,7,f,f,f,f,f5,e6,f,c6,b0,6f,26,7,f1,e6,f0,b6,c9,0,0,0,0,0,0,8,4,c,2,a,6,e,1,9,5,d,3,b,7,f,0,0,0,0,80,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
	end

end