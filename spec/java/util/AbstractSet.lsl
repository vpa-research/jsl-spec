//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractSet.java";

// imports

import java/util/AbstractCollection;
import java/util/Set;


// primary semantic types

@Parameterized(["E"])
@abstract type AbstractSet
    is java.util.AbstractSet
    for AbstractCollection, Set
{
}


// global aliases and type overrides

