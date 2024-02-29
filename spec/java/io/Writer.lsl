libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/Writer.java";

// imports

import java/io/Closeable;
import java/io/Flushable;
import java/lang/Appendable;


// primary semantic types

type Writer
    is java.io.Writer
    for Appendable, Closeable, Flushable
{
}


// global aliases and type overrides

