//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/io";

// imports

import java.common;
import java/lang/_interfaces;


// semantic types

type ObjectInputStream
    is java.io.ObjectInputStream
    for Object
{
}


type ObjectOutputStream
    is java.io.ObjectOutputStream
    for Object
{
}


type PrintStream
    is java.io.PrintStream
    for Object
{
}


type PrintWriter
    is java.io.PrintWriter
    for Object
{
}
