libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/FilterOutputStream.java";

// imports

import java/io/OutputStream;


// primary semantic types

type FilterOutputStream
    is java.io.FilterOutputStream
    for OutputStream
{
}


// global aliases and type overrides

