//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionalInt.java";

// imports

import java/lang/Object;


// primary semantic types

@final type OptionalInt
    is java.util.OptionalInt
    for Object
{
    @static fun *.empty(): Object; // #problem: self-reference

    @static fun *.of(x: int): Object; // #problem: self-reference

    fun *.isPresent(): boolean;

    fun *.isEmpty(): boolean;

    fun *.getAsInt(): int;

    fun *.orElse(other: int): int;
}


// global aliases and type overrides

// a replacement type for automata construction
@public @final type LSLOptionalInt
    is java.util.OptionalInt
    for OptionalInt
{
    @private @static var EMPTY: OptionalInt = null;

    // NOTE: value is stored within the automaton
}
