///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashSet.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/io/_interfaces;
import java/util/_interfaces;
import java/util/function/_interfaces;
import java/util/HashMap;


// primary types

@extends("java.util.AbstractSet")
@implements("java.util.Set")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type HashSet
    is java.util.HashSet
    for Set
{
    //@static @final var serialVersionUID: long = -5024744406713321676;
}


@GenerateMe
// Problem: inner class extends
@extends("java.util.HashMap$HashMapSpliterator")
@implements("java.util.Spliterator")
@public @static @final type HashSet_KeySpliterator
    is java.util.HashSet_KeySpliterator
    for Spliterator
{
}


@GenerateMe
@implements("java.util.Iterator")
@public @final type HashSet_KeyIterator
    is java.util.HashSet_KeyIterator
    for Iterator
{
}