s.boot

//objetivo: ayudarme a mejorar la entonación de notas en la flauta. Hará sonar notas al azar dentro de una escala y yo podre tocar esa nota o un intervalo y asegurarme de que esté correctamente afinada

//random sine notes of a scale

//intervals
~scale = [2,2,1,2,2,2,1];//for 12TET the intervals in this array should add up to 12

~starting_midi_note = 69; //A440
~octaves_up = 1;
~octaves_down = 0;


(
~reduce = {
	|fn, acc, array|
	for(0, array.size - 1, {
		|i|
		acc = fn.(acc, array[i])
	});
	acc

}
)

(
~reduceAccum = {
	|fn, acc, array|
	var list = List[acc];
	list.postln;
	for(0, array.size - 1, {
		|i|
		acc = fn.(acc, array[i]);
		list.add(acc);
	});
	list
}
)

{SinOsc.ar([69.midicps, 81.midicps])}.play
~add = {|a,b| a+b}
~reduceAccum.(~add, 69, ~scale)


~concat = ~reduce.({|a, b| a ++ b}, [], _)

~concat.([ [ 2, 2, 1, 2, 2, 2, 1 ], [ 4, 4, 2, 4, 4, 4, 2 ] ])

(
~repeat = {
	|reps, thing|
	var list = List[];
	for(1, reps, {
		list.add(thing)
	});
	list
}
)

~repeat.(10, "hello")



(
~get_upper_octave_notes = {
	|starting_note, octaves, intervals|
	~reduceAccum.(
		~add,
		starting_note,
		~concat.(~repeat.(octaves,intervals))
	)
};
~get_upper_octave_notes.(69, 2, ~scale);
)


(
~get_lower_octave_notes = {
	|starting_note, octaves, intervals|
	~get_upper_octave_notes.(starting_note - (octaves*12), octaves, intervals)
};
~get_lower_octave_notes.(69, 2, ~scale);
)


{SinOsc.ar([69.midicps, 45.midicps])}.play
