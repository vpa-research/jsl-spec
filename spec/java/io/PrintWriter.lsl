libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/PrintWriter.java";

// imports

import java/io/Writer;


// primary semantic types

type PrintWriter
    is java.io.PrintWriter
    for Writer
{
}


// global aliases and type overrides

