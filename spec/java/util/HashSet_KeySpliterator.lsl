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


// local semantic types

@GenerateMe
// Problem: inner class extends
@extends("java.util.HashMap$HashMapSpliterator")
@implements("java.util.Spliterator")
@public @static @final type HashSet_KeySpliterator
    is java.util.HashSet_KeySpliterator
    for Spliterator
{
}


// === CONSTANTS ===

val HASHSET_KEYITERATOR_VALUE: Object = 0;


// automata

automaton HashSet_KeySpliteratorAutomaton
(
    var keysStorage: list<Object>;
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
        HashSet_KeySpliterator,
    ]

    shift Initialized -> this by [
        // read operations
        characteristics,
        trySplit,
        estimateSize,

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
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // methods

    fun *.estimateSize (@target self: HashSet_KeySpliterator): long
    {
        _getFence();
        result = this.est as long;
    }


    fun *.characteristics (@target self: HashSet_KeySpliterator): int
    {
        action ASSUME(this.parent != null);

        var mask: int = 0;
        val length: int = HashSetAutomaton(this.parent).length;
        if (this.fence < 0 || this.est == length)
            mask = 64;

        result = mask | 1;
    }


    fun *.forEachRemaining (@target self: HashSet_KeySpliterator, userAction: Consumer): void
    {
        action ASSUME(this.parent != null);

        if(userAction == null)
            _throwNPE();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        var i: int = this.index;
        val length: int = HashSetAutomaton(this.parent).length;

        if(hi < 0)
        {
            this.expectedModCount = HashSetAutomaton(this.parent).modCount;
            mc = this.expectedModCount;
            // problem
            // How correctly write such string "hi = fence = (tab == null) ? 0 : tab.length;"
            // As I see this condition "tab == null" we mustn't check, because we don't have "map.table" field;
            this.fence = length;
            hi = this.fence
        }

        // Original condition: "if (tab != null && tab.length >= hi && (i = index) >= 0 && (i < (index = hi) || current != null))"
        // This is correct this condition translation ?
        this.index = hi;
        if (length > 0 && length >= hi && i >= 0 && i < this.index)
        {
            // I must think about this:
            action LOOP_WHILE(i < hi, forEachRemaining_loop(userAction, i));

            val modCount: int = HashSetAutomaton(this.parent).modCount;
            if (modCount != mc)
                action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int): boolean
    {
        val key: Object = action LIST_GET(this.keysStorage, this.index);
        action CALL(consumer, [key]);
        i += 1;
    }


    fun *.tryAdvance (@target self: HashSet_KeySpliterator, userAction: Consumer): boolean
    {
        action ASSUME(this.parent != null);

        if(userAction == null)
            _throwNPE();

        var hi: int = _getFence();
        val length: int = HashSetAutomaton(this.parent).length;

        // this is correct condition ? It is enough ?
        if(length >= hi && this.index >= 0)
        {
            val key: Object = action LIST_GET(this.keysStorage, this.index);
            action CALL(consumer, [key]);

            this.index += 1;
            _checkForComodification();
            result = true;
        }

        result = false;
    }


    fun *.trySplit (@target self: HashSet_KeySpliterator): HashSet_KeySpliterator
    {
        action ASSUME(this.parent != null);

        val hi: int = _getFence();
        val lo: int = this.index;

        var mid: int = (hi + lo) >>> 1;

        if (lo >= mid)
            result = null;
        else
        {
            this.est = this.est >>> 1;

            this.index = mid;

            result = new KeySpliteratorAutomaton(state = Initialized,
                visitedKeys = this.visitedKeys,
                index = lo,
                fence = mid,
                est = this.est,
                expectedModCount = this.expectedModCount,
                parent = this.parent;
            );
        }
    }

}