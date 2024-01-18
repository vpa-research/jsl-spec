libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DoubleBuffer.java";

// imports

import java/lang/Comparable;
import java/lang/Object;
import java/lang/String;
import java/nio/Buffer;


// local semantic types

@extends("java.nio.Buffer")
@implements("java.lang.Comparable")
@abstract type DoubleBuffer
    is java.nio.DoubleBuffer
    for Buffer, Comparable
{
}


// global aliases and type overrides
