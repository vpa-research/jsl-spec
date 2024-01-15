libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectDoubleBufferU.java";

// imports

import java/nio/DoubleBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.DoubleBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectDoubleBufferU
    is java.nio.DirectDoubleBufferU
    for DoubleBuffer, DirectBuffer
{
}


@GenerateMe
@extends("java.nio.DoubleBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectDoubleBufferU
    is java.nio.DirectDoubleBufferU
    for DirectDoubleBufferU
{
}

