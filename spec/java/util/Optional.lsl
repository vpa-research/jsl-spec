libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Optional.java";

// imports

import java/lang/Object;


// primary semantic types

// original type for use in other places
@Parameterized(["T"])
@final type Optional
    is java.util.Optional
    for Object
{
    @static fun *.empty(): Object; // #problem: self-reference

    @static fun *.of(obj: Object): Object; // #problem: self-reference

    @static fun *.ofNullable(obj: Object): Object; // #problem: self-reference

    fun *.isPresent(): boolean;

    fun *.isEmpty(): boolean;

    fun *.get(): Object;

    fun *.orElse(other: Object): Object;
}


// global aliases and type overrides

// a replacement type for automata construction
@Parameterized(["T"])
@public @final type LSLOptional
    is java.util.Optional
    for Optional
{
    @private @static var EMPTY: Optional = null;

    // NOTE: value is stored within the automaton
}
