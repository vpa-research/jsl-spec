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
import java/util/function/IntConsumer;


// automata

automaton IntStreamSpliteratorAutomaton
(
    var parent: IntStreamLSL,
    var characteristics: int = 0,
    var fence: int = -1,
    var index: int = 0
)
: IntStreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining (IntStreamLSLSpliterator, IntConsumer),
       forEachRemaining (IntStreamLSLSpliterator, Consumer),
       tryAdvance (IntStreamLSLSpliterator, IntConsumer),
       tryAdvance (IntStreamLSLSpliterator, Consumer),
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
            this.fence = IntStreamAutomaton(this.parent).length;
        }
        result = this.fence;
    }


    proc _hasCharacteristics (_characteristics: int): boolean
    {
        result = (this.characteristics & _characteristics) == _characteristics;
    }


    // methods

    fun *.characteristics (@target self: IntStreamLSLSpliterator): int
    {
        result = this.characteristics;
    }


    fun *.trySplit (@target self: IntStreamLSLSpliterator): Spliterator_OfInt
    {
        val hi: int = _getFence();
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        if (lo >= mid)
            result = null;
        else
            result = new IntStreamSpliteratorAutomaton(state = Initialized,
                parent = this.parent,
                index = lo,
                fence = mid,
                characteristics = this.characteristics,
            );

        this.index = mid;
    }


    fun *.forEachRemaining (@target self: IntStreamLSLSpliterator, _action: IntConsumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: array<int> = IntStreamAutomaton(this.parent).storage;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_IntConsumer_loop(i, a, _action)
        );
    }


    @Phantom proc forEachRemaining_IntConsumer_loop (i: int, a: array<int>, _action: IntConsumer): void
    {
        val item: int = a[i];
        action CALL(_action, [item]);
    }


    fun *.forEachRemaining (@target self: IntStreamLSLSpliterator, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: array<int> = IntStreamAutomaton(this.parent).storage;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_Consumer_loop(i, a, _action)
        );
    }


    @Phantom proc forEachRemaining_Consumer_loop (i: int, a: array<int>, _action: Consumer): void
    {
        val item: int = a[i];
        action CALL(_action, [item]);
    }


    fun *.tryAdvance (@target self: IntStreamLSLSpliterator, _action: IntConsumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: array<int> = IntStreamAutomaton(this.parent).storage;
            val item: int = parentStorage[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.tryAdvance (@target self: IntStreamLSLSpliterator, _action: Consumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: array<int> = IntStreamAutomaton(this.parent).storage;
            val item: int = parentStorage[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.estimateSize (@target self: IntStreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.getComparator (@target self: IntStreamLSLSpliterator): Comparator
    {
        if (_hasCharacteristics(SPLITERATOR_SORTED))
            result = null;
        else
            _throwISE();
    }


    fun *.getExactSizeIfKnown (@target self: IntStreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.hasCharacteristics (@target self: IntStreamLSLSpliterator, _characteristics: int): boolean
    {
        result = _hasCharacteristics(_characteristics);
    }
}