libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/AutoCloseable.java";

// imports

import java/lang/Object;


// primary semantic types

@interface type AutoCloseable
    is java.lang.AutoCloseable
    for Object
{
    @throws(["java.io.IOException"])
    fun *.close(): void;
}


// global aliases and type overrides

@public @interface type LSLAutoCloseable
    is java.lang.AutoCloseable
    for AutoCloseable
{
}
