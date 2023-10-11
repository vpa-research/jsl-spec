//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractMap.java";

// imports

import java/util/Map;


// primary semantic types

@Parameterized(["E"])
@abstract type AbstractMap
    is java.util.AbstractMap
    for Map
{
}


// global aliases and type overrides

