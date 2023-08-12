///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Random.java";

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
        // nothing
    }


    constructor Random (@target self: Random, seed: long)
    {
        // nothing
    }


    // utilities

    // static methods

    // methods

    fun doubles (@target self: Random): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun doubles (@target self: Random, arg0: double, arg1: double): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun doubles (@target self: Random, arg0: long): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun doubles (@target self: Random, arg0: long, arg1: double, arg2: double): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun ints (@target self: Random): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun ints (@target self: Random, arg0: int, arg1: int): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun ints (@target self: Random, arg0: long): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun ints (@target self: Random, arg0: long, arg1: int, arg2: int): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun longs (@target self: Random): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun longs (@target self: Random, arg0: long): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun longs (@target self: Random, arg0: long, arg1: long): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun longs (@target self: Random, arg0: long, arg1: long, arg2: long): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun nextBoolean (@target self: Random): boolean
    {
        result = action SYMBOLIC("boolean");
    }


    fun nextBytes (@target self: Random, bytes: array<byte>): void
    {
        // #problem: is there a more efficient way?
        val size: int = action ARRAY_SIZE(bytes);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            nextBytes_loop(i, bytes)
        );
    }

    @LambdaComponent proc nextBytes_loop (i: int, bytes: array<byte>): void
    {
        bytes[i] = action SYMBOLIC("byte");
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
        // #problem: result should not be NaN
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
