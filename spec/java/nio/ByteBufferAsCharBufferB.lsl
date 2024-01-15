libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsCharBufferB.java";

// imports

import java/lang/CharSequence;
import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/CharBuffer;
import java/util/stream/IntStream;


// local semantic types

@extends("java.nio.CharBuffer")
type ByteBufferAsCharBufferB
    is java.nio.ByteBufferAsCharBufferB
    for CharBuffer
{
}


@extends("java.nio.CharBuffer")
@public type LSLByteBufferAsCharBufferB
    is java.nio.ByteBufferAsCharBufferB
    for ByteBufferAsCharBufferB
{
}