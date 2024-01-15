libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsLongBufferL.java";

// imports
import java/nio/LongBuffer;


// local semantic types

@extends("java.nio.LongBuffer")
type ByteBufferAsLongBufferL
    is java.nio.ByteBufferAsLongBufferL
    for LongBuffer
{
}


@extends("java.nio.LongBuffer")
@public type LSLByteBufferAsLongBufferL
    is java.nio.ByteBufferAsLongBufferL
    for ByteBufferAsLongBufferL
{
}