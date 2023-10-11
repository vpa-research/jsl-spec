//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/ref/Reference.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@abstract type Reference
    is java.lang.ref.Reference
    for Object
{
    fun *.get(): Object;

    fun *.clear(): void;

    fun *.isEnqueued(): boolean;

    fun *.enqueue(): boolean;
}


// global aliases and type overrides

