//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/Flushable.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type Flushable
    is java.io.Flushable
    for Object
{
    @throws(["java.io.IOException"])
    fun *.flush(): void;
}


// global aliases and type overrides

