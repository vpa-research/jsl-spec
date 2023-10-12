//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Hashtable.java";

// imports

import java/util/Map;


// primary semantic types

type Hashtable
    is java.util.Hashtable
    for Map // #todo: add Dictionary and other things
{
}


// global aliases and type overrides

