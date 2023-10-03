//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/lang";

// imports

import java.common;


// boxed built-in types

// WARNING: use OBJECT_HASH_CODE and OBJECT_EQUALS actions instead of calling these methods directly
type Object is java.lang.Object for Object {}

type Boolean is java.lang.Boolean for Object, bool {}

type Byte    is java.lang.Byte    for Object, int8,  unsigned8  {}
type Short   is java.lang.Short   for Object, int16, unsigned16 {}
type Integer is java.lang.Integer for Object, int32, unsigned32 {}
type Long    is java.lang.Long    for Object, int64, unsigned64 {}

type Float  is java.lang.Float  for Object, float32 {}
type Double is java.lang.Double for Object, float64 {}

type Class is java.lang.Class for Object {}


// string-related operations

type CharSequence
    is java.lang.CharSequence
    for Object
{
    fun length(): int;

    fun charAt(index: int): char;
}

type Character is java.lang.Character for Object, char {}

type String
    is java.lang.String
    for CharSequence, string
{
    fun compareTo(anotherString: string): int; // #problem: self-reference

    fun indexOf(anotherString: string, fromIndex: int): int; // #problem: self-reference

    fun toCharArray(): array<char>;
}


val MAX_CODE_POINT: int = 1114111;
val MIN_CODE_POINT: int = 0;
val MIN_LOW_SURROGATE: int = 56320;
val MIN_HIGH_SURROGATE: int = 55296;
val MIN_SUPPLEMENTARY_CODE_POINT: int = 65536;


// general interfaces

type Runnable
    is java.lang.Runnable
    for Object
{
    fun run(): void;
}


@implements("java.io.Serializable")
type Throwable
    is java.lang.Throwable
    for Object
{
}


@implements("java.io.Serializable")
type StackTraceElement
    is java.lang.StackTraceElement
    for Object
{
}


@Parameterized(["E"])
type Iterator
    is java.util.Iterator
    for Object
{
    fun hasNext(): boolean;

    fun next(): Object;

    fun remove(): void;
}


@Parameterized(["T"])
type Iterable
    is java.lang.Iterable
    for Object
{
    fun iterator(): Iterator;

    // #problem: cannot use Spliterator and Consumer here
    // fun spliterator(): Spliterator;
}


@Parameterized(["T"])
type Comparable
    is java.lang.Comparable
    for Object
{
    fun compareTo(o: Object): int;
}
