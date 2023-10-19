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


// automata

automaton StreamSpliteratorAutomaton
(
    var parent: StreamLSL,
    var characteristics: int = 0,
    var fence: int = -1,
    var index: int = 0
)
: StreamLSLSpliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       characteristics,
       trySplit,
       forEachRemaining,
       tryAdvance,
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
            this.fence = StreamAutomaton(this.parent).length;
        }
        result = this.fence;
    }


    proc _hasCharacteristics (_characteristics: int): boolean
    {
        result = (this.characteristics & _characteristics) == _characteristics;
    }


    // methods

    fun *.characteristics (@target self: StreamLSLSpliterator): int
    {
        result = this.characteristics;
    }


    fun *.trySplit (@target self: StreamLSLSpliterator): Spliterator
    {
        val hi: int = _getFence();
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        if (lo >= mid)
            result = null;
        else
            result = new StreamSpliteratorAutomaton(state = Initialized,
                parent = this.parent,
                index = lo,
                fence = mid,
                characteristics = this.characteristics,
            );

        this.index = mid;
    }


    fun *.forEachRemaining (@target self: StreamLSLSpliterator, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: array<Object> = StreamAutomaton(this.parent).storage;

        var hi: int = this.fence;
        var i: int = this.index;
        this.index = hi;

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_loop(i, a, _action)
        );
    }


    @Phantom proc forEachRemaining_loop (i: int, a: array<Object>, _action: Consumer): void
    {
        val item: Object = a[i];
        action CALL(_action, [item]);
    }


    fun *.tryAdvance (@target self: StreamLSLSpliterator, _action: Consumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: array<Object> = StreamAutomaton(this.parent).storage;
            val item: Object = parentStorage[i];
            action CALL(_action, [item]);

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.estimateSize (@target self: StreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    // #note - realization of tis method was from class: "Spliterators.ArraySpliterator"; This is right ?
    fun *.getComparator (@target self: StreamLSLSpliterator): Comparator
    {
        if (_hasCharacteristics(SPLITERATOR_SORTED))
            result = null;
        else
            _throwISE();
    }


    fun *.getExactSizeIfKnown (@target self: StreamLSLSpliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.hasCharacteristics (@target self: StreamLSLSpliterator, _characteristics: int): boolean
    {
        result = _hasCharacteristics(_characteristics);
    }
}