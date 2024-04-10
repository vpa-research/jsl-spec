libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteBuffer.java";

// imports

import java/lang/Object;
import java/nio/Buffer;


// primary semantic types

@abstract type ByteBuffer
    is java.nio.ByteBuffer
    for Buffer
{
     fun *.get(dst: array<byte>, offset: int, length: int): any; //ByteBuffer
}


// global aliases and type overrides

