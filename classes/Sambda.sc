Sambda {

	add {
		|a,b|
		^a+b
	}

	map {
		|fn, xs|
		^xs.collect(fn)
	}

	reduce{
		|fn, acc, array|
		for(0, array.size - 1, {
			|i|
			acc = fn.(acc, array[i])
		});
		^acc;
	}

	reduceAccum {
		|fn, acc, array|
		var list = List[acc];
		for(0, array.size - 1, {
			|i|
			acc = fn.(acc, array[i]);
			list.add(acc);
		});
		^list
	}

	concat {
		|xxs|
		^this.reduce({|a, b| a ++ b}, [], xxs);
	}

	repeat {
		|times, xs|
		^xs ! times
	}

	midicps {
		|midi|
		^midi.midicps
	}

}


l = Sambda()
l.midicps(69)
// l.concat([[2,3], [4,5], [6,7,8]])
// l.repeat(5, 5)
// l.reduceAccum(l.add(_,_), 0, [1,2,3,4,5])
// l.map({|x| x*2}, [1,2,3])


