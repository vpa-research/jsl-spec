//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Runnable.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type Runnable
    is java.lang.Runnable
    for Object
{
    fun *.run(): void;
}


// global aliases and type overrides

