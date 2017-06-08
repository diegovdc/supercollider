{SinOsc.ar(440 + SinOsc.kr(10, 100, 100, 10))}.play
{SinOsc.ar(440 + LFNoise0.kr(10, 100, 100, 10))}.play

(
x = {
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
}.free
)


y = x[2]
y.inspect
x.free

{ var freq = 1000; [LFNoise1.ar(freq), Impulse.ar(freq)] }.plot

y = (0..5) do: { |item| var a = (item*2); a.postln };

y.postln

(
{ // distorts and envelopes z
var z;
z = FSinOsc.ar(500);
z max: FSinOsc.ar(0.1);
}.scope;
)