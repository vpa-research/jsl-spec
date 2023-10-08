//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/OutputStream.java#L67";

// imports

import java/io/_interfaces;


// primary semantic types

@GenerateMe
@extends("java.io.OutputStream")
@public @final type VoidOutputStream
    is java.io.OutputStream$1
    for OutputStream
{
}
