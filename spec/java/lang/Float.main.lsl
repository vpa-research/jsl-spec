libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Float.java";

// imports

import java/lang/String;

import java/lang/Float;


// automata

automaton FloatAutomaton
(
    var value: float = 0.0f,
)
: LSLFloat
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (LSLFloat, String),
        `<init>` (LSLFloat, double),
        `<init>` (LSLFloat, float),

        // static operations
        compare,
        floatToIntBits,
        floatToRawIntBits,
        hashCode (float),
        intBitsToFloat,
        isFinite,
        isInfinite (float),
        isNaN (float),
        max,
        min,
        parseFloat,
        sum,
        toHexString,
        toString (float),
        valueOf (String),
        valueOf (float),
    ];

    shift Initialized -> self by [
        // instance methods
        byteValue,
        compareTo,
        doubleValue,
        equals,
        floatValue,
        hashCode (LSLFloat),
        intValue,
        isInfinite (LSLFloat),
        isNaN (LSLFloat),
        longValue,
        shortValue,
        toString (LSLFloat),
    ];

    // internal variables

    // utilities

    @static proc _getRawBits (v: float): int
    {
        if (v != v) // a NaN?
            result = 2143289344;
        else if (1.0f / v == NEGATIVE_INFINITY) // is it a "-0.0" ?
            result = -2147483648;
        else if (v == 0.0f)
            result = 0;
        else if (v == POSITIVE_INFINITY)
            result = 2139095040;
        else if (v == NEGATIVE_INFINITY)
            result = -8388608;
        else
        {
            // #todo: find more sophisticated approach
            result = action SYMBOLIC("int");

            action ASSUME(result != 2143289344);
            action ASSUME(result != -2147483648);
            action ASSUME(result != 0);
            action ASSUME(result != 2139095040);
            action ASSUME(result != -8388608);

            if (v < 0.0f)
                action ASSUME(result < 0);
            else
                action ASSUME(result > 0);
        }
    }


    @throws(["java.lang.NumberFormatException"])
    @static proc _parse (str: String): float
    {
        if (str == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        // #todo: add implementation if necessary
        action TODO();
    }


    // constructors

    @throws(["java.lang.NumberFormatException"])
    @Phantom constructor *.`<init>` (@target self: LSLFloat, s: String)
    {
        // NOTE: using the original method
        this.value = _parse(s);
    }


    constructor *.`<init>` (@target self: LSLFloat, v: double)
    {
        this.value = v as float;
    }


    constructor *.`<init>` (@target self: LSLFloat, v: float)
    {
        this.value = v;
    }


    // static methods

    @static fun *.compare (a: float, b: float): int
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


    @static fun *.floatToIntBits (value: float): int
    {
        result = _getRawBits(value);
    }


    @static fun *.floatToRawIntBits (value: float): int
    {
        result = _getRawBits(value);
    }


    @static fun *.hashCode (value: float): int
    {
        result = _getRawBits(value);
    }


    @static fun *.intBitsToFloat (value: int): float
    {
        if (value == 2143289344)
            result = NaN;
        else if (value == -2147483648)
            result = -0.0f;
        else if (value == 0)
            result = 0.0f;
        else if (value == 2139095040)
            result = POSITIVE_INFINITY;
        else if (value == -8388608)
            result = NEGATIVE_INFINITY;
        else
        {
            // #todo: find more sophisticated approach
            result = action SYMBOLIC("float");

            action ASSUME(result != 0.0f);
            action ASSUME(result == result);
            action ASSUME(result != POSITIVE_INFINITY);
            action ASSUME(result != NEGATIVE_INFINITY);

            if (value < 0)
                action ASSUME(result < 0.0f);
            else
                action ASSUME(result > 0.0f);
        }
    }


    @static fun *.isFinite (f: float): boolean
    {
        // behaving similarly to Math.abs
        if (f <= 0.0f)
            f = 0.0f - f;

        result = f <= MAX_VALUE;
    }


    @static fun *.isInfinite (v: float): boolean
    {
        result = (v == POSITIVE_INFINITY) ||
                 (v == NEGATIVE_INFINITY);
    }


    @static fun *.isNaN (v: float): boolean
    {
        result = v != v;
    }


    @static fun *.max (a: float, b: float): float
    {
        if (a != a) // catching NaN's
            result = a;
        else if (a == 0.0f && b == 0.0f && 1.0f / a == NEGATIVE_INFINITY) // catching '-0.0'
            result = b;
        else if (a >= b)
            result = a;
        else
            result = b;
    }


    @static fun *.min (a: float, b: float): float
    {
        if (a != a) // catching NaN's
            result = a;
        else if (a == 0.0f && b == 0.0f && 1.0f / b == NEGATIVE_INFINITY) // catching '-0.0'
            result = b;
        else if (a <= b)
            result = a;
        else
            result = b;
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.parseFloat (s: String): float
    {
        // NOTE: using the original method
        result = _parse(s);
    }


    @static fun *.sum (a: float, b: float): float
    {
        result = a + b;
    }


    @static fun *.toHexString (f: float): String
    {
             if (f != f)                        result = "NaN";
        else if (f == POSITIVE_INFINITY)        result = "Infinity";
        else if (f == NEGATIVE_INFINITY)        result = "-Infinity";
        else if (1.0f / f == NEGATIVE_INFINITY) result = "-0x0.0p0";
        else if (f == 0.0f)                     result = "0x0.0p0";
        else if (f == 1.0f)                     result = "0x1.0p0";
        else if (f == -1.0f)                    result = "-0x1.0p0";
        else
        {
            // #todo: add implementation if necessary
            result = action SYMBOLIC("java.lang.String");
            action ASSUME(result != null);
            val len: int = action CALL_METHOD(result, "length", []);
            action ASSUME(len >= 7);  // 0x1.0p0
            action ASSUME(len <= 14); // 0x1.fffffep127
        }
    }


    @static fun *.toString (f: float): String
    {
        result = action OBJECT_TO_STRING(f);
    }


    @throws(["java.lang.NumberFormatException"])
    @Phantom @static fun *.valueOf (s: String): Float
    {
        // NOTE: using the original version
        result = new FloatAutomaton(state = Initialized,
            value = _parse(s)
        );
    }


    @static fun *.valueOf (f: float): Float
    {
        result = new FloatAutomaton(state = Initialized,
            value = f
        );
    }


    // methods

    fun *.byteValue (@target self: LSLFloat): byte
    {
        result = this.value as byte;
    }


    fun *.compareTo (@target self: LSLFloat, anotherFloat: LSLFloat): int
    {
        val a: float = this.value;
        val b: float = FloatAutomaton(anotherFloat).value;

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


    fun *.doubleValue (@target self: LSLFloat): double
    {
        result = this.value as double;
    }


    fun *.equals (@target self: LSLFloat, obj: Object): boolean
    {
        if (obj is Float)
            result = this.value == FloatAutomaton(obj).value;
        else
            result = false;
    }


    fun *.floatValue (@target self: LSLFloat): float
    {
        result = this.value;
    }


    fun *.hashCode (@target self: LSLFloat): int
    {
        result = _getRawBits(this.value);
    }


    fun *.intValue (@target self: LSLFloat): int
    {
        result = this.value as int;
    }


    fun *.isInfinite (@target self: LSLFloat): boolean
    {
        result = (this.value == POSITIVE_INFINITY) ||
                 (this.value == NEGATIVE_INFINITY);
    }


    fun *.isNaN (@target self: LSLFloat): boolean
    {
        result = this.value != this.value;
    }


    fun *.longValue (@target self: LSLFloat): long
    {
        result = this.value as long;
    }


    fun *.shortValue (@target self: LSLFloat): short
    {
        result = this.value as short;
    }


    fun *.toString (@target self: LSLFloat): String
    {
        result = action OBJECT_TO_STRING(this.value);
    }

}
