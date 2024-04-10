libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractQueue.java";

// imports

import java/util/AbstractCollection;
import java/util/Queue;


// primary semantic types

@Parameterized(["E"])
@abstract type AbstractQueue
    is java.util.AbstractQueue
    for AbstractCollection, Queue
{
}


// global aliases and type overrides

