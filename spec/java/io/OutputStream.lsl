//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/OutputStream.java";

// imports

import java/io/Closeable;
import java/io/Flushable;


// primary semantic types

type OutputStream
    is java.io.OutputStream
    for Closeable, Flushable
{
    @throws(["java.io.IOException"])
    fun *.write(b: array<byte>): void;

    @throws(["java.io.IOException"])
    fun *.write(b: array<byte>, off: int, len: int): void;

    @throws(["java.io.IOException"])
    fun *.write(b: int): void;
}


// global aliases and type overrides

