///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java";

// imports

import java/io/Serializable;
import java/lang/Cloneable;
import java/util/AbstractMap;
import java/util/Map;
import java/util/AbstractCollection;
import java/util/Iterator;
import java/util/Spliterator;


// primary semantic types

@extends("java.util.AbstractMap")
@implements("java.util.Map")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type HashMap
    is java.util.HashMap
    for AbstractMap, Map, Cloneable, Serializable
{
    @private @static val serialVersionUID: long = 362498820763181265L;
}


// global aliases and type overrides

@GenerateMe
@extends("java.util.AbstractCollection")
@public type HashMapValues
    is java.util.HashMapValues
    for AbstractCollection
{
}


@GenerateMe
@implements("java.util.Iterator")
@public type HashMapValueIterator
    is java.util.HashMapValueIterator
    for Iterator
{
}


@GenerateMe
@implements("java.util.Spliterator")
@public @final type HashMapValueSpliterator
    is java.util.HashMapValueSpliterator
    for Spliterator
{
}


@GenerateMe
@extends("java.util.AbstractSet")
@public @final type HashMap_KeySet
    is java.util.HashMap_KeySet
    for AbstractMap
{
}


@GenerateMe
@implements("java.util.Iterator")
@public @final type HashMapKeyIterator
    is java.util.HashMapKeyIterator
    for Iterator
{
}
