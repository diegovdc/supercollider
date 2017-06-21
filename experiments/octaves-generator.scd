s.boot;

//objetivo: ayudarme a mejorar la entonación de notas en la flauta. Hará sonar notas al azar dentro de una escala y yo podre tocar esa nota o un intervalo y asegurarme de que esté correctamente afinada

//random sine notes of a scale

//intervals

l = Sambda()


~scale = [2,2,1,2,2,2,1];//for 12TET the intervals in this array should add up to 12

~starting_midi_note = 69; //A440
~octaves_up = 1;
~octaves_down = 0;



{SinOsc.ar([69.midicps, 81.midicps])}.play;

l.reduceAccum(l.add(_,_), 69, ~scale);



(
~get_upper_octave_notes = {
	|starting_note, octaves, intervals|
	l.reduceAccum(
		l.add(_,_),
		starting_note,
		l.concat(l.repeat(octaves,intervals))
	)
};
~get_upper_octave_notes.(69, 2, ~scale);
);


(
~get_lower_octave_notes = {
	|starting_note, octaves, intervals|
	~get_upper_octave_notes.(starting_note - (octaves*12), octaves, intervals)
};
~get_lower_octave_notes.(69, 2, ~scale);
);


~midistofreqs = _.collect(_.midicps);

~freq_scale = l.concat([
	~midistofreqs.(~get_lower_octave_notes.(69, 2, ~scale),
	~midistofreqs.(~get_upper_octave_notes.(69, 2, ~scale)
]);

~make_synth = {
	|freq|
	{SinOsc.ar([freq, freq], 0, 0.25)}
}
~synths[0].play
~synths = ~freq_scale.collect(~make_synth)

//activación y desactivación de los sintes
~active_synths = List[];

~play_synth = {
	|synths|
	var len, selected, playing;
	len = synths.size;
	selected = synths[len.rand];
	selected.postln;
	playing = selected.play(fadeTime:2);
	playing.postln;
	~active_synths.add(playing);
	~active_synths.size.postln;
};


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
};


//manejo del tiempo
~continue = true;

//continuar o no la reproducción automática
~do_continue = {~continue = true};
~dont_continue = {~continue = false};

~automatic_playing = {
	|time|
	if(~continue == true,
		{
			SystemClock.sched(rrand(4.0,10), {
				if(~active_synths.size > 1, {
					~stop_synth.(~active_synths);
				}, {})

			});
			SystemClock.sched(time, {
				~play_synth.(~synths);
				~automatic_playing.(rrand(6.0,15));
			});
		},
		{
			"recursive calls are disabled".postln
		}
	)
};

~dont_continue.()
~automatic_playing.(4);
~play_synth.(~synths);
~stop_synth.(~active_synths)

{SinOsc.ar([69.midicps, 0])}.play;

a = Scale.phrygian.degreeToFreq(2, 60.midicps, 1);
b = Scale.phrygian.tuning_(\just).degreeToFreq(2, 60.midicps, 1);
