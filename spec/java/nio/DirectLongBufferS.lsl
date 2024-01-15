libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectLongBufferS.java";

// imports

import java/nio/LongBuffer;
import sun/nio/ch/DirectBuffer;

// local semantic types

@extends("java.nio.LongBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectLongBufferS
    is java.nio.DirectLongBufferS
    for LongBuffer, DirectBuffer
{
}


@GenerateMe
@extends("java.nio.LongBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectLongBufferS
    is java.nio.DirectLongBufferS
    for DirectLongBufferS
{
}
