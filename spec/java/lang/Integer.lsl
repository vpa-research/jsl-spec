libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Integer.java";

// imports

import java.common;
import java/lang/_interfaces;


// public semantic types

//@extends("java.lang.Number")
//@implements("java.lang.Comparable<Integer>")
@public @final type LSLInteger
    is java.lang.Integer
    for Integer
{
}


// automata

automaton IntegerAutomaton
(
    @private val value: int // WARNING: do not rename!
)
: LSLInteger
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // constructors
        Integer (LSLInteger, String),
        Integer (LSLInteger, int),

        // static operations
        bitCount,
        compare,
        compareUnsigned,
        decode,
        divideUnsigned,
        getInteger (String),
        getInteger (String, Integer),
        getInteger (String, int),
        hashCode (int),
        highestOneBit,
        lowestOneBit,
        max,
        min,
        numberOfLeadingZeros,
        numberOfTrailingZeros,
        parseInt (CharSequence, int, int, int),
        parseInt (String),
        parseInt (String, int),
        parseUnsignedInt (CharSequence, int, int, int),
        parseUnsignedInt (String),
        parseUnsignedInt (String, int),
        remainderUnsigned,
        reverse,
        reverseBytes,
        rotateLeft,
        rotateRight,
        signum,
        sum,
        toBinaryString,
        toHexString,
        toOctalString,
        toString (int),
        toString (int, int),
        toUnsignedLong,
        toUnsignedString (int),
        toUnsignedString (int, int),
        valueOf (String),
        valueOf (String, int),
        valueOf (int),

        // instance methods
        byteValue,
        compareTo,
        doubleValue,
        equals,
        floatValue,
        hashCode (LSLInteger),
        intValue,
        longValue,
        shortValue,
        toString (LSLInteger),
    ];

    // internal variables

    // utilities

    // constructors

    @throws(["java.lang.NumberFormatException"])
    @Phantom constructor *.Integer (@target self: LSLInteger, s: String)
    {
        // NOTE: using the original method
    }


    @Phantom constructor *.Integer (@target self: LSLInteger, value: int)
    {
        // NOTE: using the original method
    }


    // static methods

    @Phantom @static fun *.bitCount (i: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.compare (x: int, y: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.compareUnsigned (x: int, y: int): int
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.decode (nm: String): LSLInteger
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.divideUnsigned (dividend: int, divisor: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getInteger (nm: String): LSLInteger
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getInteger (nm: String, _val: Integer): LSLInteger
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getInteger (nm: String, _val: int): LSLInteger
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.hashCode (value: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.highestOneBit (i: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.lowestOneBit (i: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.max (a: int, b: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.min (a: int, b: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.numberOfLeadingZeros (i: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.numberOfTrailingZeros (i: int): int
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseInt (s: CharSequence, beginIndex: int, endIndex: int, radix: int): int
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseInt (s: String): int
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseInt (s: String, radix: int): int
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseUnsignedInt (s: CharSequence, beginIndex: int, endIndex: int, radix: int): int
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseUnsignedInt (s: String): int
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseUnsignedInt (s: String, radix: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.remainderUnsigned (dividend: int, divisor: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.reverse (i: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.reverseBytes (i: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.rotateLeft (i: int, distance: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.rotateRight (i: int, distance: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.signum (i: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.sum (a: int, b: int): int
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toBinaryString (i: int): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toHexString (i: int): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toOctalString (i: int): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toString (i: int): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toString (i: int, radix: int): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toUnsignedLong (x: int): long
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toUnsignedString (i: int): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.toUnsignedString (i: int, radix: int): String
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.valueOf (s: String): LSLInteger
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.valueOf (s: String, radix: int): LSLInteger
    {
        // NOTE: using the original method
    }


    @static fun *.valueOf (i: int): LSLInteger
    {
        result = new IntegerAutomaton(state = Initialized,
            value = i
        );
    }


    // methods

    @Phantom fun *.byteValue (@target self: LSLInteger): byte
    {
        // NOTE: using the original method
    }


    @Phantom fun *.compareTo (@target self: LSLInteger, anotherInteger: Integer): int
    {
        // NOTE: using the original method
    }


    @Phantom fun *.doubleValue (@target self: LSLInteger): double
    {
        // NOTE: using the original method
    }


    @Phantom fun *.equals (@target self: LSLInteger, obj: Object): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.floatValue (@target self: LSLInteger): float
    {
        // NOTE: using the original method
    }


    @Phantom fun *.hashCode (@target self: LSLInteger): int
    {
        // NOTE: using the original method
    }


    @Phantom fun *.intValue (@target self: LSLInteger): int
    {
        // NOTE: using the original method
    }


    @Phantom fun *.longValue (@target self: LSLInteger): long
    {
        // NOTE: using the original method
    }


    @Phantom fun *.shortValue (@target self: LSLInteger): short
    {
        // NOTE: using the original method
    }


    @Phantom fun *.toString (@target self: LSLInteger): String
    {
        // NOTE: using the original method
    }


    // special: class initialization

    @Phantom fun *.__clinit__ (): void
    {
        // WARNING: this should be empty, do not change!
    }

}
