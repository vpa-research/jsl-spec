libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectShortBufferU.java";

// imports

import java/nio/ShortBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.ShortBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectShortBufferU
    is java.nio.DirectShortBufferU
    for ShortBuffer, DirectBuffer
{
}


@GenerateMe
@extends("java.nio.ShortBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectShortBufferU
    is java.nio.DirectShortBufferU
    for DirectShortBufferU
{
}
