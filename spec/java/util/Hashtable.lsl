libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Hashtable.java";

// imports

import java/io/Serializable;
import java/lang/Cloneable;
import java/util/Dictionary;
import java/util/Map;


// local semantic types

@extends("java.util.Dictionary")
@implements("java.util.Map")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type Hashtable
    is java.util.Hashtable
    for Dictionary, Map, Cloneable, Serializable
{
    @private @static @final var serialVersionUID: long = 1421746759512286392L;
}