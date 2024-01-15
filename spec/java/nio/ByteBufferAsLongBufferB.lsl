libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsLongBufferB.java";

// imports

import java/nio/LongBuffer;


// local semantic types

@extends("java.nio.LongBuffer")
type ByteBufferAsLongBufferB
    is java.nio.ByteBufferAsLongBufferB
    for LongBuffer
{
}


@GenerateMe
@extends("java.nio.LongBuffer")
@public type LSLByteBufferAsLongBufferB
    is java.nio.ByteBufferAsLongBufferB
    for ByteBufferAsLongBufferB
{
}