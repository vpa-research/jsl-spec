//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedList.java";

// imports

import java/util/LinkedList;


// automata

automaton LinkedList_SpliteratorAutomaton
(
    var parent: LinkedList
)
: LinkedList_Spliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,
    ];

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
            this.expectedModCount = LinkedListAutomaton(this.parent).modCount;
            this.fence = action LIST_SIZE(LinkedListAutomaton(this.parent).storage);
        }

        result = this.fence;
    }


    // constructors

    @private constructor *.`<init>` (@target self: LinkedList_Spliterator,
                                     _this: LinkedList,
                                     origin: int, fence: int, expectedModCount: int)
    {
        // #problem: translator cannot generate and refer to private and/or inner classes, so this is effectively useless
        action NOT_IMPLEMENTED("inaccessible constructor");
    }


    // static methods

    // methods

    fun *.characteristics (@target self: LinkedList_Spliterator): int
    {
        result = SPLITERATOR_ORDERED | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED;
    }


    fun *.estimateSize (@target self: LinkedList_Spliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.forEachRemaining (@target self: LinkedList_Spliterator, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: list<Object> = LinkedListAutomaton(this.parent).storage;
        if (a == null)
            _throwCME();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        if (hi == -1)
        {
            hi = action LIST_SIZE(a);
            mc = LinkedListAutomaton(this.parent).modCount;
        }

        var i: int = this.index;
        this.index = hi;
        if (i < 0 || hi > action LIST_SIZE(a))
            _throwCME();

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_loop(i, a, _action)
        );

        if (mc != LinkedListAutomaton(this.parent).modCount)
            _throwCME();
    }

    @Phantom proc forEachRemaining_loop (i: int, a: list<Object>, _action: Consumer): void
    {
        val item: Object = action LIST_GET(a, i);
        action CALL(_action, [item]);
    }


    // within java.util.Spliterator
    @Phantom fun *.getComparator (@target self: LinkedList_Spliterator): Comparator
    {
        // NOTE: using the original method
    }


    // within java.util.Spliterator
    fun *.getExactSizeIfKnown (@target self: LinkedList_Spliterator): long
    {
        result = _getFence() - this.index;
    }


    // within java.util.Spliterator
    @Phantom fun *.hasCharacteristics (@target self: LinkedList_Spliterator, characteristics: int): boolean
    {
        // NOTE: using the original method
    }


    fun *.tryAdvance (@target self: LinkedList_Spliterator, _action: Consumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            action ASSUME(this.parent != null);

            this.index = i + 1;

            val parentStorage: list<Object> = LinkedListAutomaton(this.parent).storage;
            val item: Object = action LIST_GET(parentStorage, i);
            action CALL(_action, [item]);

            if (LinkedListAutomaton(this.parent).modCount != this.expectedModCount)
                _throwCME();

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.trySplit (@target self: LinkedList_Spliterator): Spliterator
    {
        val hi: int = _getFence();
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        // JDK comment: divide range in half unless too small
        if (lo >= mid)
            result = null;
        else
            result = new LinkedList_SpliteratorAutomaton(state = Initialized,
                parent = this.parent,
                index = lo,
                fence = mid,
                expectedModCount = this.expectedModCount,
            );

        this.index = mid;
    }

}
