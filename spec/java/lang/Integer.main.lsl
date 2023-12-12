libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Integer.java";

// imports

import java/lang/CharSequence;
import java/lang/Object;
import java/lang/String;

import java/lang/Integer;


// automata

automaton IntegerAutomaton
(
    @private var value: int // WARNING: do not rename!
)
: LSLInteger
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // constructors
        `<init>` (LSLInteger, String),
        `<init>` (LSLInteger, int),

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

    @throws(["java.lang.NumberFormatException"])
    @static proc _parse (str: String): int
    {
        if (str == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        // #todo: add implementation if necessary
        action TODO();
    }


    // constructors

    @throws(["java.lang.NumberFormatException"])
    @Phantom constructor *.`<init>` (@target self: LSLInteger, s: String)
    {
        // NOTE: using the original method
        this.value = _parse(s);
    }


    constructor *.`<init>` (@target self: LSLInteger, v: int)
    {
        this.value = v;
    }


    // static methods

    @static fun *.bitCount (i: int): int
    {
        // direct adaptation from the JDK
        i = i - ((i >>> 1) & 1431655765);
        i = (i & 858993459) + ((i >>> 2) & 858993459);
        i = (i + (i >>> 4)) & 252645135;
        i = i + (i >>> 8);
        i = i + (i >>> 16);
        result = i & 63;
    }


    @static fun *.compare (x: int, y: int): int
    {
        if (x == y)
        {
            result = 0;
        }
        else
        {
            if (x < y)
                result = -1;
            else
                result = +1;
        }
    }


    @static fun *.compareUnsigned (x: int, y: int): int
    {
        x += MIN_VALUE;
        y += MIN_VALUE;

        if (x == y)
        {
            result = 0;
        }
        else
        {
            if (x < y)
                result = -1;
            else
                result = +1;
        }
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.decode (nm: String): Integer
    {
        // NOTE: using the original method
    }


    @static fun *.divideUnsigned (dividend: int, divisor: int): int
    {
        val unsignedDividend: long = dividend as long & 4294967295L;
        val unsignedDivisor: long = divisor as long & 4294967295L;
        result = (unsignedDividend / unsignedDivisor) as int;
    }


    @Phantom @static fun *.getInteger (nm: String): Integer
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getInteger (nm: String, _val: Integer): Integer
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getInteger (nm: String, _val: int): Integer
    {
        // NOTE: using the original method
    }


    @static fun *.hashCode (value: int): int
    {
        result = value;
    }


    @static fun *.highestOneBit (i: int): int
    {
        // direct adaptation from the JDK
        i |= (i >>  1);
        i |= (i >>  2);
        i |= (i >>  4);
        i |= (i >>  8);
        i |= (i >> 16);
        result = i - (i >>> 1);
    }


    @static fun *.lowestOneBit (i: int): int
    {
        // direct adaptation from the JDK
        result = i & -i;
    }


    @static fun *.max (a: int, b: int): int
    {
        if (a > b)
            result = a;
        else
            result = b;
    }


    @static fun *.min (a: int, b: int): int
    {
        if (a < b)
            result = a;
        else
            result = b;
    }


    @static fun *.numberOfLeadingZeros (i: int): int
    {
        if (i == 0)
        {
            result = 32;
        }
        else
        {
            // direct adaptation from the JDK
            result = 1;

            if (i >>> 16 == 0) { result += 16; i <<= 16; }
            if (i >>> 24 == 0) { result +=  8; i <<=  8; }
            if (i >>> 28 == 0) { result +=  4; i <<=  4; }
            if (i >>> 30 == 0) { result +=  2; i <<=  2; }

            result -= i >>> 31;
        }
    }


    @static fun *.numberOfTrailingZeros (i: int): int
    {
        if (i == 0)
        {
            result = 32;
        }
        else
        {
            // direct adaptation from the JDK
            var y: int = 0;
            result = 31;

            y = i << 16;  if (y != 0) { result -= 16; i = y; }
            y = i <<  8;  if (y != 0) { result -=  8; i = y; }
            y = i <<  4;  if (y != 0) { result -=  4; i = y; }
            y = i <<  2;  if (y != 0) { result -=  2; i = y; }

            result -= ((i << 1) >>> 31);
        }
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


    @static fun *.remainderUnsigned (dividend: int, divisor: int): int
    {
        val unsignedDividend: long = dividend as long & 4294967295L;
        val unsignedDivisor: long = divisor as long & 4294967295L;
        result = (unsignedDividend % unsignedDivisor) as int;
    }


    @static fun *.reverse (i: int): int
    {
        // direct adaptation from the JDK
        i = (i & 1431655765) << 1 | (i >>> 1) & 1431655765;
        i = (i &  858993459) << 2 | (i >>> 2) & 858993459;
        i = (i &  252645135) << 4 | (i >>> 4) & 252645135;
        i = (i << 24) | ((i & 65280) << 8) |
            ((i >>> 8) & 65280) | (i >>> 24);

        result = i;
    }


    @static fun *.reverseBytes (i: int): int
    {
        // direct adaptation from the JDK
        result = ((i >>> 24)           ) |
                 ((i >>   8) &    65280) |
                 ((i <<   8) & 16711680) |
                 ((i << 24));
    }


    @static fun *.rotateLeft (i: int, distance: int): int
    {
        // direct adaptation from the JDK
        result = (i << distance) | (i >>> -distance);
    }


    @static fun *.rotateRight (i: int, distance: int): int
    {
        // direct adaptation from the JDK
        result = (i >>> distance) | (i << -distance);
    }


    @static fun *.signum (i: int): int
    {
        // direct adaptation from the JDK
        result = (i >> 31) | (-i >>> 31);
    }


    @static fun *.sum (a: int, b: int): int
    {
        result = a + b;
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


    @static fun *.toString (i: int): String
    {
        result = action OBJECT_TO_STRING(i);
    }


    @Phantom @static fun *.toString (i: int, radix: int): String
    {
        // NOTE: using the original method
    }


    @static fun *.toUnsignedLong (x: int): long
    {
        // direct adaptation from the JDK
        result = x as long & 4294967295L;
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
    @Phantom @static fun *.valueOf (s: String): Integer
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.valueOf (s: String, radix: int): Integer
    {
        // NOTE: using the original method
    }


    @static fun *.valueOf (i: int): Integer
    {
        result = new IntegerAutomaton(state = Initialized,
            value = i
        );
    }


    // methods

    fun *.byteValue (@target self: LSLInteger): byte
    {
        result = this.value as byte;
    }


    fun *.compareTo (@target self: LSLInteger, anotherInteger: LSLInteger): int
    {
        val x: int = this.value;
        val y: int = IntegerAutomaton(anotherInteger).value;

        if (x == y)
        {
            result = 0;
        }
        else
        {
            if (x < y)
                result = -1;
            else
                result = +1;
        }
    }


    fun *.doubleValue (@target self: LSLInteger): double
    {
        result = this.value as double;
    }


    fun *.equals (@target self: LSLInteger, obj: Object): boolean
    {
        if (obj is Integer)
            result = this.value == IntegerAutomaton(obj).value;
        else
            result = false;
    }


    fun *.floatValue (@target self: LSLInteger): float
    {
        result = this.value as float;
    }


    fun *.hashCode (@target self: LSLInteger): int
    {
        result = this.value;
    }


    fun *.intValue (@target self: LSLInteger): int
    {
        result = this.value;
    }


    fun *.longValue (@target self: LSLInteger): long
    {
        result = this.value as long;
    }


    fun *.shortValue (@target self: LSLInteger): short
    {
        result = this.value as short;
    }


    fun *.toString (@target self: LSLInteger): String
    {
        result = action OBJECT_TO_STRING(this.value);
    }

}
