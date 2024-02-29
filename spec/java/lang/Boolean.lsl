libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Boolean.java";

// imports

import java/io/Serializable;
import java/lang/Comparable;


// primary semantic types

@FunctionalInterface("booleanValue")
@final type Boolean
    is java.lang.Boolean
    for Comparable, Serializable, boolean
{
    fun *.booleanValue(): boolean;
}


// global aliases and type overrides

