libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsShortBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/ShortBuffer;


// local semantic types

@extends("java.nio.ShortBuffer")
type ByteBufferAsShortBufferL
    is java.nio.ByteBufferAsShortBufferL
    for ShortBuffer
{
}

@extends("java.nio.ShortBuffer")
@public type LSLByteBufferAsShortBufferL
    is java.nio.ByteBufferAsShortBufferL
    for ByteBufferAsShortBufferL
{
}
