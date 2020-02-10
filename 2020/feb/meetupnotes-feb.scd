/*

AGENDA

1. NEWS
2. The Round

3. HELP / BREAK TIME

4. Let's Talk About Classes!
5. Next time: Who's bringing the cake and what are we doing?

*/

/*****************************
			NEWS
*****************************/
- The agenda is back
- We bought more copies of Andrea Valle's book
- All meetup notes are here from now on: https://github.com/notam02/supercollider-meetup 
- New CD coming from Mads: https://ambitioustapes.bandcamp.com/album/akkorder-2
- New music from Mike: https://mikemccormickmusic.com/music/proxemics/
- Harald is playing a concert, do you want to be his plus one? He thinks it will work out great. 29th of feb, "Grønland 3" at 9 or 10 o clock or something.
- 29th of February at Bruket: 3D music at Bruket / Ny Musikk Komponistgruppe
- 28th of February: Open house, Mike McCormick will demo some SC stuff

/*****************************
			TheRound
*****************************/

// Mike is wondering about the timing of SC
TempoClock.default.beatsPerBar

// Harald's crazy weird noise synth
(
Ndef(\noiz, {|freq=34|
	//var sr = SampleRate.ir/6; //fix sample rate
	var sr = SampleRate.ir/MouseY.kr(1,12,1); //variable sample rate
	//var freq = 4;
	//var freq = Amplitude.ar(SoundIn.ar).range(0.001,10);
	//var freq = Pitch.ar(SoundIn.ar).range(0.001,10);
	var n = 16; //bit resolution
	//creating a raising value from 0 to 2**n
	var t = Phasor.ar(trig:1, rate: freq*((2**n)/sr), start: 0, end: ((2**n)-1)); 

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

// Make a gui!
Ndef(\noiz).gui;
)

/*****************************
			CLASSES
*****************************/

// See help file "Writing Classes": http://doc.sccode.org/Guides/WritingClasses.html 
// Simple example: PolyBuf https://github.com/madskjeldgaard/PolyBuf/blob/master/PolyBuf.sc

// Where to put classes
Platform.userExtensionDir.openOS;

// Class extensions
// Pseudo ugens

/*****************************
			NEXT TIME
*****************************/

// Theme: Server communication
// Who's bringing cake?
