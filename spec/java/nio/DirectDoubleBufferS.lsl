libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectDoubleBufferS.java";

// imports

import java/nio/DoubleBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.DoubleBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectDoubleBufferS
    is java.nio.DirectDoubleBufferS
    for DoubleBuffer, DirectBuffer
{
}


@GenerateMe
@extends("java.nio.DoubleBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectDoubleBufferS
    is java.nio.DirectDoubleBufferS
    for DirectDoubleBufferS
{
}