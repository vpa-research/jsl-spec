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


// primary types

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


// new/introduced types

@GenerateMe
@implements("java.util.ListIterator")
@public @final type LinkedList_ListIterator
    is java.util.LinkedList_ListItr  // NOTE: do not use inner classes
    for ListIterator
{
}


@GenerateMe
@implements("java.util.Spliterator")
@public @final type LinkedList_Spliterator
    is java.util.LinkedList_Spliterator  // NOTE: do not use inner classes
    for Spliterator
{
}


@GenerateMe
@extends("java.util.AbstractList")
@implements("java.util.List")
@implements("java.util.RandomAccess")
@public @final type LinkedList_SubList
    is java.util.LinkedList_SubList  // NOTE: do not use inner classes
    for List
{
}


@GenerateMe
@implements("java.util.Spliterator")
@public @final type LinkedList_SubList_Spliterator
    // NOTE: using a '$' sign here to hint on a potential solution to inability to overwrite private constructors
    is java.util.LinkedList_SubList$Spliterator
    for Spliterator
{
}


@GenerateMe
@implements("java.util.ListIterator")
@public @final type LinkedList_SubList_ListIterator
    is java.util.LinkedList_SubList$ListIterator  // NOTE: do not use inner classes
    for ListIterator
{
}
