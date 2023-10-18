libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedHashSet.java";

// imports

import java/io/Serializable;
import java/lang/Cloneable;
import java/util/AbstractSet;
import java/util/Iterator;
import java/util/Spliterator;
import java/util/Set;

// === CONSTANTS ===

val LINKEDHASHSET_VALUE: Object = 0;


// primary types

@extends("java.util.HashSet")
@implements("java.util.Set")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type LinkedHashSet
    is java.util.LinkedHashSet
    for AbstractSet, Set, Cloneable, Serializable
{
    @private @static val serialVersionUID: long = -2851667679971038690L;
}

@GenerateMe
@implements("java.util.Spliterator")
@public @final type LinkedHashSet_KeySpliterator
    is java.util.LinkedHashSet_KeySpliterator
    for Spliterator
{
}

@GenerateMe
@implements("java.util.Iterator")
@public @final type LinkedHashSet_KeyIterator
    is java.util.LinkedHashSet_KeyIterator
    for Iterator
{
}
