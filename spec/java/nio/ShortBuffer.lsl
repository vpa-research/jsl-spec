//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ShortBuffer.java";

// imports

import java/lang/Comparable;
import java/lang/Object;
import java/lang/String;
import java/nio/Buffer;


// local semantic types

@extends("java.nio.Buffer")
@implements("java.lang.Comparable")
@abstract type ShortBuffer
    is java.nio.ShortBuffer
    for Buffer
{
}


// global aliases and type overrides