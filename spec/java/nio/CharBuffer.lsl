//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/CharBuffer.java";

// imports

import java/lang/Appendable;
import java/lang/CharSequence;
import java/lang/Comparable;
import java/lang/Readable;
import java/nio/Buffer;


// primary semantic types

@abstract type CharBuffer
    is java.nio.CharBuffer
    for Buffer, Comparable, Appendable, CharSequence, Readable
{
}


// global aliases and type overrides
