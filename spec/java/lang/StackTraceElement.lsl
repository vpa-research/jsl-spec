libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StackTraceElement.java";

// imports

import java/io/Serializable;


// primary semantic types

type StackTraceElement
    is java.lang.StackTraceElement
    for Serializable
{
}


// global aliases and type overrides

