libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicBoolean.java";

// imports

import java/io/Serializable;


// primary semantic types

type AtomicBoolean
    is java.util.concurrent.atomic.AtomicBoolean
    for Serializable
{
}


// global aliases and type overrides

@implements("java.io.Serializable")
type LSLAtomicBoolean
    is java.util.concurrent.atomic.AtomicBoolean
    for AtomicBoolean
{
    @private @static val serialVersionUID: long = 4654671469794556979L;

    @private @static val FALSE: int = 0;
    @private @static val TRUE: int = 1;
}

