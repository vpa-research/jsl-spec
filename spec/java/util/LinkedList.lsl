//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedList.java";

// imports

import java/io/Serializable;
import java/lang/Cloneable;
import java/util/AbstractSequentialList;
import java/util/Deque;
import java/util/List;


// local semantic types

@extends("java.util.AbstractSequentialList")
@implements("java.util.List")
@implements("java.util.Deque")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type LinkedList
    is java.util.LinkedList
    for AbstractSequentialList, List, Deque, Cloneable, Serializable
{
    @private @static val serialVersionUID: long = 876323262645176354L;
}

