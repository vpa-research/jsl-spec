libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionDouble.java";

// imports

import java/lang/Object;


// primary semantic types

@final type OptionalDouble
    is java.util.OptionalDouble
    for Object
{
    @static fun *.empty(): Object; // #problem: self-reference

    @static fun *.of(x: double): Object; // #problem: self-reference

    fun *.isPresent(): boolean;

    fun *.isEmpty(): boolean;

    fun *.getAsDouble(): double;

    fun *.orElse(other: double): double;
}


// global aliases and type overrides

// a replacement type for automata construction
@public @final type LSLOptionalDouble
    is java.util.OptionalDouble
    for OptionalDouble
{
    @private @static var EMPTY: OptionalDouble = null;

    // NOTE: value is stored within the automaton
}
