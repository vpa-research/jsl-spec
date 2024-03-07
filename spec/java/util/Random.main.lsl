//#! pragma: target=java
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
        `<init>` (Random),
        `<init>` (Random, long),
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

    @AutoInline @Phantom proc _throwIAE (): void
    {
        action THROW_NEW("java.lang.IllegalArgumentException", []);
    }


    @static proc _nextBytes (result: array<byte>, numBytes: int): void
    {
        val symbolicArray: array<byte> = action SYMBOLIC_ARRAY("byte", numBytes);
        action ARRAY_COPY(symbolicArray, 0, result, 0, numBytes);
    }


    proc _generateRandomIntegerArrayWithBounds (size: int, randomNumberOrigin: int, randomNumberBound: int): array<int>
    {
        result = action SYMBOLIC_ARRAY("int", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkIntBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc checkIntBounds_loop (i: int, result: array<int>, randomNumberOrigin: int, randomNumberBound: int): void
    {
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomLongArrayWithBounds (size: int, randomNumberOrigin: long, randomNumberBound: long): array<long>
    {
        result = action SYMBOLIC_ARRAY("long", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkLongBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc checkLongBounds_loop (i: int, result: array<long>, randomNumberOrigin: long, randomNumberBound: long): void
    {
        action ASSUME(result[i] >= randomNumberOrigin);
        action ASSUME(result[i] < randomNumberBound);
    }


    proc _generateRandomDoubleArrayWithBounds (size: int, randomNumberOrigin: double, randomNumberBound: double): array<double>
    {
        result = action SYMBOLIC_ARRAY("double", size);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            checkDoubleBounds_loop(i, result, randomNumberOrigin, randomNumberBound)
        );
    }


    @Phantom proc checkDoubleBounds_loop (i: int, result: array<double>, randomNumberOrigin: double, randomNumberBound: double): void
    {
        val item: double = result[i];
        action ASSUME(item == item);
        action ASSUME(item >= randomNumberOrigin);
        action ASSUME(item < randomNumberBound);
    }


    // constructors

    constructor *.`<init>` (@target self: Random)
    {
        action DO_NOTHING();
    }


    constructor *.`<init>` (@target self: Random, seed: long)
    {
        action DO_NOTHING();
    }


    // static methods

    // methods

    fun *.doubles (@target self: Random): DoubleStream
    {
        result = new DoubleStreamAutomaton(state = Initialized,
            storage = _generateRandomDoubleArrayWithBounds(RANDOM_STREAM_SIZE_MAX, 0, 1),
            length = RANDOM_STREAM_SIZE_MAX,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.doubles (@target self: Random, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();
        result = new DoubleStreamAutomaton(state = Initialized,
            storage = _generateRandomDoubleArrayWithBounds(RANDOM_STREAM_SIZE_MAX, randomNumberOrigin, randomNumberBound),
            length = RANDOM_STREAM_SIZE_MAX,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.doubles (@target self: Random, streamSize: long): DoubleStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > RANDOM_STREAM_SIZE_MAX)
            size = RANDOM_STREAM_SIZE_MAX;

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("double", size),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.doubles (@target self: Random, streamSize: long, randomNumberOrigin: double, randomNumberBound: double): DoubleStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();
        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > RANDOM_STREAM_SIZE_MAX)
            size = RANDOM_STREAM_SIZE_MAX;

        result = new DoubleStreamAutomaton(state = Initialized,
            storage = _generateRandomDoubleArrayWithBounds(size, randomNumberOrigin, randomNumberBound),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.ints (@target self: Random): IntStream
    {
        result = new IntStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("int", RANDOM_STREAM_SIZE_MAX),
            length = RANDOM_STREAM_SIZE_MAX,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.ints (@target self: Random, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();
        result = new IntStreamAutomaton(state = Initialized,
            storage = _generateRandomIntegerArrayWithBounds(RANDOM_STREAM_SIZE_MAX, randomNumberOrigin, randomNumberBound),
            length = RANDOM_STREAM_SIZE_MAX,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.ints (@target self: Random, streamSize: long): IntStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > RANDOM_STREAM_SIZE_MAX)
            size = RANDOM_STREAM_SIZE_MAX;

        result = new IntStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("int", size),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.ints (@target self: Random, streamSize: long, randomNumberOrigin: int, randomNumberBound: int): IntStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();
        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > RANDOM_STREAM_SIZE_MAX)
            size = RANDOM_STREAM_SIZE_MAX;

        result = new IntStreamAutomaton(state = Initialized,
            storage = _generateRandomIntegerArrayWithBounds(size, randomNumberOrigin, randomNumberBound),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.longs (@target self: Random): LongStream
    {
        result = new LongStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("long", RANDOM_STREAM_SIZE_MAX),
            length = RANDOM_STREAM_SIZE_MAX,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.longs (@target self: Random, streamSize: long): LongStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > RANDOM_STREAM_SIZE_MAX)
            size = RANDOM_STREAM_SIZE_MAX;

        result = new LongStreamAutomaton(state = Initialized,
            storage = action SYMBOLIC_ARRAY("long", size),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.longs (@target self: Random, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();
        result = new LongStreamAutomaton(state = Initialized,
            storage = _generateRandomLongArrayWithBounds(RANDOM_STREAM_SIZE_MAX, randomNumberOrigin, randomNumberBound),
            length = RANDOM_STREAM_SIZE_MAX,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.longs (@target self: Random, streamSize: long, randomNumberOrigin: long, randomNumberBound: long): LongStream
    {
        var size: int = streamSize as int;
        if (size < 0)
            _throwIAE();
        if (randomNumberOrigin >= randomNumberBound)
            _throwIAE();
        // WARNING: this is our special constraint; We must constraint infinite stream for USVM.
        if (size > RANDOM_STREAM_SIZE_MAX)
            size = RANDOM_STREAM_SIZE_MAX;

        result = new LongStreamAutomaton(state = Initialized,
            storage = _generateRandomLongArrayWithBounds(size, randomNumberOrigin, randomNumberBound),
            length = size,
            closeHandlers = action LIST_NEW(),
        );
    }


    fun *.nextBoolean (@target self: Random): boolean
    {
        result = action SYMBOLIC("boolean");
    }


    fun *.nextBytes (@target self: Random, bytes: array<byte>): void
    {
        _nextBytes(bytes, action ARRAY_SIZE(bytes));
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
