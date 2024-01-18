libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectIntBufferU.java";

// imports

import java/nio/IntBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.IntBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectIntBufferU
    is java.nio.DirectIntBufferU
    for DirectBuffer, IntBuffer
{
}


@GenerateMe
@extends("java.nio.IntBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectIntBufferU
    is java.nio.DirectIntBufferU
    for DirectIntBufferU
{
}