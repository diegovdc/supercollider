~automatic_playing.(rrand(4.0,5));

~active_synths.postln
~play_synth.(~ss);
~stop_synth.(~active_synths);
~dont_continue.();



(//para precargar todo lo necesario
~fundamental = 20;

(
~harm_pair_list = [
	[9,10],
	[11,12],
	[13,14],
	[15,16],
	[17,19],
	[21, 23]
]
);

~harm_pair = { |fundamental, pair| pair.collect({|f| f * fundamental})};

~harm_pair1 = ~harm_pair.(~fundamental, _);

//~freq_pair_list :: HarmPairs[[harm1, harm2]] -> FreqPairs[[freq1, freq2]]
~make_freq_pairs = _.collect(~harm_pair1);

//~freq_pair_list :: FreqPairs[[freq1, freq2]]
~freq_pair_list = ~make_freq_pairs.(~harm_pair_list);

(//~make_synth_pair :: [freq1, freq2] -> [Synth, Synth]
~make_synth_pair = {
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
);

//~make_synth_pair :: [[freq1, freq2]] -> [[Synth, Synth]]
~make_synth_pairs = _.collect(~make_synth_pair);

//~ss :: [[Synth, Synth]]
~ss = ~make_synth_pairs.(~freq_pair_list);

//~active_synths :: [[Synth, Synth]]
~active_synths = List[];


//activación y desactivación de los sintes
(
~play_synth = {
	|ss|
	var len, selected, playing;
	len = ss.size;
	selected = ss[len.rand];
	playing = selected.play(fadeTime:6);
	~active_synths.add(playing);
	~active_synths.size.postln;
}
);

(
~stop_synth = {
	|active_ss|
	var len, stopped;

	len = active_ss.size;
	if(len > 0, {
		"borrando".postln;
		stopped = active_ss.removeAt(len.rand);
		stopped.release;
	}, {});
	~active_synths.size.postln;
}
);


//manejo del tiempo
~continue = true;
~dont_continue = {~continue = false};

(
~automatic_playing = {
	|time|
	if(~continue == true,
		{
			SystemClock.sched(rrand(4.0,120), {
				if(~active_synths.size > 1, {
					~stop_synth.(~active_synths);
				}, {})

			});
			SystemClock.sched(time, {
				~play_synth.(~ss);
				~automatic_playing.(rrand(4.0,60));
			});
		},
		{
			"recursive calls are disabled".postln
		}
	)
}
);

)

