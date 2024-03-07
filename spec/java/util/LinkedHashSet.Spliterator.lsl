//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedHashSet.java";

// imports

import java/util/LinkedHashSet;
import java/lang/Object;
import java/util/HashMap;
import java/util/function/Consumer;


// automata

automaton LinkedHashSet_KeySpliteratorAutomaton
(
    var keysStorage: array<Object>,
    var index: int,
    var fence: int,
    var est: int,
    var expectedModCount: int,
    var parent: LinkedHashSet
)
: LinkedHashSet_KeySpliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`
    ];

    shift Initialized -> self by [
        // read operations
        characteristics,
        trySplit,
        estimateSize,

        // write operations
        forEachRemaining,
        tryAdvance,
    ];


    // utilities

    proc _getFence(): int
    {
        action ASSUME(this.parent != null);

        var hi: int = this.fence;
        if (hi < 0)
        {
            val parentStorage: map<Object, Object> = LinkedHashSetAutomaton(this.parent).storage;
            this.est = action MAP_SIZE(parentStorage);
            this.expectedModCount = LinkedHashSetAutomaton(this.parent).modCount;
            this.fence = this.est;
            // That's right ?
            // Original code: "hi = fence = (tab == null) ? 0 : tab.length;"
            hi = this.fence;
        }
        result = hi;
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _checkForComodification (): void
    {
        val modCount: int = LinkedHashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // constructors

    @private constructor *.`<init>` (@target self: LinkedHashSet_KeySpliterator, source: HashMap, origin: int, fence: int, est: int, expectedModCount: int)
    {
        this.index = origin;
        this.fence = fence;
        this.est = est;
        this.expectedModCount = expectedModCount;
    }


    // methods

    fun *.estimateSize (@target self: LinkedHashSet_KeySpliterator): long
    {
        _getFence();
        result = this.est as long;
    }


    fun *.characteristics (@target self: LinkedHashSet_KeySpliterator): int
    {
        action ASSUME(this.parent != null);

        val parentStorage: map<Object, Object> = LinkedHashSetAutomaton(this.parent).storage;

        result = 0;
        if (this.fence < 0 || this.est == action MAP_SIZE(parentStorage))
            result = SPLITERATOR_SIZED;

        result |= SPLITERATOR_DISTINCT;
    }


    fun *.forEachRemaining (@target self: LinkedHashSet_KeySpliterator, userAction: Consumer): void
    {
        action ASSUME(this.parent != null);

        if(userAction == null)
            _throwNPE();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        var i: int = this.index;

        val parentStorage: map<Object, Object> = LinkedHashSetAutomaton(this.parent).storage;
        val length: int = action MAP_SIZE(parentStorage);

        if(hi < 0)
        {
            this.expectedModCount = LinkedHashSetAutomaton(this.parent).modCount;
            mc = this.expectedModCount;
            this.fence = length;
            hi = this.fence;
        }

        this.index = hi;
        if (length > 0 && length >= hi && i >= 0 && i < this.index)
        {
            val storage: array<Object> = this.keysStorage;
            action ASSUME(storage != null);
            action LOOP_WHILE(
                i < hi,
                forEachRemaining_loop(userAction, i, storage)
            );

            val modCount: int = LinkedHashSetAutomaton(this.parent).modCount;
            if (modCount != mc)
                action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int, storage: array<Object>): void
    {
        val key: Object = storage[i];
        action CALL(userAction, [key]);
        i += 1;
    }


    fun *.tryAdvance (@target self: LinkedHashSet_KeySpliterator, userAction: Consumer): boolean
    {
        action ASSUME(this.parent != null);

        if(userAction == null)
            _throwNPE();

        var hi: int = _getFence();
        var i: int = this.index;

        if(i < hi)
        {
            val key: Object = this.keysStorage[i];
            action CALL(userAction, [key]);

            this.index += 1;
            _checkForComodification();
            result = true;
        }

        result = false;
    }


    fun *.trySplit (@target self: LinkedHashSet_KeySpliterator): Spliterator
    {
        action ASSUME(this.parent != null);

        val hi: int = _getFence();
        val lo: int = this.index;

        var mid: int = (hi + lo) >>> 1;

        if (lo >= mid)
        {
            result = null;
        }
        else
        {
            this.est = this.est >>> 1;

            this.index = mid;

            result = new LinkedHashSet_KeySpliteratorAutomaton(state = Initialized,
                keysStorage = this.keysStorage,
                index = lo,
                fence = mid,
                est = this.est,
                expectedModCount = this.expectedModCount,
                parent = this.parent
            );
        }
    }

}