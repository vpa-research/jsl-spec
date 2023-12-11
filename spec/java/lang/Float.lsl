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

val FLOAT_POSITIVE_INFINITY: float = 1.0f / 0.0f;
val FLOAT_NEGATIVE_INFINITY: float = -1.0f / 0.0f;
val FLOAT_NAN: float = 0.0f / 0.0f;


// global aliases and type overrides

