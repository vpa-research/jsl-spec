//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionalLong.java";

// imports

import java/lang/Object;


// primary semantic types

@public @final type OptionalLong
    is java.util.OptionalLong
    for Object
{
    @static fun *.empty(): Object; // #problem: self-reference

    @static fun *.of(x: long): Object; // #problem: self-reference

    fun *.isPresent(): boolean;

    fun *.isEmpty(): boolean;

    fun *.getAsLong(): long;

    fun *.orElse(other: long): long;
}


// global aliases and type overrides

// a replacement type for automata construction
@public @final type LSLOptionalLong
    is java.util.OptionalLong
    for OptionalLong
{
    // NOTE: value is stored within the automaton
}
