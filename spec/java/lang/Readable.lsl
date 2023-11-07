//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Readable.java";

// imports

import java/lang/Object;
import java/nio/Buffer;


// primary semantic types

@interface type Readable
    is java.lang.Readable
    for Object
{
    @throws(["java.io.IOException"])
    fun *.read(cb: Buffer): int;  // #problem: cyclic dependency
}


// global aliases and type overrides
