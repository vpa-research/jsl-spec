//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/sun/nio/ch/DirectBuffer.java";

// imports

import java/lang/Object;
import jdk/internal/ref/Cleaner;


// primary semantic types

@public @interface type DirectBuffer
    is sun.nio.ch.DirectBuffer
    for Object
{
    fun *.address(): long;

    fun *.attachment(): Object;

    fun *.cleaner(): Cleaner;
}


// global aliases and type overrides

