///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java";

// imports
import java.common;


// local semantic types

@extends("java.util.AbstractMap")
@implements("java.util.Map")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type HashMap
    is java.util.HashMap
    for Map
{
    // #problem: should be 362498820763181265 instead
    @private @static val serialVersionUID: long = 2;
}

