libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectByteBuffer.java";

// imports
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.MappedByteBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public @private type DirectByteBuffer
    is java.nio.DirectByteBuffer
    for DirectBuffer
{
}

// a replacement type for automata construction
@extends("java.nio.MappedByteBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectByteBuffer
    is java.nio.DirectByteBuffer
    for DirectByteBuffer
{
}