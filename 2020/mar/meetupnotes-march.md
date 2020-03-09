### cycle
```
Quarks.install("https://github.com/yannics/cycle")
```
example:
```
Pbind(\degree, [1,2,3,4,1].kaprekar(5).pattern(inf, true, false), \dur, 3.euclidean(8, true).pattern(inf)/4).play;
```

### Kenneth Flak was here
Check out his company's website: https://www.roosnaflak.com

### Mads Pspawn example

```
(
	Pdef(\spawnymacspawny,
		Pspawn(
			Pbind(
				\method, \par,
				\delta, 1, 

				\numNotes, Pwhite(1,16),	

				\pattern, Pfunc({|event|
					var numNotes = event[\numNotes];

					"HEy!!! New pattern spawned with % notes!".format(numNotes).postln;

					Pbind(
						\dur, [0.25, 0.125, 1/16].choose, 
						\degree, Pn(10.rand, numNotes)
					)

				})
			)
		)
	).play
)
```
