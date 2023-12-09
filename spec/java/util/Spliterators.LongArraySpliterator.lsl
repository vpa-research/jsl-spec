libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Spliterators.java";

// imports

import java/util/Comparator;
import java/util/Spliterator;
import java/util/function/Consumer;
import java/util/function/LongConsumer;

import java/util/Spliterators;


// automata

automaton Spliterators_LongArraySpliteratorAutomaton
(
    var array: array<long>,
    var index: int = 0,
    var fence: int = -1,
    var characteristics: int = 0,
)
: Spliterators_LongArraySpliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        init (Spliterators_LongArraySpliterator, array<long>, int),
        init (Spliterators_LongArraySpliterator, array<long>, int, int, int),
    ];

    shift Initialized -> self by [
        // instance methods
        characteristics,
        estimateSize,
        forEachRemaining (Spliterators_LongArraySpliterator, Consumer),
        forEachRemaining (Spliterators_LongArraySpliterator, LongConsumer),
        forEachRemaining (Spliterators_LongArraySpliterator, Object),
        getComparator,
        getExactSizeIfKnown,
        hasCharacteristics,
        tryAdvance (Spliterators_LongArraySpliterator, Consumer),
        tryAdvance (Spliterators_LongArraySpliterator, LongConsumer),
        tryAdvance (Spliterators_LongArraySpliterator, Object),
        trySplit,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwISE (): void
    {
        action THROW_NEW("java.lang.IllegalStateException", []);
    }


    proc _hasCharacteristics (_characteristics: int): boolean
    {
        result = (this.characteristics & _characteristics) == _characteristics;
    }


    // constructors

    constructor *.init (@target self: Spliterators_LongArraySpliterator,
                        arr: array<long>, additionalCharacteristics: int)
    {
        // WARNING: unused

        this.array = arr;
        this.index = 0;
        this.fence = action ARRAY_SIZE(arr);
        this.characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED;
    }


    constructor *.init (@target self: Spliterators_LongArraySpliterator,
                        arr: array<long>, origin: int, pFence: int, additionalCharacteristics: int)
    {
        // WARNING: unused

        this.array = arr;
        this.index = origin;
        this.fence = pFence;
        this.characteristics = additionalCharacteristics | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED;
    }


    // static methods

    // methods

    fun *.characteristics (@target self: Spliterators_LongArraySpliterator): int
    {
        result = this.characteristics;
    }


    fun *.estimateSize (@target self: Spliterators_LongArraySpliterator): long
    {
        result = (this.fence - this.index) as long;
    }


    @AutoInline @Phantom proc _forEachRemaining (_action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        val a: array<long> = this.array;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            _forEachRemaining_loop(i, a, _action)
        );
    }

    @Phantom proc _forEachRemaining_loop (i: int, a: array<long>, _action: Consumer): void
    {
        val item: long = a[i];
        action CALL(_action, [item]);
    }


    fun *.forEachRemaining (@target self: Spliterators_LongArraySpliterator, _action: Consumer): void
    {
        _forEachRemaining(_action); // WARNING: inlined call!
    }


    fun *.forEachRemaining (@target self: Spliterators_LongArraySpliterator, _action: LongConsumer): void
    {
        _forEachRemaining(_action); // WARNING: inlined call!
    }


    @Phantom fun *.forEachRemaining (@target self: Spliterators_LongArraySpliterator, userAction: Object): void
    {
        // NOTE: using the original method due to Java Compiler error "name clash"

        val _action: LongConsumer = userAction as LongConsumer;
        _forEachRemaining(_action); // WARNING: inlined call!
    }


    fun *.getComparator (@target self: Spliterators_LongArraySpliterator): Comparator
    {
        if (_hasCharacteristics(SPLITERATOR_SORTED))
            result = null;
        else
            _throwISE();
    }


    fun *.getExactSizeIfKnown (@target self: Spliterators_LongArraySpliterator): long
    {
        result = (this.fence - this.index) as long;
    }


    fun *.hasCharacteristics (@target self: Spliterators_LongArraySpliterator, _characteristics: int): boolean
    {
        result = _hasCharacteristics(_characteristics);
    }


    @AutoInline @Phantom proc _tryAdvance (_action: Consumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = this.fence;
        val i: int = this.index;

        if (i < hi)
        {
            this.index = i + 1;

            val item: long = this.array[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.tryAdvance (@target self: Spliterators_LongArraySpliterator, _action: LongConsumer): boolean
    {
        _tryAdvance(_action); // WARNING: inlined call!
    }


    fun *.tryAdvance (@target self: Spliterators_LongArraySpliterator, _action: Consumer): boolean
    {
        _tryAdvance(_action); // WARNING: inlined call!
    }


    @Phantom fun *.tryAdvance (@target self: Spliterators_LongArraySpliterator, userAction: Object): boolean
    {
        // NOTE: using the original method due to Java Compiler error "name clash"

        val _action: LongConsumer = userAction as LongConsumer;
        _tryAdvance(_action); // WARNING: inlined call!
    }


    fun *.trySplit (@target self: Spliterators_LongArraySpliterator): Spliterator_OfLong
    {
        val hi: int = this.fence;
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        if (lo >= mid)
            result = null;
        else
            result = new Spliterators_LongArraySpliteratorAutomaton(state = Initialized,
                array = this.array,
                index = lo,
                fence = mid,
                characteristics = this.characteristics,
            );

        this.index = mid;
    }

}
