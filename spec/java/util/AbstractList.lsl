libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractList.java";

// imports

import java/util/AbstractCollection;
import java/util/List;


// primary semantic types

@Parameterized(["E"])
@abstract type AbstractList
    is java.util.AbstractList
    for AbstractCollection, List
{
}


// global aliases and type overrides

