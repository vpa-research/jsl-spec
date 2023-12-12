//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Short.java";

// imports

import java/lang/Comparable;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("shortValue")
@final type Short
    is java.lang.Short
    for Comparable, Number
{
    // WARNING: use 'shortValue' to get primitive value

    @static fun *.reverseBytes(i: short): short;
}


// global aliases and type overrides

