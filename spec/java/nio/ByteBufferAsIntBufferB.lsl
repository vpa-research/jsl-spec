libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsIntBufferB.java";

// imports

import java/nio/IntBuffer;


// local semantic types

@extends("java.nio.IntBuffer")
type ByteBufferAsIntBufferB
    is java.nio.ByteBufferAsIntBufferB
    for IntBuffer
{
}


@extends("java.nio.IntBuffer")
@public type LSLByteBufferAsIntBufferB
    is java.nio.ByteBufferAsIntBufferB
    for ByteBufferAsIntBufferB
{
}