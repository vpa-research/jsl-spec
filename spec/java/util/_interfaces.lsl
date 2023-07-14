//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

import java.common;
import java/lang/_interfaces;


@Parameterized(["T"]) // #problem
type Comparator
    is java.util.Comparator
    for Object
{
    fun compare(o1: Object, o2: Object): int;
}


@Parameterized(["E"]) // #problem
type Iterator
    is java.util.Iterator
    for Object
{
}


@Parameterized(["T"]) // #problem
type Spliterator
    is java.util.Spliterator
    for Object
{
}


@Parameterized(["K", "V"]) // #problem
type Map
    is java.util.Map
    for Object // #question: add map here?
{
}

@Parameterized(["K", "V"]) // #problem
type MapEntry
    is java.util.Map.Entry
    for Object
{
}


@Parameterized(["E"]) // #problem
type Collection
    is java.util.Collection
    for Iterable, Object
{
}


@Parameterized(["E"]) // #problem
type List
    is java.util.List
    for Collection
{
}


@Parameterized(["E"]) // #problem
type Set
    is java.util.Set
    for Collection
{
}


@Parameterized(["E"]) // #problem
type Queue
    is java.util.Queue
    for Collection
{
}


@Parameterized(["E"]) // #problem
type Deque
    is java.util.Deque
    for Queue
{
}


@Parameterized(["E"]) // #problem
type ListIterator
    is java.util.ListIterator
    for Iterator
{
}
