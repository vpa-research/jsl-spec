//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Character.java";

// imports

import java/io/Serializable;
import java/lang/CharSequence;
import java/lang/Comparable;


// primary semantic types

@FunctionalInterface("charValue")
@final type Character
    is java.lang.Character
    for Comparable, Serializable
{
    // WARNING: use 'charValue' to get primitive value

    fun *.charValue(): char;

    @static fun *.offsetByCodePoints(seq: CharSequence, index: int, codePointOffset: int): int;

    @static fun *.offsetByCodePoints(a: array<char>, start: int, count: int, index: int, codePointOffset: int): int;

    @static fun *.isBmpCodePoint(codePoint: int): boolean;

    @static fun *.isValidCodePoint(codePoint: int): boolean;

    @static fun *.isSurrogate(ch: char): boolean;

    @static fun *.isLowSurrogate(ch: char): boolean;

    @static fun *.isHighSurrogate(ch: char): boolean;

    @static fun *.lowSurrogate(codePoint: int): char;

    @static fun *.highSurrogate(codePoint: int): char;

    @static fun *.codePointAt(a: array<char>, index: int, limit: int): int;

    @static fun *.codePointBefore(a: array<char>, index: int, limit: int): int;

    @static fun *.codePointCount(a: array<char>, index: int, limit: int): int;
}


val MAX_CODE_POINT: int = 1114111;
val MIN_CODE_POINT: int = 0;
val MIN_LOW_SURROGATE: int = 56320;
val MIN_HIGH_SURROGATE: int = 55296;
val MIN_SUPPLEMENTARY_CODE_POINT: int = 65536;


// global aliases and type overrides

