libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectCharBufferS.java";

// imports

import java/nio/CharBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types

@extends("java.nio.CharBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectCharBufferS
    is java.nio.DirectCharBufferS
    for CharBuffer, DirectBuffer
{
}


@extends("java.nio.CharBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectCharBufferS
    is java.nio.DirectCharBufferS
    for DirectCharBufferS
{
}