libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/SortedMap.java";

// imports

import java/util/Map;


// primary semantic types

@interface type SortedMap
    is java.util.SortedMap
    for Map
{
}


// global aliases and type overrides

