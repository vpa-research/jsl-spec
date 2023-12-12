//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicInteger.java";

// imports

import java/io/Serializable;
import java/lang/Number;


// primary semantic types

type AtomicInteger
    is java.util.concurrent.atomic.AtomicInteger
    for Number, Serializable
{
}


// global aliases and type overrides

@extends("java.lang.Number")
@implements("java.io.Serializable")
type LSLAtomicInteger
    is java.util.concurrent.atomic.AtomicInteger
    for AtomicInteger
{
    @private @static val serialVersionUID: long = 6214790243416807050L;
}
