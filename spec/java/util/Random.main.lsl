///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Random.java";

// imports

import java/io/ObjectInputStream;
import java/io/ObjectOutputStream;
import java/util/Random;
import java/util/stream/DoubleStream;
import java/util/stream/IntStream;
import java/util/stream/LongStream;


// automata

automaton RandomAutomaton
(
)
: Random
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
        // instance methods
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
        nextLong,
        setSeed,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.Random (@target self: Random)
    {
        action DO_NOTHING();
    }


    constructor *.Random (@target self: Random, seed: long)
    {
        action DO_NOTHING();
    }


    // static methods

    // methods

    fun *.doubles (@target self: Random): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun *.doubles (@target self: Random, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun *.doubles (@target self: Random, streamSize: long): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun *.doubles (@target self: Random, streamSize: long, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    fun *.ints (@target self: Random): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun *.ints (@target self: Random, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun *.ints (@target self: Random, streamSize: long): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun *.ints (@target self: Random, streamSize: long, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    fun *.longs (@target self: Random): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun *.longs (@target self: Random, streamSize: long): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun *.longs (@target self: Random, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun *.longs (@target self: Random, streamSize: long, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        // #problem: no streams yet
        result = action SYMBOLIC("java.util.stream.LongStream");
        action ASSUME(result != null);
    }


    fun *.nextBoolean (@target self: Random): boolean
    {
        result = action SYMBOLIC("boolean");
    }


    fun *.nextBytes (@target self: Random, bytes: array<byte>): void
    {
        // #question: is there a more efficient way?
        val size: int = action ARRAY_SIZE(bytes);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            nextBytes_loop(i, bytes)
        );
    }

    @Phantom proc nextBytes_loop (i: int, bytes: array<byte>): void
    {
        bytes[i] = action SYMBOLIC("byte");
    }


    fun *.nextDouble (@target self: Random): double
    {
        result = action SYMBOLIC("double");

        action ASSUME(0.0 <= result);
        action ASSUME(result < 1.0);
    }


    fun *.nextFloat (@target self: Random): float
    {
        result = action SYMBOLIC("float");

        action ASSUME(0.0f <= result);
        action ASSUME(result < 1.0f);
    }


    @synchronized fun *.nextGaussian (@target self: Random): double
    {
        result = action SYMBOLIC("double");
        val isNaN: boolean = result != result;
        action ASSUME(isNaN == false);
    }


    fun *.nextInt (@target self: Random): int
    {
        result = action SYMBOLIC("int");
    }


    fun *.nextInt (@target self: Random, bound: int): int
    {
        if (bound <= 0)
            action THROW_NEW("java.lang.IllegalArgumentException", ["bound must be positive"]);

        result = action SYMBOLIC("int");

        action ASSUME(0 <= result);
        action ASSUME(result < bound);
    }


    fun *.nextLong (@target self: Random): long
    {
        result = action SYMBOLIC("long");
    }


    @synchronized fun *.setSeed (@target self: Random, seed: long): void
    {
        action DO_NOTHING();
    }


    // serialization

    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun *.readObject (s: ObjectInputStream): void
    {
        action NOT_IMPLEMENTED("no serialization support");
    }

    @throws(["java.io.IOException"])
    @private @synchronized fun *.writeObject(s: ObjectOutputStream): void
    {
        action NOT_IMPLEMENTED("no serialization support");
    }

}
