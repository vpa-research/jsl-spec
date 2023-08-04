//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/util";

// imports

import java.common;
import java/lang/_interfaces;


// semantic types

@Parameterized(["T"])
type Comparator
    is java.util.Comparator
    for Object
{
    fun compare(o1: Object, o2: Object): int;
}


@Parameterized(["E"])
type Iterator
    is java.util.Iterator
    for Object
{
    fun hasNext(): boolean;

    fun next(): Object;
}


@Parameterized(["T"])
type Spliterator
    is java.util.Spliterator
    for Object
{
}


@Parameterized(["K", "V"])
type Map
    is java.util.Map
    for Object
{
}

@Parameterized(["K", "V"])
type MapEntry
    is java.util.Map.Entry
    for Object
{
}


@Parameterized(["E"])
type Collection
    is java.util.Collection
    for Iterable
{
    fun size(): int;
}


@Parameterized(["E"])
type List
    is java.util.List
    for Collection
{
}


@Parameterized(["E"])
type Set
    is java.util.Set
    for Collection
{
}


@Parameterized(["E"])
type Queue
    is java.util.Queue
    for Collection
{
}


@Parameterized(["E"])
type Deque
    is java.util.Deque
    for Queue
{
}


@Parameterized(["E"])
type ListIterator
    is java.util.ListIterator
    for Iterator
{
}
