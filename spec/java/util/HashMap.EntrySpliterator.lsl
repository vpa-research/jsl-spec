libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java#L1711";

// imports

import java/lang/Object;
import java/util/Comparator;
import java/util/Spliterator;
import java/util/function/Consumer;

import java/util/HashMap;


// automata

automaton HashMap_EntrySpliteratorAutomaton
(
    var parent: HashMap,
    var entryStorage: array<Map_Entry<Object, Object>>
)
: HashMap_EntrySpliterator
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
    var est: int = 0;
    var expectedModCount: int = 0;


    // utilities

    proc _getFence (): int
    {
        action ASSUME(this.parent != null);

        if (this.fence < 0)
        {
            val storageSize: int = action ARRAY_SIZE(this.entryStorage);
            this.est = storageSize;
            this.fence = storageSize;
            this.expectedModCount = HashMapAutomaton(this.parent).modCount;
        }
        result = this.fence;
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _checkForComodification (): void
    {
        if (this.expectedModCount != HashMapAutomaton(this.parent).modCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // constructors

    // static methods

    // methods

    fun *.characteristics (@target self: HashMap_EntrySpliterator): int
    {
        if (this.fence < 0 || this.est == action ARRAY_SIZE(this.entryStorage))
            result = SPLITERATOR_SIZED | SPLITERATOR_DISTINCT;
        else
            result = SPLITERATOR_DISTINCT;
    }


    // within java.util.HashMap.HashMapSpliterator
    @final fun *.estimateSize (@target self: HashMap_EntrySpliterator): long
    {
        _getFence();
        result = this.est as long;
    }


    fun *.forEachRemaining (@target self: HashMap_EntrySpliterator, userAction: Consumer): void
    {
        if(userAction == null)
            _throwNPE();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        var i: int = this.index;
        val storageSize: int = action ARRAY_SIZE(this.entryStorage);

        if(hi < 0)
        {
            mc = HashMapAutomaton(this.parent).modCount;
            this.expectedModCount = mc;
            this.fence = storageSize;
            hi = storageSize;
        }

        this.index = hi;

        if (storageSize > 0 && storageSize >= hi && i >= 0 && i < this.index)
        {
            action LOOP_WHILE(
                i < hi,
                forEachRemaining_loop(userAction, i)
            );

            if (HashMapAutomaton(this.parent).modCount != mc)
                action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int): void
    {
        var entry: Map_Entry<Object, Object> = this.entryStorage[i];
        action CALL(userAction, [entry]);
        i += 1;
    }


    // within java.util.Spliterator
    @Phantom fun *.getComparator (@target self: HashMap_EntrySpliterator): Comparator
    {
        // NOTE: using the original method
    }


    // within java.util.Spliterator
    fun *.getExactSizeIfKnown (@target self: HashMap_EntrySpliterator): long
    {
        result = _getFence() - this.index;
    }


    // within java.util.Spliterator
    @Phantom fun *.hasCharacteristics (@target self: HashMap_EntrySpliterator, characteristics: int): boolean
    {
        // NOTE: using the original method
    }


    fun *.tryAdvance (@target self: HashMap_EntrySpliterator, userAction: Consumer): boolean
    {
        if(userAction == null)
            _throwNPE();

        var hi: int = _getFence();
        var i: int = this.index;

        if(i < hi)
        {
            this.index = i + 1;

            action CALL(userAction, [this.entryStorage[i]]);

            _checkForComodification();

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.trySplit (@target self: HashMap_EntrySpliterator): Spliterator
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

            result = new HashMap_EntrySpliteratorAutomaton(state = Initialized,
                entryStorage = this.entryStorage,
                index = lo,
                fence = mid,
                est = this.est,
                expectedModCount = this.expectedModCount,
                parent = this.parent
            );
        }
    }

}
