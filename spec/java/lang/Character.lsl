libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Character.java";

// imports

import java/io/Serializable;
import java/lang/CharSequence;
import java/lang/Class;
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

@implements("java.io.Serializable")
//@implements("java.lang.Comparable")
@public @final type LSLCharacter
    is java.lang.Character
    for Character
{
    @private @static val serialVersionUID: long = 3786198910865385080L;

    @public @static val BYTES: int = 2;
    @public @static val SIZE: int = 16;
    @public @static val TYPE: Class = action TYPE_OF("Character");

    @public @static val COMBINING_SPACING_MARK: byte = 8;
    @public @static val CONNECTOR_PUNCTUATION: byte = 23;
    @public @static val CONTROL: byte = 15;
    @public @static val CURRENCY_SYMBOL: byte = 26;
    @public @static val DASH_PUNCTUATION: byte = 20;
    @public @static val DECIMAL_DIGIT_NUMBER: byte = 9;
    @public @static val DIRECTIONALITY_ARABIC_NUMBER: byte = 6;
    @public @static val DIRECTIONALITY_BOUNDARY_NEUTRAL: byte = 9;
    @public @static val DIRECTIONALITY_COMMON_NUMBER_SEPARATOR: byte = 7;
    @public @static val DIRECTIONALITY_EUROPEAN_NUMBER: byte = 3;
    @public @static val DIRECTIONALITY_EUROPEAN_NUMBER_SEPARATOR: byte = 4;
    @public @static val DIRECTIONALITY_EUROPEAN_NUMBER_TERMINATOR: byte = 5;
    @public @static val DIRECTIONALITY_FIRST_STRONG_ISOLATE: byte = 21;
    @public @static val DIRECTIONALITY_LEFT_TO_RIGHT: byte = 0;
    @public @static val DIRECTIONALITY_LEFT_TO_RIGHT_EMBEDDING: byte = 14;
    @public @static val DIRECTIONALITY_LEFT_TO_RIGHT_ISOLATE: byte = 19;
    @public @static val DIRECTIONALITY_LEFT_TO_RIGHT_OVERRIDE: byte = 15;
    @public @static val DIRECTIONALITY_NONSPACING_MARK: byte = 8;
    @public @static val DIRECTIONALITY_OTHER_NEUTRALS: byte = 13;
    @public @static val DIRECTIONALITY_PARAGRAPH_SEPARATOR: byte = 10;
    @public @static val DIRECTIONALITY_POP_DIRECTIONAL_FORMAT: byte = 18;
    @public @static val DIRECTIONALITY_POP_DIRECTIONAL_ISOLATE: byte = 22;
    @public @static val DIRECTIONALITY_RIGHT_TO_LEFT: byte = 1;
    @public @static val DIRECTIONALITY_RIGHT_TO_LEFT_ARABIC: byte = 2;
    @public @static val DIRECTIONALITY_RIGHT_TO_LEFT_EMBEDDING: byte = 16;
    @public @static val DIRECTIONALITY_RIGHT_TO_LEFT_ISOLATE: byte = 20;
    @public @static val DIRECTIONALITY_RIGHT_TO_LEFT_OVERRIDE: byte = 17;
    @public @static val DIRECTIONALITY_SEGMENT_SEPARATOR: byte = 11;
    @public @static val DIRECTIONALITY_UNDEFINED: byte = -1;
    @public @static val DIRECTIONALITY_WHITESPACE: byte = 12;
    @public @static val ENCLOSING_MARK: byte = 7;
    @public @static val END_PUNCTUATION: byte = 22;
    @public @static val FINAL_QUOTE_PUNCTUATION: byte = 30;
    @public @static val FORMAT: byte = 16;
    @public @static val INITIAL_QUOTE_PUNCTUATION: byte = 29;
    @public @static val LETTER_NUMBER: byte = 10;
    @public @static val LINE_SEPARATOR: byte = 13;
    @public @static val LOWERCASE_LETTER: byte = 2;
    @public @static val MATH_SYMBOL: byte = 25;

    @public @static val MAX_HIGH_SURROGATE: char = 56319 as char;
    @public @static val MAX_LOW_SURROGATE: char = 57343 as char;
    @public @static val MAX_RADIX: int = 36;
    @public @static val MAX_SURROGATE: char = 57343;

    @public @static val MIN_CODE_POINT: int = 0;
    @public @static val MAX_CODE_POINT: int = 1114111;

    @public @static val MIN_VALUE: char = 0 as char;
    @public @static val MAX_VALUE: char = 65535 as char;

    @public @static val MIN_HIGH_SURROGATE: char = 55296 as char;
    @public @static val MIN_LOW_SURROGATE: char = 56320 as char;
    @public @static val MIN_RADIX: int = 2;
    @public @static val MIN_SUPPLEMENTARY_CODE_POINT: int = 65536;
    @public @static val MIN_SURROGATE: char = 55296 as char;
    @public @static val MODIFIER_LETTER: byte = 4;
    @public @static val MODIFIER_SYMBOL: byte = 27;
    @public @static val NON_SPACING_MARK: byte = 6;
    @public @static val OTHER_LETTER: byte = 5;
    @public @static val OTHER_NUMBER: byte = 11;
    @public @static val OTHER_PUNCTUATION: byte = 24;
    @public @static val OTHER_SYMBOL: byte = 28;
    @public @static val PARAGRAPH_SEPARATOR: byte = 14;
    @public @static val PRIVATE_USE: byte = 18;

    @public @static val SPACE_SEPARATOR: byte = 12;
    @public @static val START_PUNCTUATION: byte = 21;
    @public @static val SURROGATE: byte = 19;
    @public @static val TITLECASE_LETTER: byte = 3;
    @public @static val UNASSIGNED: byte = 0;
    @public @static val UPPERCASE_LETTER: byte = 1;


    // #problem: character literal parsing
    @private @static val CHAR_SN: char = 10 as char;  // '\n'
    @private @static val CHAR_ST: char =  9 as char;  // '\t'
    @private @static val CHAR_SF: char = 12 as char;  // '\f'
    @private @static val CHAR_SR: char = 13 as char;  // '\r'
}
