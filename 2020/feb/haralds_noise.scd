(
Ndef(\noiz, {|freq=34|
	//var sr = SampleRate.ir/6; //fix sample rate
	var sr = SampleRate.ir/MouseY.kr(1,12,1); //variable sample rate
	//var freq = 4;
	//var freq = Amplitude.ar(SoundIn.ar).range(0.001,10);
	//var freq = Pitch.ar(SoundIn.ar).range(0.001,10);
	var n = 16; //bit resolution
	//creating a raising value from 0 to 2**n
	var t = Phasor.ar(1,freq*((2**n)/sr),0,((2**n)-1)); 

	//t = t & (2**(n-1)); // few tests
	//t = t * 4;
	//equations try one at the time
	//var counter = LFSaw.ar(0.5,0,3.5,3.5);
	var counter = LFDNoise0.ar(MouseY.kr(1,0.1),3.5,3.5);
	t = Select.ar(counter,[
		t*(((t>>64)|(t>>8))&(63&(t>>4))),
		t*(((t>>9)|(t>>13))&(25&(t>>6))),
		t*(((t>>5)|(t>>8)) & 63),
		t*(((t>>11)&(t>>8))&(123&(t>>3))),
		t*(t>>8*((t>>15)|(t>>8))&(20|(t>>19)*5>>t|(t>>3))),
		t*(t>>((t>>9)|(t>>8))&(63&(t>>4))),
		(t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	]);
	t = t % (2**(n));// avoiding number beyond 2**(bit resolution)
	t = t*(0.5**(n-1)) - 1;//scaling to -1, 1

	LeakDC.ar(t.dup)
}).play;
)

s.meter;
s.scope;




(
s = Synth(\noiz);
s.meter;
s.scope;
)

s.free;
