/*
Based on Haralds noise patch we talked about the Select UGen, and
that it works like a selector knob that choose which of the items
in the array to listen to.

In Haralds code the first argument of the Select is called 'counter'.
This naming may be a bitt confusing, as it is the output of a counter
that is used to select which item in the array to listen to. If this
variable was called 'index' it it easier to understand how the Select
UGen works.

Anyway I made some different examples og counter Ndef, i.e. Ndefs that
count from a start value to an end value, with a specific rate. They are
a bit different, but showcases the different techniques to do server side
counting.
*/

//----Stepper counter-----

/*
The easiest way to make a counter is with the Stepper UGen.
Not that the reset argument has prepended a 't_' i.e. 't_reset'. This
denotation tells SuperCollider that this argument is a trigger rate
argument, which has a specific meaning for synth arguments. A trigger
argument is when a UGen is listening for a change from 0 to non-zero
transition events. Is is often used in dynamic control of envelopes,
such as in the EnvGen Ugen, for the 'gate' argument specifically.

Take a look at the SynthDef helpfil under 'Examples->Argument Rates'
for some examples of trigger rate arguments.
*/
(
Ndef(\stepperCounter, {|t_reset=1, start = 0, end = 8, rate = 1|
	var diff = end - start;
	var val = Stepper.ar(Impulse.ar(diff * rate), t_reset, start, end);
	// val.poll(label: \stepper);
	val;
})
);
//set the start value
Ndef(\stepperCounter).set(\start, 1);
//sets the end value
Ndef(\stepperCounter).set(\end, 4);
// set both values at the same time.
Ndef(\stepperCounter).set(\start, 10, \end, 15);
//the rate sets how many times per second the count should happen.
// count from start to end 2 times per second.
Ndef(\stepperCounter).set(\rate, 2.0);
//Sending a trigger arg resets the count to start value
Ndef(\stepperCounter).set(\t_reset, 1);

//We can map this to a Ndef with a Select Ugen using the .map
//method
(
Ndef(\selector, {|root = 100, index = 0|
	var freq;
	var items = 10.collect({arg i;
		root * (i+1)
	});
	freq = Select.kr(index, items);
	VarSaw.ar(freq, width: LFDNoise3.kr(0.3).range(0.1, 0.99));
}).play(vol: -10.dbamp)
)

Ndef(\selector).map(\index, Ndef(\stepperCounter));

//Try different settings
Ndef(\stepperCounter).set(\start, 0, \end, 9, \rate, 1);
Ndef(\stepperCounter).set(\start, 0, \end, 8, \rate, 1);
Ndef(\stepperCounter).set(\start, 0, \end, 3, \rate, 3);
Ndef(\stepperCounter).set(\start, 0, \end, 4, \rate, 4);

//This is how you plot the counter output in a graph.
//Wait 3 seconds for it to  finish and then contens is drawn in
//the window:
(
{|t_reset=1, start = 0, end = 8, rate = 1|
	var diff = end - start;
	var val = Stepper.ar(Impulse.ar(diff * rate), t_reset, start, end);
	val.poll(label: \stepper);
	val;
}.plot(duration: 3.0);
)


//Here are different other counters that you can try

//----Stepper counter-----
(
Ndef(\sweepCounter, {|start = 0, end = 5, rate = 1, t_reset|
	var trig = Impulse.ar(rate);
	var val = Sweep.ar(trig + t_reset, rate).linlin(0.0, 1.0, start, end+1);
	val = val.floor;
	val.poll;
});
)
//change the mapping for the index arg to this new sweep counter.
Ndef(\selector).map(\index, Ndef(\sweepCounter));
Ndef(\sweepCounter).set(\start, 0, \end, 9, \rate, 1);
Ndef(\sweepCounter).set(\start, 0, \end, 3, \rate, 1);
Ndef(\sweepCounter).set(\start, 0, \end, 3, \rate, 2);
Ndef(\sweepCounter).set(\t_reset, 1); // you can also reset this one

//Free the counter
Ndef(\sweepCounter).free;

//----Duty counter-----
(
Ndef(\dutyCounter, {|t_reset=1, start = 0, end = 3, rate=1|
	var range = (end - start).abs;
	var val = Duty.kr((rate * range).reciprocal, t_reset, Dseries(start, 1, inf)) % (end + 1);
	val.poll(label: \duty);
	val;
});
)
Ndef(\selector).map(\index, Ndef(\dutyCounter));
Ndef(\dutyCounter).set(\start, 0, \end, 3, \rate, 1);
Ndef(\dutyCounter).set(\start, 0, \end, 3, \rate, 2);
Ndef(\dutyCounter).set(\start, 0, \end, 3, \rate, 5);

Ndef(\dutyCounter).free;

//-----Demand counter-----
(
Ndef(\demandCounter, {|t_trig, t_reset, start = 0, end = 6|
	var val = Demand.kr(t_trig + t_reset, t_reset, Dseries(start, 1, inf)) % (end + 1);
	val.poll(label: \demand)
});
)
Ndef(\selector).map(\index, Ndef(\demandCounter));
//With this Uggen you can ask for the next value specifically with the
//trigger arg 't_trig'. This could be connected to a drumpad e.g.
//every time you run this line a new index is generated.
Ndef(\demandCounter).set('t_trig', 1);
Ndef(\demandCounter).set('t_reset', 1); //and reset works too.

//And thia can be mapped to a different Ndef that triggers it:
Ndef(\clicker, {Impulse.kr(\freq.kr(4));});
Ndef(\demandCounter).map('t_trig', Ndef(\clicker));
//Now control the speed with the clicker
Ndef(\clicker).set(\freq, 6);
Ndef(\clicker).set(\freq, 2);
Ndef(\clicker).set(\freq, 8);

//Change the source of the clicker to a random clicker Ugen, i.e. Dust
Ndef(\clicker, {Dust.kr(\freq.kr(4));});
Ndef(\clicker).set(\freq, 12);

//"Humanize" clicker
Ndef(\clicker, {GaussTrig.kr(\freq.kr(4), \deviation.kr(0.2))});
Ndef(\clicker).set(\freq, 5, \deviation, 0.0); //no human, robotic musical perfection
Ndef(\clicker).set(\freq, 5, \deviation, 1.0); //full human, puny rhytmical creatures heading for musical extinction.

//Duty and Demand can use D type of Pattern class, i.e. Demand Ugens:
//examples are: Dseries, Dseq, Drand, etc.
(
Ndef(\demandCounter, {|t_trig, t_reset, start = 0, end = 6|
	var val = Demand.kr(t_trig + t_reset, t_reset,
		Drand([
			Dseq([0,2,4], 4),
			Dseq([1,3,5], 4),
			Dseq([2,4,6], 4),
			Dseq([3,5,7,9].reverse, 1),
			Dseq([2,4,6,8].reverse, 1),
			Dseq([9,8,7,6,5,4,3,2,1,0], 1)
		], inf)
	) % (end + 1);
	val.poll(label: \demand)
});
)
Ndef(\clicker).set(\freq, 12, \deviation, 0.0);