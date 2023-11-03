//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicReference.java";

// imports

import java/io/Serializable;


// primary semantic types

type AtomicReference
    is java.util.concurrent.atomic.AtomicReference
    for Serializable
{
}


// global aliases and type overrides

@implements("java.io.Serializable")
type LSLAtomicReference
    is java.util.concurrent.atomic.AtomicReference
    for AtomicReference
{
    @private @static @final var serialVersionUID: long = -1848883965231344442L;
}

