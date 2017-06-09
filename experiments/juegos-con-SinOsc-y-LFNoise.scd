//vibrato
{SinOsc.ar(440 + SinOsc.kr(10, 100, 100, 10))}.play

//random pitches
{SinOsc.ar(440 + LFNoise0.kr(10, 100, 100, 10))}.play

(
x = {//suena bien comenzando con 180 (armónico 9)  y 200 (armónico 10), luego agregando otros armónicos
	|freq1, freq2|
	[SinOsc.ar(
		220,
		LFNoise2.kr(0.001, 10)*0.000001,
		LFNoise2.kr(0.5, 100)*0.0001
	),
	SinOsc.ar(
		260,
		LFNoise2.kr(0.001, 10)*0.000001,
		LFNoise2.kr(0.1, 100)*0.0001
	)
	]
}
)
~y = [x.play(fadeTime:2), x.play(fadeTime:2)]
~y.inspect
~y[1].release
y.free//calla al sinte sin detener a los demás


(
c = {
	|freq1|
	{SinOsc.ar(freq1, 0.5 ,0.6)}.play
}
)

c.value(220)

(
~s_pair = {
	|freq1, freq2|
	{
		[SinOsc.ar(
			freq1,
			LFNoise2.kr(0.001, 10)*0.000001,
			LFNoise2.kr(0.5, 100)*0.0001
		),
		SinOsc.ar(
			freq2,
			LFNoise2.kr(0.001, 10)*0.000001,
			LFNoise2.kr(0.1, 100)*0.0001
		)]
	}.play
}
)

~s_pair.value(180, 200)

~fundamental = 20

(
~harm_pair = { |fundamental, pair|
	pair.collect({|f| f * fundamental})
}
)


~harm_pair1 = ~harm_pair.(~fundamental, _)
~harm_pair1.([9, 10])