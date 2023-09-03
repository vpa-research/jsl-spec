//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Optional.java";

// imports

import java.common;


// primary semantic types

@Parameterized(["T"])
@public @final type Optional
    is java.util.Optional
    for Object
{
    // NOTE: value is stored within the automaton
}
