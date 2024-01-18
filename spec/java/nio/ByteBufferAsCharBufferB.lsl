libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsCharBufferB.java";

// imports

import java/nio/CharBuffer;


// local semantic types

@extends("java.nio.CharBuffer")
type ByteBufferAsCharBufferB
    is java.nio.ByteBufferAsCharBufferB
    for CharBuffer
{
}


@GenerateMe
@extends("java.nio.CharBuffer")
@public type LSLByteBufferAsCharBufferB
    is java.nio.ByteBufferAsCharBufferB
    for ByteBufferAsCharBufferB
{
}