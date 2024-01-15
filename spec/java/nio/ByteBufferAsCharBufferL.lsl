libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsCharBufferL.java";

// imports

import java/nio/CharBuffer;


// local semantic types

@extends("java.nio.CharBuffer")
type ByteBufferAsCharBufferL
    is java.nio.ByteBufferAsCharBufferL
    for CharBuffer
{
}


@extends("java.nio.CharBuffer")
@public type LSLByteBufferAsCharBufferL
    is java.nio.ByteBufferAsCharBufferL
    for ByteBufferAsCharBufferL
{
}