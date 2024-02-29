libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/Closeable.java";

// imports

import java/lang/AutoCloseable;


// primary semantic types

@interface type Closeable
    is java.io.Closeable
    for AutoCloseable
{
    @throws(["java.io.IOException"])
    fun *.close(): void;
}


// global aliases and type overrides

