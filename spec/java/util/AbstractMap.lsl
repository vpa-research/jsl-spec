libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractMap.java";

// imports

import java/io/Serializable;
import java/util/Map;


// primary semantic types

@Parameterized(["E"])
@abstract type AbstractMap
    is java.util.AbstractMap
    for Map
{
}

@GenerateMe // #problem: unable to make inner classes by translator
@implements("java.io.Serializable")
@implements("java.util.Map.Entry")
@public type AbstractMap_SimpleEntry
    is java.util.AbstractMap_SimpleEntry
    for Map_Entry, Serializable
{
    @private @static val serialVersionUID: long = -8499721149061103585L;
}


// global aliases and type overrides

