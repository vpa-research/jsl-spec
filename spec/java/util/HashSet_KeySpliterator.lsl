libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import java-common.lsl;
import java/util/_interfaces;
import "java/util/HashMap.lsl";
import "java/util/function/_interfaces.lsl";

import "list-actions.lsl";


@GenerateMe
// Problem: inner class extends
@extends("java.util.HashMap$HashMapSpliterator")
@implements("java.util.Spliterator")
@public @static @final type HashSet_KeySpliterator
    is java.util.HashSet_KeySpliterator
    for Spliterator
{
}


// automata

automaton HashSet_KeySpliteratorAutomaton
(
    var index: int;
    var fence: int;
    var est: int;
    var expectedModCount: int;
    var parent: HashSet;
)
: HashSet_KeySpliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashSet_KeySpliterator (HashSet_KeySpliterator, HashMap, int, int, int, int),
    ]

    shift Initialized -> this by [
        // read operations
        characteristics,
        trySplit,

        // write operations
        forEachRemaining,
        tryAdvance,
    ];


    // constructors

    constructor *.HashSet_KeySpliterator (@target self: HashSet_KeySpliterator, source: HashMap, origin: int, fence: int, est: int, expectedModCount: int)
    {
        action TODO();
    }


    // utilities

    proc _getFence(): int
    {
        action ASSUME(this.parent != null);

        var hi: int = this.fence;
        if (hi < 0)
        {
            val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
            this.est = action MAP_SIZE(parentStorage);
            this.expectedModCount = HashSetAutomaton(this.parent).modCount;
            this.fence = this.est;
            // That's right ?
            // Original code: "hi = fence = (tab == null) ? 0 : tab.length;"
            hi = this.fence;
        }
        result = hi;
    }

    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }

    proc _checkForComodification (): void
    {
        val modCount: int = HashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

    proc _loop_body_tryAdvance (userAction: Consumer): void
    {
        val key: Object = action SYMBOLIC("java.lang.Object");
        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        val sourceStorageHasKey: bool = action MAP_HAS_KEY(parentStorage, key);
        action ASSUME(sourceStorageHasKey);

        action CALL(consumer, [key]);

        _checkForComodification();
        this.index += 1;
    }

    // static methods

    // methods

    fun *.estimateSize (@target self: HashSet_KeySpliterator): long
    {
        _getFence();
        // Problem:
        // In original class we have such construction: "return (long) est;"; Can we convert int to long ?
        // Or we must write something in such style:
        // "var r: long = est;
        // result  = r;"
    }

    fun *.characteristics (@target self: HashSet_KeySpliterator): int
    {
        action ASSUME(this.parent != null);

        var mask: int = 0;
        val length: int = HashSetAutomaton(this.parent).length;
        if (this.fence < 0 || this.est == length)
        {
            // Can we write such literals '0x00000040' ?
            mask = 0x00000040;
        }
        result = mask | 0x00000001;
    }


    fun *.forEachRemaining (@target self: HashSet_KeySpliterator, userAction: Consumer): void
    {
        action TODO();
    }


    fun *.tryAdvance (@target self: HashSet_KeySpliterator, userAction: Consumer): boolean
    {
        action ASSUME(this.parent != null);

        if(act == null)
            _throwNPE();

        var hi: int = _getFence();
        val length: int = HashSetAutomaton(this.parent).length;

        if(length >= hi && this.index >= 0)
        {
            action LOOP_WHILE(this.index < hi, _loop_body_tryAdvance(act));
        }

        result = false;
    }


    fun *.trySplit (@target self: HashSet_KeySpliterator): HashSet_KeySpliterator
    {
        action ASSUME(this.parent != null);

        val hi: int = _getFence();
        val lo: int = this.index;

        // We don't have such operator in LibSL: ">>>"
        // it bottom this is right realization of such code: "mid = (lo + hi) >>> 1"

        var mid: int = (hi + lo) >> 1;
        if (mid < 0)
        {
            mid = mid * (-1);
        }

        if (lo >= mid)
        {
            result = null;
        }
        else
        {
            val newEst: int = this.est >> 1;
            if (newEst < 0)
            {
                newEst = newEst * (-1);
            }
            this.index = mid;

            result = new KeySpliteratorAutomaton(state = Initialized,
                index = lo,
                fence = mid,
                est = newEst,
                expectedModCount = this.expectedModCount,
                parent = this.parent;
            );
        }
    }

}