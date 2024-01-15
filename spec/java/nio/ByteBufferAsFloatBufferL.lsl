libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBufferAsFloatBufferL.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;
import java/nio/ByteOrder;
import java/nio/FloatBuffer;


// local semantic types

@extends("java.nio.FloatBuffer")
type ByteBufferAsFloatBufferL
    is java.nio.ByteBufferAsFloatBufferL
    for FloatBuffer
{
}


@extends("java.nio.FloatBuffer")
@public type LSLByteBufferAsFloatBufferL
    is java.nio.ByteBufferAsFloatBufferL
    for ByteBufferAsFloatBufferL
{
}