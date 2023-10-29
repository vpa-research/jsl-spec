//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/Console.java";

// imports

import java/io/Flushable;


// primary semantic types

@final type Console
    is java.io.Console
    for Flushable
{
}

// see java.io.Console#istty
val CONSOLE_ISTTY: boolean = action SYMBOLIC("boolean");


// global aliases and type overrides

