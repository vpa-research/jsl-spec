//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Integer.java";

// imports

import java/lang/Comparable;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("intValue")
@final type Integer
    is java.lang.Integer
    for Comparable, Number, int
{
}


// global aliases and type overrides

@extends("java.lang.Number")
@implements("java.lang.Comparable<Integer>")
@public @final type LSLInteger
    is java.lang.Integer
    for Integer
{
}
