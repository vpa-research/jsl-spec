libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Deque.java";

// imports

import java/util/Queue;


// primary semantic types

@Parameterized(["E"])
@interface type Deque
    is java.util.Deque
    for Queue
{
}


// global aliases and type overrides

