libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectIntBufferS.java";

// imports

import java/nio/IntBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.IntBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectIntBufferS
    is java.nio.DirectIntBufferS
    for IntBuffer, DirectBuffer
{
}


@GenerateMe
@extends("java.nio.IntBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectIntBufferS
    is java.nio.DirectIntBufferS
    for DirectIntBufferS
{
}
