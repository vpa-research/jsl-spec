//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionalInt.java";

// imports

import java/lang/Object;


// primary semantic types

@public @final type OptionalInt
    is java.util.OptionalInt
    for Object
{
    // NOTE: value is stored within the automaton
}
