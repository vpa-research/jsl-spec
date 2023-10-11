//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/ObjectInputStream.java";

// imports

import java/io/InputStream;


// primary semantic types

type ObjectInputStream
    is java.io.ObjectInputStream
    for InputStream
{
}


// global aliases and type overrides

