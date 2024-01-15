libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsDoubleBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/DoubleBuffer;


// local semantic types

@extends("java.nio.DoubleBuffer")
type ByteBufferAsDoubleBufferL
    is java.nio.ByteBufferAsDoubleBufferL
    for DoubleBuffer
{
}


@extends("java.nio.DoubleBuffer")
@public type LSLByteBufferAsDoubleBufferL
    is java.nio.ByteBufferAsDoubleBufferL
    for ByteBufferAsDoubleBufferL
{
}