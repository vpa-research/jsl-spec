libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/Spliterators.java";

// imports

import java/util/stream/Stream;
import java/util/function/Consumer;
import java/util/Spliterator;
import java/util/Comparator;
import java/util/function/LongConsumer;


// automata

automaton LongStreamSpliteratorAutomaton
(
    var parent: LongStreamLSL,
    var characteristics: int = 0,
    var fence: int = -1,
    var index: int = 0
)
: LongStreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining (LongStreamLSLSpliterator, LongConsumer),
       forEachRemaining (LongStreamLSLSpliterator, Consumer),
       tryAdvance (LongStreamLSLSpliterator, LongConsumer),
       tryAdvance (LongStreamLSLSpliterator, Consumer),
       estimateSize,
       getComparator,
       getExactSizeIfKnown,
       hasCharacteristics,
    ];


    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwISE (): void
    {
        action THROW_NEW("java.lang.IllegalStateException", []);
    }


    proc _getFence (): int
    {
        // JDK comment: initialize fence to size on first use
        if (this.fence < 0)
        {
            action ASSUME(this.parent != null);
            this.fence = LongStreamAutomaton(this.parent).length;
        }
        result = this.fence;
    }


    proc _hasCharacteristics (_characteristics: int): boolean
    {
        result = (this.characteristics & _characteristics) == _characteristics;
    }


    // methods

    fun *.characteristics (@target self: LongStreamLSLSpliterator): int
    {
        result = this.characteristics;
    }


    fun *.trySplit (@target self: LongStreamLSLSpliterator): Spliterator_OfLong
    {
        val hi: int = _getFence();
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        if (lo >= mid)
            result = null;
        else
            result = new LongStreamSpliteratorAutomaton(state = Initialized,
                parent = this.parent,
                index = lo,
                fence = mid,
                characteristics = this.characteristics,
            );

        this.index = mid;
    }


    fun *.forEachRemaining (@target self: LongStreamLSLSpliterator, _action: LongConsumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: array<long> = LongStreamAutomaton(this.parent).storage;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_LongConsumer_loop(i, a, _action)
        );
    }


    @Phantom proc forEachRemaining_LongConsumer_loop (i: int, a: array<int>, _action: LongConsumer): void
    {
        val item: long = a[i];
        action CALL(_action, [item]);
    }


    fun *.forEachRemaining (@target self: LongStreamLSLSpliterator, _action: Consumer): void
    {
        // #question Do we need such cheking like in original class ? "if (action instanceof LongConsumer)"

        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: array<long> = LongStreamAutomaton(this.parent).storage;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_LongConsumer_loop(i, a, _action)
        );
    }


    fun *.tryAdvance (@target self: LongStreamLSLSpliterator, _action: LongConsumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: array<long> = LongStreamAutomaton(this.parent).storage;
            val item: long = parentStorage[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.tryAdvance (@target self: LongStreamLSLSpliterator, _action: Consumer): boolean
    {
        // #question Do we need such cheking like in original class ? "if (action instanceof LongConsumer)"

        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: array<long> = LongStreamAutomaton(this.parent).storage;
            val item: long = parentStorage[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.estimateSize (@target self: LongStreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.getComparator (@target self: LongStreamLSLSpliterator): Comparator
    {
        if (_hasCharacteristics(SPLITERATOR_SORTED))
            result = null;
        else
            _throwISE();
    }


    fun *.getExactSizeIfKnown (@target self: LongStreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.hasCharacteristics (@target self: LongStreamLSLSpliterator, _characteristics: int): boolean
    {
        result = _hasCharacteristics(_characteristics);
    }
}