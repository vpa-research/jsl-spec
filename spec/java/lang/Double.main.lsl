libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Double.java";

// imports

import java/lang/Object;
import java/lang/String;

import java/lang/Double;


// automata

automaton DoubleAutomaton
(
    var value: double = 0.0,
)
: LSLDouble
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        Double (LSLDouble, String),
        Double (LSLDouble, double),

        // static operations
        compare,
        doubleToLongBits,
        doubleToRawLongBits,
        hashCode (double),
        isFinite,
        isInfinite (double),
        isNaN (double),
        longBitsToDouble,
        max,
        min,
        parseDouble,
        sum,
        toHexString,
        toString (double),
        valueOf (String),
        valueOf (double),
    ];

    shift Initialized -> self by [
        // instance methods
        byteValue,
        compareTo,
        doubleValue,
        equals,
        floatValue,
        hashCode (LSLDouble),
        intValue,
        isInfinite (LSLDouble),
        isNaN (LSLDouble),
        longValue,
        shortValue,
        toString (LSLDouble),
    ];

    // internal variables

    // utilities

    @static proc _getRawBits (v: double): long
    {
        if (v != v) // a NaN?
            result = 9221120237041090560L;
        else if (1.0 / v == NEGATIVE_INFINITY) // is it a "-0.0" ?
            result = -9223372036854775808L;
        else if (v == 0.0)
            result = 0L;
        else if (v == POSITIVE_INFINITY)
            result = 9218868437227405312L;
        else if (v == NEGATIVE_INFINITY)
            result = -4503599627370496L;
        else
        {
            // #todo: find more sophisticated approach
            result = action SYMBOLIC("long");

            action ASSUME(result != 9221120237041090560L);
            action ASSUME(result != -9223372036854775808L);
            action ASSUME(result != 0L);
            action ASSUME(result != 9218868437227405312L);
            action ASSUME(result != -4503599627370496L);

            if (v < 0.0)
                action ASSUME(result < 0L);
            else
                action ASSUME(result > 0L);
        }
    }


    @throws(["java.lang.NumberFormatException"])
    @static proc _parse (str: String): double
    {
        if (str == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        // #todo: add implementation if necessary
        action TODO();
    }


    // constructors

    @throws(["java.lang.NumberFormatException"])
    @Phantom constructor *.Double (@target self: LSLDouble, s: String)
    {
        // NOTE: using original method
    }


    constructor *.Double (@target self: LSLDouble, v: double)
    {
        this.value = v;
    }


    // static methods

    @static fun *.compare (a: double, b: double): int
    {
        // #problem: does not catch (-0.0, 0.0)
        if (a == b || a != a || b != b) // include NaN's
        {
            result = 0;
        }
        else
        {
            if (a < b)
                result = -1;
            else
                result = +1;
        }
    }


    @static fun *.doubleToLongBits (value: double): long
    {
        result = _getRawBits(value);
    }


    @static fun *.doubleToRawLongBits (value: double): long
    {
        result = _getRawBits(value);
    }


    @static fun *.hashCode (value: double): int
    {
        result = _getRawBits(value) as int;
    }


    @static fun *.isFinite (d: double): boolean
    {
        result = (d != POSITIVE_INFINITY) &&
                 (d != NEGATIVE_INFINITY);
    }


    @static fun *.isInfinite (v: double): boolean
    {
        result = (v == POSITIVE_INFINITY) ||
                 (v == NEGATIVE_INFINITY);
    }


    @static fun *.isNaN (v: double): boolean
    {
        result = v != v;
    }


    @static fun *.longBitsToDouble (value: long): double
    {
        if (value == 9221120237041090560L)
            result = NaN;
        else if (value == -9223372036854775808L)
            result = -0.0;
        else if (value == 0L)
            result = 0.0;
        else if (value == 9218868437227405312L)
            result = POSITIVE_INFINITY;
        else if (value == -4503599627370496L)
            result = NEGATIVE_INFINITY;
        else
        {
            // #todo: find more sophisticated approach
            result = action SYMBOLIC("double");

            action ASSUME(result != 0.0);
            action ASSUME(result == result);
            action ASSUME(result != POSITIVE_INFINITY);
            action ASSUME(result != NEGATIVE_INFINITY);

            if (value < 0L)
                action ASSUME(result < 0.0);
            else
                action ASSUME(result > 0.0);
        }
    }


    @static fun *.max (a: double, b: double): double
    {
        if (a > b)
            result = a;
        else
            result = b;
    }


    @static fun *.min (a: double, b: double): double
    {
        if (a < b)
            result = a;
        else
            result = b;
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseDouble (s: String): double
    {
        // NOTE: using original method
        result = _parse(s);
    }


    @static fun *.sum (a: double, b: double): double
    {
        result = a + b;
    }


    @static fun *.toHexString (d: double): String
    {
             if (d != d)                       result = "NaN";
        else if (d == POSITIVE_INFINITY)       result = "Infinity";
        else if (d == NEGATIVE_INFINITY)       result = "-Infinity";
        else if (1.0 / d == NEGATIVE_INFINITY) result = "-0x0.0p0";
        else if (d == 0.0f)                    result = "0x0.0p0";
        else if (d == 1.0f)                    result = "0x1.0p0";
        else if (d == -1.0f)                   result = "-0x1.0p0";
        else
        {
            // #todo: add implementation if necessary
            result = action SYMBOLIC("java.lang.String");
            action ASSUME(result != null);
            val len: int = action CALL_METHOD(result, "length", []);
            action ASSUME(len >= 7);  // 0x1.0p0
            action ASSUME(len <= 22); // 0x1.fffffffffffffp1023
        }
    }


    @static fun *.toString (d: double): String
    {
        result = action OBJECT_TO_STRING(d);
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.valueOf (s: String): Double
    {
        // NOTE: using original method
        result = new DoubleAutomaton(state = Initialized,
            value = _parse(s)
        );
    }


    @static fun *.valueOf (d: double): Double
    {
        result = new DoubleAutomaton(state = Initialized,
            value = d
        );
    }


    // methods

    fun *.byteValue (@target self: LSLDouble): byte
    {
        result = this.value as byte;
    }


    fun *.compareTo (@target self: LSLDouble, anotherDouble: Double): int
    {
        val a: double = this.value;
        val b: double = DoubleAutomaton(anotherDouble).value;

        // #problem: does not catch (-0.0, 0.0)
        if (a == b || a != a || b != b) // include NaN's
        {
            result = 0;
        }
        else
        {
            if (a < b)
                result = -1;
            else
                result = +1;
        }
    }


    fun *.doubleValue (@target self: LSLDouble): double
    {
        result = this.value;
    }


    fun *.equals (@target self: LSLDouble, obj: Object): boolean
    {
        if (obj is Double)
            result = this.value == DoubleAutomaton(obj).value;
        else
            result = false;
    }


    fun *.floatValue (@target self: LSLDouble): float
    {
        result = this.value as float;
    }


    fun *.hashCode (@target self: LSLDouble): int
    {
        result = _getRawBits(this.value) as int;
    }


    fun *.intValue (@target self: LSLDouble): int
    {
        result = this.value as int;
    }


    fun *.isInfinite (@target self: LSLDouble): boolean
    {
        result = (this.value == POSITIVE_INFINITY) ||
                 (this.value == NEGATIVE_INFINITY);
    }


    fun *.isNaN (@target self: LSLDouble): boolean
    {
        result = this.value != this.value;
    }


    fun *.longValue (@target self: LSLDouble): long
    {
        result = this.value as long;
    }


    fun *.shortValue (@target self: LSLDouble): short
    {
        result = this.value as short;
    }


    fun *.toString (@target self: LSLDouble): String
    {
        result = action OBJECT_TO_STRING(this.value);
    }

}
