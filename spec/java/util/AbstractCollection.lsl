//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractCollection.java";

// imports

import java/util/Collection;


// primary semantic types

@Parameterized(["E"])
@abstract type AbstractCollection
    is java.util.AbstractCollection
    for Collection
{
}


// global aliases and type overrides

