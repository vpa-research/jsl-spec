libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/MappedByteBuffer.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/nio/ByteBuffer;


// local semantic types

@extends("java.nio.ByteBuffer")
@public @abstract type MappedByteBuffer
    is java.nio.MappedByteBuffer
    for ByteBuffer
{
}


// global aliases and type overrides
