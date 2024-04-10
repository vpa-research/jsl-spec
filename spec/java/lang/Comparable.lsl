libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Comparable.java";

// imports

import java/lang/Object;


// primary semantic types

@Parameterized(["T"])
@interface type Comparable
    is java.lang.Comparable
    for Object
{
    fun *.compareTo(t: Object): int;
}


// global aliases and type overrides

