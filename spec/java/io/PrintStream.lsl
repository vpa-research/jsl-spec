//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/PrintStream.java";

// imports

import java/io/Closeable;
import java/io/FilterOutputStream;
import java/lang/Appendable;


// primary semantic types

type PrintStream
    is java.io.PrintStream
    for FilterOutputStream, Appendable, Closeable
{
}


// global aliases and type overrides

