libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectFloatBufferU.java";

// imports

import java/nio/FloatBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.FloatBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectFloatBufferU
    is java.nio.DirectFloatBufferU
    for FloatBuffer, DirectBuffer
{
}


@GenerateMe
@extends("java.nio.FloatBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectFloatBufferU
    is java.nio.DirectFloatBufferU
    for DirectFloatBufferU
{
}
