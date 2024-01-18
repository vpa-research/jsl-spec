libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsIntBufferL.java";

// imports

import java/nio/IntBuffer;


// local semantic types

@extends("java.nio.IntBuffer")
type ByteBufferAsIntBufferL
    is java.nio.ByteBufferAsIntBufferL
    for IntBuffer
{
}


@GenerateMe
@extends("java.nio.IntBuffer")
@public type LSLByteBufferAsIntBufferL
    is java.nio.ByteBufferAsIntBufferL
    for ByteBufferAsIntBufferL
{
}