libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$ValueSpliterator.java";

// imports

import java/lang/Object;
import java/util/Comparator;
import java/util/HashMap;
import java/util/Spliterator;
import java/util/function/Consumer;


// automata

automaton HashMap_ValueSpliteratorAutomaton
(
    var valuesStorage: array<Object>,
    var parent: HashMap
)
: HashMap_ValueSpliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMap_ValueSpliterator,
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
    var est: int = 0;
    var expectedModCount: int = 0;


    // utilities


    proc _getFence (): int
    {
        action ASSUME(this.parent != null);

        if (this.fence < 0)
        {
            val storageSize: int = action ARRAY_SIZE(this.valuesStorage);
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


    proc _checkForComodification (): void
    {
        val modCount: int = HashMapAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // constructors

    @private constructor *.HashMap_ValueSpliterator (@target self: HashMap_ValueSpliterator, m: HashMap, origin: int, fence: int, est: int, expectedModCount: int)
    {
        this.index = origin;
        this.fence = fence;
        this.est = est;
        this.expectedModCount = expectedModCount;
    }


    // static methods

    // methods

    fun *.characteristics (@target self: HashMap_ValueSpliterator): int
    {
        if (this.fence < 0 || this.est == action ARRAY_SIZE(this.valuesStorage))
            result = SPLITERATOR_SIZED;
        else
            result = 0;
    }


    // within java.util.HashMap.HashMapSpliterator
    @final fun *.estimateSize (@target self: HashMap_ValueSpliterator): long
    {
        _getFence();
        result = this.est as long;
    }


    fun *.forEachRemaining (@target self: HashMap_ValueSpliterator, userAction: Consumer): void
    {
        if(userAction == null)
            _throwNPE();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        var i: int = this.index;
        val storageSize: int = action ARRAY_SIZE(this.valuesStorage);

        if(hi < 0)
        {
            this.expectedModCount = HashMapAutomaton(this.parent).modCount;
            mc = this.expectedModCount;
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

            val modCount: int = HashMapAutomaton(this.parent).modCount;
            if (modCount != mc)
                action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int): void
    {
        var value: Object = this.valuesStorage[i];
        action CALL(userAction, [value]);
        i += 1;
    }


    // within java.util.Spliterator
    @Phantom fun *.getComparator (@target self: HashMap_ValueSpliterator): Comparator
    {
        // NOTE: using the original method
    }


    // within java.util.Spliterator
    fun *.getExactSizeIfKnown (@target self: HashMap_ValueSpliterator): long
    {
        result = _getFence() - this.index;
    }


    // within java.util.Spliterator
    @Phantom fun *.hasCharacteristics (@target self: HashMap_ValueSpliterator, characteristics: int): boolean
    {
        // NOTE: using the original method
    }


    fun *.tryAdvance (@target self: HashMap_ValueSpliterator, userAction: Consumer): boolean
    {
        if(userAction == null)
            _throwNPE();

        var hi: int = _getFence();
        var i: int = this.index;

        if(i < hi)
        {
            var value: Object = this.valuesStorage[i];
            action CALL(userAction, [value]);
            this.index += 1;
            _checkForComodification();
            result = true;
        }

        result = false;
    }


    fun *.trySplit (@target self: HashMap_ValueSpliterator): HashMap_ValueSpliterator
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

            result = new HashMap_ValueSpliteratorAutomaton(state = Initialized,
                valuesStorage = this.valuesStorage,
                index = lo,
                fence = mid,
                est = this.est,
                expectedModCount = this.expectedModCount,
                parent = this.parent
            );
        }
    }

}