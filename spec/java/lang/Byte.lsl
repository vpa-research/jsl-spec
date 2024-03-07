libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Byte.java";

// imports

import java/lang/Comparable;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("byteValue")
@final type Byte
    is java.lang.Byte
    for Comparable, Number
{
    // WARNING: use 'byteValue' to get primitive value
}


// global aliases and type overrides

