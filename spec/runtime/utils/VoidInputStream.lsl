//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/InputStream.java#L81";

// imports

import java/io/InputStream;


// primary semantic types

@GenerateMe
@extends("java.io.InputStream")
@public @final type VoidInputStream
    is java.io.InputStream$Void
    for InputStream
{
}
