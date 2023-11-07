//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/charset/Charset.java";

// imports

import java/lang/Comparable;


// primary semantic types

@abstract type Charset
    is java.nio.charset.Charset
    for Comparable
{
}


// global aliases and type overrides

@implements("java.lang.Comparable<Charset>")
@abstract type LSLCharset
    is java.nio.charset.Charset
    for Charset
{
}
