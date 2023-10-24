libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Properties.java";

// imports

import java/util/Hashtable;


// local semantic types

@extends("java.util.Hashtable")
@public type Properties
    is java.util.Properties
    for Hashtable
{
    @private @static @final var serialVersionUID: long = 4112578634029874840L;
}