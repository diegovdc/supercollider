//vibrato
r = {SinOsc.ar(440 + SinOsc.kr(10, 100, 100, 10))}.play(fadeTime:2)

r.inspect

r.release

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
~make_s_pair = {
	|freq_pair|
	{
		[SinOsc.ar(
			freq_pair[0],
			LFNoise2.kr(0.001, 10)*0.00001,
			LFNoise2.kr(0.5, 100)*0.01
		),
		SinOsc.ar(
			freq_pair[1],
			LFNoise2.kr(0.001, 10)*0.00001,
			LFNoise2.kr(0.8, 100)*0.01
		)]
	}
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


//~freq_pair_list :: HarmPairs[[harm1, harm2]] -> FreqPairs[[freq1, freq2]]
~make_freq_pairs = _.collect(~harm_pair1)


(
~harm_pair_list = [
	[9,10],
	[11,12],
	[13,14],
	[15,16],
	[17,19],
	[21, 23]
]
)

~freq_pair_list = ~make_freq_pairs.(~harm_pair_list)

~s_pairs = _.collect(~make_s_pair)

~ss = ~s_pairs.(~freq_pair_list)
~ss[0].play(fadeTime:2)
~ss.size
s.boot

6.rand

l = List[]
l.add(5)
l
l.size
f = l.removeAt(0)
f

~active_s = List[]

(
~play_s = {
	|ss|
	var len, selected, playing;
	len = ss.size;
	selected = ss[len.rand];
	playing = selected.play(fadeTime:2);
	~active_s.add(playing);
}
)




(
~stop_s = {
	|active_ss|
	var len, stopped;
	len = active_ss.size;
	stopped = active_ss.removeAt(len.rand);
	stopped.release;
	~active_s
}
)

~play_s.(~ss)
~stop_s.(~active_s)

SystemClock.sched(5, { "hello".postln });

SystemClock.sched(5, { "hello".postln });

(
~recursive_event = {
	|time|
	{
		SystemClock.sched(rrand(4.0,5), {
			~stop_s.(~ss)
		});
		SystemClock.sched(time, {
			~play_s.(~ss);
			~recursive_event.(rrand(4.0,5));
		});
	}.()

}
)

~recursive_event.(rrand(4.0,5))
rrand(4.0,5)