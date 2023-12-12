//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Long.java";

// imports

import java/lang/Comparable;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("longValue")
@final type Long
    is java.lang.Long
    for Comparable, Number
{
    // WARNING: use 'longValue' to get primitive value
}


// global aliases and type overrides

