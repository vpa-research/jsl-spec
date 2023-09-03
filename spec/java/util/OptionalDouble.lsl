//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionDouble.java";

// imports

import java.common;


// primary semantic types

@public @final type OptionalDouble
    is java.util.OptionalDouble
    for Object
{
    // NOTE: value is stored within the automaton
}
