//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java/util/ArrayList;


// automata

automaton ArrayList_SubList_SpliteratorAutomaton
(
    var root: ArrayList,
    var parent: ArrayList_SubList,
)
: ArrayList_SubList_Spliterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        characteristics,
        estimateSize,
        forEachRemaining,
        getComparator,
        getExactSizeIfKnown,
        hasCharacteristics,
        tryAdvance,
        trySplit,
    ];

    // internal variables

    var index: int = 0;
    var fence: int = -1;
    var expectedModCount: int = 0;


    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwCME (): void
    {
        action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    proc _getFence (): int
    {
        // JDK comment: initialize fence to size on first use
        if (this.fence == -1)
        {
            action ASSUME(this.parent != null);
            this.expectedModCount = ArrayList_SubListAutomaton(this.parent).modCount;
            this.fence = ArrayList_SubListAutomaton(this.parent).length;
        }

        result = this.fence;
    }


    // constructors

    // static methods

    // methods

    fun *.characteristics (@target self: ArrayList_SubList_Spliterator): int
    {
        result = SPLITERATOR_ORDERED | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED;
    }


    fun *.estimateSize (@target self: ArrayList_SubList_Spliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.forEachRemaining (@target self: ArrayList_SubList_Spliterator, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.root != null);
        action ASSUME(this.parent != null);

        val a: list<Object> = ArrayListAutomaton(this.root).storage;
        if (a == null)
            _throwCME();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        if (hi == -1)
        {
            hi = ArrayList_SubListAutomaton(this.parent).length;
            mc = ArrayList_SubListAutomaton(this.parent).modCount;
        }

        var i: int = this.index;
        this.index = hi;
        if (i < 0 || hi > ArrayList_SubListAutomaton(this.parent).length)
            _throwCME();

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_loop(i, a, _action)
        );

        if (mc != ArrayList_SubListAutomaton(this.parent).modCount)
            _throwCME();
    }

    @Phantom proc forEachRemaining_loop (i: int, a: list<Object>, _action: Consumer): void
    {
        val item: Object = action LIST_GET(a, i);
        action CALL(_action, [item]);
    }


    // within java.util.Spliterator
    @Phantom fun *.getComparator (@target self: ArrayList_SubList_Spliterator): Comparator
    {
        // NOTE: using the original method
    }


    // within java.util.Spliterator
    fun *.getExactSizeIfKnown (@target self: ArrayList_SubList_Spliterator): long
    {
        result = _getFence() - this.index;
    }


    // within java.util.Spliterator
    @Phantom fun *.hasCharacteristics (@target self: ArrayList_SubList_Spliterator, characteristics: int): boolean
    {
        // NOTE: using the original method
    }


    fun *.tryAdvance (@target self: ArrayList_SubList_Spliterator, _action: Consumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.root != null);

            this.index = i + 1;

            val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;
            val item: Object = action LIST_GET(rootStorage, i);
            action CALL(_action, [item]);

            if (ArrayListAutomaton(this.root).modCount != this.expectedModCount)
                _throwCME();

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.trySplit (@target self: ArrayList_SubList_Spliterator): Spliterator
    {
        val hi: int = _getFence();
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        // JDK comment: divide range in half unless too small
        if (lo >= mid)
            result = null;
        else
            result = new ArrayList_SubList_SpliteratorAutomaton(state = Initialized,
                root = this.root,
                parent = this.parent,
                index = lo,
                fence = mid,
                expectedModCount = this.expectedModCount,
            );

        this.index = mid;
    }

}
