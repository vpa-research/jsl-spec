//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Float.java";

// imports

import java/lang/Comparable;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("floatValue")
@final type Float
    is java.lang.Float
    for Comparable, Number, float, double
{
}


// global aliases and type overrides

