//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractSequentialList.java";

// imports

import java/util/AbstractList;


// primary semantic types

@Parameterized(["E"])
@abstract type AbstractSequentialList
    is java.util.AbstractSequentialList
    for AbstractList
{
}


// global aliases and type overrides

