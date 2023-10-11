///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashSet.java";

// imports

import java/io/Serializable;
import java/lang/Cloneable;
import java/util/AbstractSet;
import java/util/Iterator;
import java/util/Spliterator;
import java/util/Set;


// primary types

@extends("java.util.AbstractSet")
@implements("java.util.Set")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type HashSet
    is java.util.HashSet
    for AbstractSet, Set, Cloneable, Serializable
{
    @private @static val serialVersionUID: long = -5024744406713321676L;
}


@GenerateMe
@implements("java.util.Spliterator")
@public @final type HashSet_KeySpliterator
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