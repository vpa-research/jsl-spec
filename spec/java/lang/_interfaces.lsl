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
    fun charAt (index: int): char;

    // #problem: cyclic dependency
    fun chars (): any; // IntStream;

    fun codePointAt (index: int): int;

    fun codePointBefore (index: int): int;

    fun codePointCount (beginIndex: int, endIndex: int): int;

    // #problem: cyclic dependency
    fun codePoints (): any; // IntStream;

    fun compareTo (anotherString: string): int;

    fun compareToIgnoreCase (str: string): int;

    fun contains (s: CharSequence): boolean;

    fun contentEquals (cs: CharSequence): boolean;

    // #problem: cyclic dependency, too primitive method resolution
    //fun contentEquals (sb: StringBuffer): boolean;

    fun endsWith (suffix: string): boolean;

    fun equalsIgnoreCase (anotherString: string): boolean;

    fun getBytes (): array<byte>;

    // #problem: cyclic dependency, too primitive method resolution
    //fun getBytes (charset: Charset): array<byte>;

    @throws(["java.io.UnsupportedEncodingException"])
    fun getBytes (charsetName: string): array<byte>;

    fun getBytes (srcBegin: int, srcEnd: int, dst: array<byte>, dstBegin: int): void;

    // #problem: too primitive method resolution
    //fun getChars (srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void;

    fun indexOf (str: string): int;

    fun indexOf (str: string, fromIndex: int): int;

    fun indexOf (ch: int): int;

    fun indexOf (ch: int, fromIndex: int): int;

    fun isBlank (): boolean;

    fun isEmpty (): boolean;

    fun lastIndexOf (str: string): int;

    fun lastIndexOf (str: string, fromIndex: int): int;

    fun lastIndexOf (ch: int): int;

    fun lastIndexOf (ch: int, fromIndex: int): int;

    fun length (): int;

    // #problem: cyclic dependency
    fun lines (): any; // Stream;

    fun matches (regex: string): boolean;

    fun offsetByCodePoints (index: int, codePointOffset: int): int;

    fun regionMatches (ignoreCase: boolean, toffset: int, other: string, ooffset: int, len: int): boolean;

    fun regionMatches (toffset: int, other: string, ooffset: int, len: int): boolean;

    fun repeat (count: int): string;

    fun replace (_target: CharSequence, replacement: CharSequence): string;

    fun replace (oldChar: char, newChar: char): string;

    fun replaceAll (regex: string, replacement: string): string;

    fun replaceFirst (regex: string, replacement: string): string;

    fun split (regex: string): array<string>;

    fun split (regex: string, limit: int): array<string>;

    fun startsWith (prefix: string): boolean;

    fun startsWith (prefix: string, toffset: int): boolean;

    fun strip (): string;

    fun stripLeading (): string;

    fun stripTrailing (): string;

    fun subSequence (beginIndex: int, endIndex: int): CharSequence;

    fun substring (beginIndex: int): string;

    fun substring (beginIndex: int, endIndex: int): string;

    fun toCharArray (): array<char>;

    fun toLowerCase (): string;

    // #problem: cyclic dependency
    fun toLowerCase (locale: Object/* Locale */): string;

    fun toUpperCase (): string;

    // #problem: cyclic dependency
    fun toUpperCase (locale: Object/* Locale */): string;

    fun trim (): string;
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
