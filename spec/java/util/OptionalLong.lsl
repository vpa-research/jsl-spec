//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionalLong.java";

// imports

import java/lang/_interfaces;


// primary semantic types

@public @final type OptionalLong
    is java.util.OptionalLong
    for Object
{
    // NOTE: value is stored within the automaton
}
