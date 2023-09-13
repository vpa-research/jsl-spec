//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedList.java";

// imports

import java.common;
import java/io/_interfaces;
import java/lang/_interfaces;
import java/util/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// local semantic types

@extends("java.util.AbstractSequentialList")
@implements("java.util.List")
@implements("java.util.Deque")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type LinkedList
    is java.util.LinkedList
    for List, Deque
{
    @private @static val serialVersionUID: long = 876323262645176354L;
}

