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


// Iterator is declared in 'java/lang/_interfaces.lsl'


@Parameterized(["T"])
type Spliterator
    is java.util.Spliterator
    for Object
{
    fun tryAdvance(@Parameterized(["? super T"]) _action: Consumer): boolean;

    fun forEachRemaining(@Parameterized(["? super T"]) _action: Consumer): void;

    fun getExactSizeIfKnown(): long;

    fun characteristics(): int;
}

val SPLITERATOR_DISTINCT:   int = 1;
val SPLITERATOR_SORTED:     int = 4;
val SPLITERATOR_ORDERED:    int = 16;
val SPLITERATOR_SIZED:      int = 64;
val SPLITERATOR_NONNULL:    int = 256;
val SPLITERATOR_IMMUTABLE:  int = 1024;
val SPLITERATOR_CONCURRENT: int = 4096;
val SPLITERATOR_SUBSIZED:   int = 16384;


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

    // #problem: cannot use Stream here
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
    fun add(e: Object): void;

    fun hasPrevious(): boolean;

    fun nextIndex(): int;

    fun previous(): Object;

    fun previousIndex(): int;

    fun set(e: Object): void;
}
