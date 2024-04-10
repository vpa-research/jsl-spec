libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/concurrent/atomic/AtomicLong.java";

// imports

import java/io/Serializable;
import java/lang/Number;


// primary semantic types

type AtomicLong
    is java.util.concurrent.atomic.AtomicLong
    for Number, Serializable
{
}


// global aliases and type overrides

@extends("java.lang.Number")
@implements("java.io.Serializable")
type LSLAtomicLong
    is java.util.concurrent.atomic.AtomicLong
    for AtomicLong
{
    @private @static val serialVersionUID: long = 1927816293512124184L;
}

