libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsFloatBufferB.java";

// imports

import java/nio/FloatBuffer;


// local semantic types

@extends("java.nio.FloatBuffer")
type ByteBufferAsFloatBufferB
    is java.nio.ByteBufferAsFloatBufferB
    for FloatBuffer
{
}


@extends("java.nio.FloatBuffer")
@public type LSLByteBufferAsFloatBufferB
    is java.nio.ByteBufferAsFloatBufferB
    for ByteBufferAsFloatBufferB
{
}
