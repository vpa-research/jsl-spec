//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Properties.java";

// imports

import java/util/Hashtable;


// primary semantic types

type Properties
    is java.util.Properties
    for Hashtable
{
}


// global aliases and type overrides

