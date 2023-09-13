//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Optional.java";

// imports

import java.common;


// primary semantic types

// original type for use in other places
@Parameterized(["T"])
@public @final type Optional
    is java.util.Optional
    for Object
{
}


// a replacement type for automata construction
@Parameterized(["T"])
@public @final type LSLOptional
    is java.util.Optional
    for Optional
{
    // NOTE: value is stored within the automaton
}
