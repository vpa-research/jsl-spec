//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Comparator.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type Comparator
    is java.util.Comparator
    for Object
{
    fun *.compare(o1: Object, o2: Object): int;
}


// global aliases and type overrides

