libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/String.java";

// imports

import java/io/Serializable;
import java/lang/Comparable;
import java/lang/CharSequence;
import java/lang/Object;


// primary semantic types

@final type String
    is java.lang.String
    for Comparable, CharSequence, string
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

    // #problem: cyclic dependency
    //fun contentEquals (sb: StringBuffer): boolean;

    fun endsWith (suffix: string): boolean;

    fun equalsIgnoreCase (anotherString: string): boolean;

    fun getBytes (): array<byte>;

    // #problem: cyclic dependency, too primitive method resolution
    //fun getBytes (charset: Charset): array<byte>;

    @throws(["java.io.UnsupportedEncodingException"])
    fun getBytes (charsetName: string): array<byte>;

    fun getBytes (srcBegin: int, srcEnd: int, dst: array<byte>, dstBegin: int): void;

    fun getChars (srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void;

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


// global aliases and type overrides

@implements("java.io.Serializable")
//@implements("java.lang.Comparable")
//@implements("java.lang.CharSequence")
type LSLString
    is java.lang.String
    for String
{
}
