//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/io/_interfaces;
import java/util/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// primary types

@extends("java.util.AbstractList")
@implements("java.util.List")
@implements("java.util.RandomAccess")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type ArrayList
    is java.util.ArrayList
    for List
{
    @private @static val serialVersionUID: long = 8683452581122892189L;
}


// new/introduced types

@GenerateMe
@implements("java.util.ListIterator")
@public @final type ArrayList_ListIterator
    is java.util.ArrayList_ListItr  // NOTE: do not use inner classes
    for ListIterator
{
}


@GenerateMe
@implements("java.util.Spliterator")
@public @final type ArrayList_Spliterator
    is java.util.ArrayList_Spliterator  // NOTE: do not use inner classes
    for Spliterator
{
}


@GenerateMe
@extends("java.util.AbstractList")
@implements("java.util.List")
@implements("java.util.RandomAccess")
@public @final type ArrayList_SubList
    is java.util.ArrayList_SubList  // NOTE: do not use inner classes
    for List
{
}


@GenerateMe
@implements("java.util.Spliterator")
@public @final type ArrayList_SubList_Spliterator
    // NOTE: using a '$' sign here to hint on a potential solution to inability to overwrite private constructors
    is java.util.ArrayList_SubList$Spliterator
    for Spliterator
{
}
