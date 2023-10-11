//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Double.java";

// imports

import java/lang/Comparable;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("doubleValue")
@final type Double
    is java.lang.Double
    for Comparable, Number, double
{
}

val DOUBLE_POSITIVE_INFINITY: double = 1.0 / 0.0;
val DOUBLE_NEGATIVE_INFINITY: double = -1.0 / 0.0;
val DOUBLE_NAN: double = 0.0 / 0.0;


// global aliases and type overrides

