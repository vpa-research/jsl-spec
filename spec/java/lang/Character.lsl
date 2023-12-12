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

    @static fun *.reverseBytes(ch: char): char;
}


val MAX_CODE_POINT: int = 1114111;
val MIN_CODE_POINT: int = 0;
val MIN_LOW_SURROGATE: int = 56320;
val MIN_HIGH_SURROGATE: int = 55296;
val MIN_SUPPLEMENTARY_CODE_POINT: int = 65536;


// global aliases and type overrides

