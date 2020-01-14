/*

Plan for semester:

Workshop 24th of January

Concert in June

Themes:
- 10th of Feb: Crash course on writing classes 
- 9th of March: Talking directly to the server

- Machine learning?

14th-16th of March: Work session with Marije Baalman
https://notam.no/work-session-marije-baalman-mapping-my-mapping/

Francois Pachet: Flow machines

Dutch AI composer: https://aibusiness.com/aiva-is-the-first-ai-to-officially-be-recognised-as-a-composer/  
*/

(
	Pdef(\martin1, 
		Pbind(
			\dur, Pdefn(\amazingDuration, 0.25), 
			\degree, Pwhite(0,10)
		)
	).play;
	
	Pdef(\martin2, 
		Pbind(
			\dur, 0.25,
			\degree, Pwhite(0,10)
		)
	).play;

)

(
	Tdef(\martinChanger, {
		var coin, newdur, sequence;

		// Let's use a pattern!
		sequence = Pseq([1,0.5, 0.25, 0.33],inf);

		// Turn into a stream so that we can get the pattern values
		sequence = sequence.asStream;

		loop{
			1.wait; 

			// True or false
			coin = 0.5.coin;

			// If the coin toss is true, then change the duration
			if(coin, {
				newdur = sequence.next;

				"New duration: %".format(newdur).postln;

				// Modify patterns
				Pbindef(\martin1, \dur, newdur);
				Pbindef(\martin2, \dur, newdur * 2);

			})
		}
	}).play
)

Pdefn(\amazingDuration, Pseq([0.25, 0.1], inf))

Pbindef(\martin, \dur, 0.01)

Tdef(\martinChanger).stop

Pdefn(\megaTight, 1).quant = 4;

Pdefn(\megaTight, 0.225)

(
	Pdef(\hello, 
		Pbind(
			\dur, Pdefn(\megaTight, 0.1),
			\degree, Pwhite(0,7)
		)
	);
)

(
	Ndef(\reverbDemo).source = Pdef(\hello);

	Ndef(\reverbDemo)[1] = \filter -> {|in|
		//Cheeseverb1.ar(in,  fbamount: 1.15,  highcut: 5300,  lowcut: 100,  verbtime: 5.0,  modfreq: 0.9,  damp: 0.1,  modamount: 0.95)
		Skyrverb2.ar(in,  verbtime: 5.31,  modfreq: 0.05,  damp: 0.09,  decay: 0.95,  lowcut: 80,  highcut: 12500,  modamount: 0.95)
	};

	Ndef(\reverbDemo).xset(\wet1, 0.75).fadeTime_(1).play;
)
