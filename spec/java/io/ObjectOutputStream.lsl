libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/ObjectOutputStream.java";

// imports

import java/io/OutputStream;


// primary semantic types

type ObjectOutputStream
    is java.io.ObjectOutputStream
    for OutputStream
{
}


// global aliases and type overrides

