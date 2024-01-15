libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectFloatBufferS.java";

// imports

import java/nio/FloatBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.FloatBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectFloatBufferS
    is java.nio.DirectFloatBufferS
    for FloatBuffer, DirectBuffer
{
}


@extends("java.nio.FloatBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectFloatBufferS
    is java.nio.DirectFloatBufferS
    for DirectFloatBufferS
{
}
