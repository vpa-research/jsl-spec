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
import java/util/function/DoubleConsumer;


// automata

automaton DoubleStreamSpliteratorAutomaton
(
    var parent: DoubleStreamLSL,
    var characteristics: int = 0,
    var fence: int = -1,
    var index: int = 0
)
: DoubleStreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining (DoubleStreamLSLSpliterator, DoubleConsumer),
       forEachRemaining (DoubleStreamLSLSpliterator, Consumer),
       tryAdvance (DoubleStreamLSLSpliterator, DoubleConsumer),
       tryAdvance (DoubleStreamLSLSpliterator, Consumer),
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
            this.fence = DoubleStreamAutomaton(this.parent).length;
        }
        result = this.fence;
    }


    proc _hasCharacteristics (_characteristics: int): boolean
    {
        result = (this.characteristics & _characteristics) == _characteristics;
    }


    // methods

    fun *.characteristics (@target self: DoubleStreamLSLSpliterator): int
    {
        result = this.characteristics;
    }


    fun *.trySplit (@target self: DoubleStreamLSLSpliterator): Spliterator_OfDouble
    {
        val hi: int = _getFence();
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        if (lo >= mid)
            result = null;
        else
            result = new DoubleStreamSpliteratorAutomaton(state = Initialized,
                parent = this.parent,
                index = lo,
                fence = mid,
                characteristics = this.characteristics,
            );

        this.index = mid;
    }


    fun *.forEachRemaining (@target self: DoubleStreamLSLSpliterator, _action: DoubleConsumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: array<double> = DoubleStreamAutomaton(this.parent).storage;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_IntConsumer_loop(i, a, _action)
        );
    }


    @Phantom proc forEachRemaining_IntConsumer_loop (i: int, a: array<double>, _action: DoubleConsumer): void
    {
        val item: double = a[i];
        action CALL(_action, [item]);
    }


    fun *.forEachRemaining (@target self: DoubleStreamLSLSpliterator, _action: Consumer): void
    {
        // #question Do we need such cheking like in original class ? "if (action instanceof DoubleConsumer)"

        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: array<double> = DoubleStreamAutomaton(this.parent).storage;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_IntConsumer_loop(i, a, _action)
        );
    }


    fun *.tryAdvance (@target self: DoubleStreamLSLSpliterator, _action: DoubleConsumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: array<double> = DoubleStreamAutomaton(this.parent).storage;
            val item: double = parentStorage[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.tryAdvance (@target self: DoubleStreamLSLSpliterator, _action: Consumer): boolean
    {
        // #question Do we need such cheking like in original class ? "if (action instanceof DoubleConsumer)"

        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: array<double> = DoubleStreamAutomaton(this.parent).storage;
            val item: double = parentStorage[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.estimateSize (@target self: DoubleStreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.getComparator (@target self: DoubleStreamLSLSpliterator): Comparator
    {
        if (_hasCharacteristics(SPLITERATOR_SORTED))
            result = null;
        else
            _throwISE();
    }


    fun *.getExactSizeIfKnown (@target self: DoubleStreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.hasCharacteristics (@target self: DoubleStreamLSLSpliterator, _characteristics: int): boolean
    {
        result = _hasCharacteristics(_characteristics);
    }
}