libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsDoubleBufferB.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/DoubleBuffer;


// local semantic types

@extends("java.nio.DoubleBuffer")
type ByteBufferAsDoubleBufferB
    is java.nio.ByteBufferAsDoubleBufferB
    for DoubleBuffer
{
}


@extends("java.nio.DoubleBuffer")
@public type LSLByteBufferAsDoubleBufferB
    is java.nio.ByteBufferAsDoubleBufferB
    for ByteBufferAsDoubleBufferB
{
}