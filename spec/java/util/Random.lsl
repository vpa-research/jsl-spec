///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "-";

// imports

import java.common;
import java/lang/_interfaces;
import java/util/stream/_interfaces;


// local semantic types

@implements("java.io.Serializable")
@public type Random
    is java.util.Random
    for Object
{
    //@private @static val serialVersionUID: long = 1; // #problem: should be 3905348978240129619
}


// automata

automaton RandomAutomaton: Random
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        Random (Random),
        Random (Random, long),
    ];

    shift Initialized -> self by [
        doubles (Random),
        doubles (Random, double, double),
        doubles (Random, long),
        doubles (Random, long, double, double),

        ints (Random),
        ints (Random, int, int),
        ints (Random, long),
        ints (Random, long, int, int),

        longs (Random),
        longs (Random, long),
        longs (Random, long, long),
        longs (Random, long, long, long),

        nextBoolean,
        nextBytes,
        nextDouble,
        nextFloat,
        nextGaussian,
        nextInt (Random),
        nextInt (Random, int),
        nextLong (),

        setSeed,
    ];


    // constructors

    constructor Random (@target self: Random)
    {
        action TODO();
    }


    constructor Random (@target self: Random, arg0: long)
    {
        action TODO();
    }


    // utilities

    // static methods

    // methods

    fun doubles (@target self: Random): DoubleStream
    {
        action TODO();
    }


    fun doubles (@target self: Random, arg0: double, arg1: double): DoubleStream
    {
        action TODO();
    }


    fun doubles (@target self: Random, arg0: long): DoubleStream
    {
        action TODO();
    }


    fun doubles (@target self: Random, arg0: long, arg1: double, arg2: double): DoubleStream
    {
        action TODO();
    }


    fun ints (@target self: Random): IntStream
    {
        action TODO();
    }


    fun ints (@target self: Random, arg0: int, arg1: int): IntStream
    {
        action TODO();
    }


    fun ints (@target self: Random, arg0: long): IntStream
    {
        action TODO();
    }


    fun ints (@target self: Random, arg0: long, arg1: int, arg2: int): IntStream
    {
        action TODO();
    }


    fun longs (@target self: Random): LongStream
    {
        action TODO();
    }


    fun longs (@target self: Random, arg0: long): LongStream
    {
        action TODO();
    }


    fun longs (@target self: Random, arg0: long, arg1: long): LongStream
    {
        action TODO();
    }


    fun longs (@target self: Random, arg0: long, arg1: long, arg2: long): LongStream
    {
        action TODO();
    }


    fun nextBoolean (@target self: Random): boolean
    {
        result = action SYMBOLIC("boolean");
    }


    fun nextBytes (@target self: Random, arg0: array<byte>): void
    {
        action TODO();
    }


    fun nextDouble (@target self: Random): double
    {
        result = action SYMBOLIC("double");

        action ASSUME(0.0d <= result);
        action ASSUME(result < 1.0d);
    }


    fun nextFloat (@target self: Random): float
    {
        result = action SYMBOLIC("float");

        action ASSUME(0.0f <= result);
        action ASSUME(result < 1.0f);
    }


    @synchronized fun nextGaussian (@target self: Random): double
    {
        result = action SYMBOLIC("double");
        // #problem: result cant be NaN
    }


    fun nextInt (@target self: Random): int
    {
        result = action SYMBOLIC("int");
    }


    fun nextInt (@target self: Random, bound: int): int
    {
        if (bound <= 0)
        {
            action THROW_NEW("java.lang.IllegalArgumentException", ["bound must be positive"]);
        }

        result = action SYMBOLIC("int");

        action ASSUME(0 <= result);
        action ASSUME(result < bound);
    }


    fun nextLong (@target self: Random): long
    {
        result = action SYMBOLIC("long");
    }


    @synchronized fun setSeed (@target self: Random, seed: long): void
    {
        // nothing
    }

}
