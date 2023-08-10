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
    fun size(): int;

    fun isEmpty(): boolean;

    fun containsKey(key: Object): boolean;

    fun containsValue(value: Object): boolean;

    fun get(key: Object): Object;

    fun put(key: Object, value: Object): Object;

    fun remove(key: Object): Object;

    fun remove(key: Object, value: Object): boolean;

    fun clear(): void;
}

@Parameterized(["K", "V"])
type Map_Entry
    is java.util.Map.Entry
    for Object
{
    fun getKey(): Object;

    fun getValue(): Object;

    fun setValue(value: Object): Object;
}


@Parameterized(["E"])
type Collection
    is java.util.Collection
    for Iterable
{
    fun size(): int;

    fun isEmpty(): boolean;

    fun contains(o: Object): boolean;

    @ParameterizedResult(["E"])
    fun iterator(): Iterator;

    fun toArray(): array<Object>;

    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    fun toArray(@Parameterized(["T"]) a: array<Object>): array<Object>;

    /*
    @Parameterized(["T"])
    @ParameterizedResult(["T"])
    fun toArray(@Parameterized(["T[]"]) generator: IntFunction): array<Object>;
    */

    fun add(e: Object): boolean;

    fun remove(o: Object): boolean;

    // #problem
    //fun containsAll(@Parameterized(["?"]) c: Collection): boolean;

    // #problem
    //fun addAll(@Parameterized(["? extends E"]) c: Collection): boolean;

    // #problem
    //fun removeAll(@Parameterized(["?"]) c: Collection): boolean;

    //fun removeIf(@Parameterized(["? super E"]) filter: Predicate): boolean;

    // #problem
    //fun retainAll(@Parameterized(["?"]) c: Collection): boolean;

    fun clear(): void;
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
