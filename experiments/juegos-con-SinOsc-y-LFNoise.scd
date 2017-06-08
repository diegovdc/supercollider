//vibrato
{SinOsc.ar(440 + SinOsc.kr(10, 100, 100, 10))}.play

//random pitches
{SinOsc.ar(440 + LFNoise0.kr(10, 100, 100, 10))}.play

(
x = {//suena bien comenzando con 180 (armónico 9)  y 200 (armónico 10), luego agregando otros armónicos
	[SinOsc.ar(
		300,
		LFNoise2.kr(0.001, 10)*0.000001,
		LFNoise2.kr(0.5, 100)*0.0001
	),
	SinOsc.ar(
		320,
		LFNoise2.kr(0.001, 10)*0.000001,
		LFNoise2.kr(0.1, 100)*0.0001
	)
	]
}.scope
)

x.free//calla al sinte sin detener a los demás
