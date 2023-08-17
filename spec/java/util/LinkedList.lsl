///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedList.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/io/_interfaces;
import java/util/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// local semantic types

@Parameterized(["E"])
@extends("java.util.AbstractSequentialList")
@implements("java.util.List")
@implements("java.util.Deque")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type LinkedList
    is java.util.LinkedList
    for List, Deque
{
    // #problem: should be 876323262645176354 instead
    @private @static val serialVersionUID: long = 1;
}


// automata

automaton LinkedListAutomaton
(
    var storage: list<Object>,
    @transient var size: int
)
: LinkedList
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        LinkedList(LinkedList),
        LinkedList(LinkedList, Collection)
    ];

    shift Initialized -> self by [
        // read operations
        getFirst,
        getLast,
        contains,
        size,
        get,
        indexOf(LinkedList, Object),
        indexOf(LinkedList, int),
        lastIndexOf,
        peek,
        element,
        peekFirst,
        peekLast,
        toArray,
        forEach,
        spliterator,
        listIterator,

        toString,
        hashCode,
        clone,

        // write operations
        removeFirst,
        removeLast,
        addFirst,
        addLast,
        add(LinkedList, Object),
        add(LinkedList, int, Object),
        remove(LinkedList),
        remove(LinkedList, int),
        remove(LinkedList, Object),
        addAll(LinkedList, Collection),
        addAll(LinkedList, int, Collection),
        clear,
        set,
        poll,
        offer,
        offerFirst,
        offerLast,
        pollFirst,
        pollLast,
        push,
        pop,
        removeFirstOccurrence,
        removeLastOccurrence,
    ];


    // automaton instance-specific local variables

    @transient var modCount: int = 0;


    // subroutines

    proc _unlinkAny (index: int): Object
    {
        result = action LIST_GET(this.storage, index);
        action LIST_REMOVE(this.storage, index, 1);

        this.size -= 1;
        this.modCount += 1;
    }


    proc _linkAny (index: int, e: Object): void
    {
        action LIST_INSERT_AT(this.storage, index, e);

        this.size += 1;
        this.modCount += 1;
    }


    proc _checkElementIndex (index: int): void
    {
        if (!_isValidIndex(index))
        {
            val message: String =
                "Index: " + action OBJECT_TO_STRING(index) +
                ", Size: " + action OBJECT_TO_STRING(this.size);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _isValidIndex (index: int): boolean
    {
        result = 0 <= index && index < this.size;
    }


    proc _isPositionIndex (index: int): boolean
    {
        result = 0 <= index && index <= this.size;
    }


    proc _checkPositionIndex (index: int): void
    {
        if (!_isPositionIndex(index))
        {
            val message: String =
                "Index: " + action OBJECT_TO_STRING(index) +
                ", Size: " + action OBJECT_TO_STRING(this.size);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _unlinkFirst (): Object
    {
        if (this.size == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = _unlinkAny(0);
    }


    proc _unlinkByFirstEqualsObject (o: Object): boolean
    {
        val index: int = action LIST_FIND(this.storage, o, 0, this.size);

        result = index >= 0;
        if (result)
        {
            action LIST_REMOVE(this.storage, index);

            this.size -= 1;
            this.modCount += 1;
        }
    }


    proc _addAllElements (index: int, @Parameterized(["E"]) c: Collection): boolean
    {
        // #todo: add optimized version when 'C' is this automaton (HAS operator is required)

        val iter: Iterator = action CALL_METHOD(c, "iterator", []);
        result = action CALL_METHOD(iter, "hasNext", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _addAllElements_loop(iter, index)
        );

        this.modCount += 1;
    }

    @Phantom proc _addAllElements_loop (iter: Iterator, index: int): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        action LIST_INSERT_AT(this.storage, index, item);

        index += 1;
        this.size += 1;
    }


    proc _getFirstElement (): Object
    {
        if (this.size == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = action LIST_GET(this.storage, 0);
    }


    // constructors

    constructor *.LinkedList (@target self: LinkedList)
    {
        this.storage = action LIST_NEW();
        this.size = 0;
    }


    constructor *.LinkedList (@target self: LinkedList, @Parameterized(["E"]) c: Collection)
    {
        if (c == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        this.storage = action LIST_NEW();
        this.size = 0;

        _addAllElements(this.size, c);
    }


    // methods

    fun *.getFirst (@target self: LinkedList): Object
    {
        result = _getFirstElement();
    }


    fun *.getLast (@target self: LinkedList): Object
    {
        if (this.size == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = action LIST_GET(this.storage, this.size - 1);
    }


    fun *.removeFirst (@target self: LinkedList): Object
    {
        result = _unlinkFirst();
    }


    fun *.removeLast (@target self: LinkedList): Object
    {
        if (this.size == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = _unlinkAny(this.size - 1);
    }


    fun *.addFirst (@target self: LinkedList, e: Object): void
    {
        _linkAny(0, e);
    }


    fun *.addLast (@target self: LinkedList, e: Object): void
    {
        _linkAny(this.size, e);
    }


    fun *.contains (@target self: LinkedList, o: Object): boolean
    {
        result = action LIST_FIND(this.storage, o, 0, this.size) >= 0;
    }


    fun *.size (@target self: LinkedList): int
    {
        result = this.size;
    }


    fun *.add (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(this.size, e);
        result = true;
    }


    fun *.remove (@target self: LinkedList, o: Object): boolean
    {
        result = _unlinkByFirstEqualsObject(o);
    }


    fun *.addAll (@target self: LinkedList, @Parameterized(["E"]) c: Collection): boolean
    {
        result = _addAllElements(this.size, c);
    }


    fun *.addAll (@target self: LinkedList, index: int, @Parameterized(["E"]) c: Collection): boolean
    {
        result = _addAllElements(index, c);
    }


    fun *.clear (@target self: LinkedList): void
    {
        this.storage = action LIST_NEW();
        this.size = 0;
        this.modCount += 1;
    }


    fun *.get (@target self: LinkedList, index: int): Object
    {
        _checkElementIndex(index);
        result = action LIST_GET(this.storage, index);
    }


    fun *.set (@target self: LinkedList, index: int, element: Object): Object
    {
        _checkElementIndex(index);
        action LIST_SET(this.storage, index, element);
        result = action LIST_GET(this.storage, index);
    }


    fun *.add (@target self: LinkedList, index: int, element: Object): void
    {
        _checkPositionIndex(index);
        _linkAny(index, element);
    }


    fun *.remove (@target self: LinkedList, index: int): Object
    {
        _checkElementIndex(index);
        result = _unlinkAny(index);
    }


    fun *.indexOf (@target self: LinkedList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, this.size);
    }


    fun *.lastIndexOf (@target self: LinkedList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, this.size);
        if (result != -1)
        {
            // there should be no elements to the right of the previously found position
            val nextIndex: int = result + 1;
            if (nextIndex < this.size)
            {
                val rightIndex: int = action LIST_FIND(this.storage, o, nextIndex, this.size);
                action ASSUME(rightIndex == -1);
            }
        }
    }


    fun *.peek (@target self: LinkedList): Object
    {
        if (this.size == 0)
            result = null;
        else
            result = action LIST_GET(this.storage, 0);
    }


    fun *.element (@target self: LinkedList): Object
    {
        result = _getFirstElement();
    }


    fun *.poll (@target self: LinkedList): Object
    {
        if (this.size == 0)
            result = null;
        else
            result = _unlinkAny(0);
    }


    fun *.remove (@target self: LinkedList): Object
    {
        result = _unlinkFirst();
    }


    fun *.offer (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(this.size, e);
        result = true;
    }


    fun *.offerFirst (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(0, e);
        result = true;
    }


    fun *.offerLast (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(this.size, e);
        result = true;
    }


    fun *.peekFirst (@target self: LinkedList): Object
    {
        if (this.size == 0)
            result = null;
        else
            result = action LIST_GET(this.storage, 0);
    }


    fun *.peekLast (@target self: LinkedList): Object
    {
        if (this.size == 0)
            result = null;
        else
            result = action LIST_GET(this.storage, this.size - 1);
    }


    fun *.pollFirst (@target self: LinkedList): Object
    {
        if (this.size == 0)
            result = null;
        else
            result = _unlinkAny(0);
    }


    fun *.pollLast (@target self: LinkedList): Object
    {
        if (this.size == 0)
            result = null;
        else
            result = _unlinkAny(this.size - 1);
    }


    fun *.push (@target self: LinkedList, e: Object): void
    {
        _linkAny(0, e);
    }


    fun *.pop (@target self: LinkedList): Object
    {
        result = _unlinkFirst();
    }


    fun *.removeFirstOccurrence (@target self: LinkedList, o: Object): boolean
    {
        result = _unlinkByFirstEqualsObject(o);
    }


    fun *.removeLastOccurrence (@target self: LinkedList, o: Object): boolean
    {
        val index: int = action LIST_FIND(this.storage, o, 0, this.size);
        if (index == -1)
        {
            result = false;
        }
        else
        {
            result = true;

            // there should be no elements to the right of the previously found position
            val nextIndex: int = index + 1;
            if (nextIndex < this.size)
            {
                val rightIndex: int = action LIST_FIND(this.storage, o, nextIndex, this.size);
                action ASSUME(rightIndex == -1);
            }

            // actual removal and associated modifications
            action LIST_REMOVE(this.storage, index);
            this.size -= 1;
            this.modCount += 1;
        }
    }


    fun *.toArray (@target self: LinkedList, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val length: int = this.size;
        var i: int = 0;

        if (aLen < length)
        {
            // #problem: a.getClass() should be called to construct a type-valid array (USVM issue)
            result = action ARRAY_NEW("java.lang.Object", length);

            action LOOP_FOR(
                i, 0, length, +1,
                toArray_loop(i) // result assignment is implicit
            );
        }
        else
        {
            result = a;

            action LOOP_FOR(
                i, 0, length, +1,
                toArray_loop(i) // result assignment is implicit
            );

            if (aLen > length)
                result[length] = null;
        }
    }

    @Phantom proc toArray_loop(i: int): array<Object>
    {
        result[i] = action LIST_GET(this.storage, i);
    }


    fun *.forEach (@target self: LinkedList, anAction: Consumer): void
    {
        if (anAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        val expectedModCount: int = this.modCount;
        val length: int = this.size;

        var i: int = 0;
        action LOOP_WHILE(
            this.modCount == expectedModCount && i < length,
            forEach_loop(i, anAction)
        );

        if (this.modCount != expectedModCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }

    @Phantom proc forEach_loop(i: int, anAction: Consumer): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        action CALL(anAction, [item]);

        i += 1;
    }


    fun *.spliterator (@target self: LinkedList): Spliterator
    {
        // #problem: not implemented
        /*
        result = new LLSpliterator(state=Initialized,
            parent = self,
            est = -1,
            expectedModCount = 0
        );
        */
        result = action SYMBOLIC("java.util.Spliterator");
        action ASSUME(result != null);
    }


    fun *.listIterator (@target self: LinkedList, index: int): ListIterator
    {
        _checkPositionIndex(index);

        // #problem: not implemented
        /*
        result = new ListItr(state = Created,
            expectedModCount = this.modCounter
        );
        */
        result = action SYMBOLIC("java.util.ListIterator");
        action ASSUME(result != null);
    }

    fun *.descendingIterator (@target self: LinkedList): Iterator
    {
        // #problem: not implemented
        /*
        result = new DescendingIterator(state = Created);
        */
        result = action SYMBOLIC("java.util.Iterator");
        action ASSUME(result != null);
    }


    fun *.clone (@target self: LinkedList): Object
    {
        val storageCopy: list<Object> = action LIST_NEW();
        action LIST_COPY(this.storage, storageCopy, 0, 0, this.size);

        result = new LinkedListAutomaton(state = Initialized,
            storage = storageCopy,
            size = this.size
        );
    }


    fun *.hashCode (@target self: LinkedList): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.toString (@target self: LinkedList): String
    {
        result = action OBJECT_TO_STRING(this.storage);
    }

}





/*
@Private
@Implements("java.util.ListIterator")
@WrapperMeta(
    src="java.util.ListItr",
    dst="org.utbot.engine.overrides.collections.UtListItr",
    matchInterfaces=true,
)
automaton ListItr: int(
    var index: int = 0,
    var expectedModCount: int,
    var nextWasCalled: boolean = false,
    var prevWasCalled: boolean = false
)
{
    initstate Initialized;

    // constructors
    shift Allocated -> Initialized by [
        ListItr(int)
    ];

    shift Initialized -> self by [
        // read operations
        hasNext,
        hasPrevious,
        nextIndex,
        previousIndex,

        // write operations
        next,
        remove,
        previous,
        set,
        add,
        forEachRemaining
    ];

    //constructors

    constructor ListItr (startIndex: int)
    {
        index = startIndex;
    }


    //methods

    fun *.hasNext (): boolean
    {
        result = index < self.parent.size;
    }


    fun *.next (): Object
    {
        checkForComodification();
        val atValidPosition = index < self.parent.length;

        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        result = action LIST_GET(self.parent.storage, index);
        index = index + 1;
        nextWasCalled = true;
        prevWasCalled = false;
    }


    fun *.hasPrevious (): boolean
    {
        result = index > 0;
    }


    fun *.previous (): Object
    {
        checkForComodification();
        val atValidPosition = index > 0;

        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        index = index - 1;
        result = action LIST_GET(self.parent.storage, index);
        prevWasCalled = true;
        nextWasCalled = false;
    }


    fun *.nextIndex (): int
    {
        result = index;
    }


    fun *.previousIndex (): int
    {
        result = index - 1;
    }


    fun *.remove (): void
    {
        checkForComodification();

        if (!nextWasCalled && !prevWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        if (nextWasCalled)
        {
            self.parent._unlinkAny(index - 1);
            nextWasCalled = false;
        }
        else
        {
            self.parent._unlinkAny(index);
            index = index - 1;
            prevWasCalled = false;
        }

        expectedModCount = expectedModCount + 1;
    }


    fun *.set (e: Object): void
    {
        if (!nextWasCalled && !prevWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        checkForComodification();

        if (nextWasCalled)
        {
            action LIST_SET(storage, index - 1, e);
        }
        else
        {
            action LIST_SET(storage, index, e);
        }
    }


    fun *.add (e: Object): void
    {
        checkForComodification();
        val hasNextPosition = index < self.parent.length;


        if (!hasNextPosition)
        {
            self.parent.linkAny(self.parent.size, e);
        }
        else
        {
            self.parent.linkAny(index, e);
        }

        nextWasCalled = false;
        prevWasCalled = false;

        index = index + 1;
        expectedModCount = expectedModCount + 1;
    }


    fun *.forEachRemaining (action: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }



    proc checkForComodification (): void
    {
        if (self.parent.modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

}
*/


/*
@Private
@Implements("java.util.Iterator")
@WrapperMeta(
    src="java.util.ListItr",
    dst="org.utbot.engine.overrides.collections.UtDescendingIterator",
    matchInterfaces=true,
)
automaton DescendingIterator: int(
    var index: int = 0,
    var expectedModCount: int,
    var nextWasCalled: boolean = false)
{

    initstate Initialized;

    shift Initialized -> self by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
        forEachRemaining
    ];


    fun *.next (): Object
    {
        checkForComodification();
        val atValidPosition = index > 0;

        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        index = index - 1;
        result = action LIST_GET(self.parent.storage, index);
        nextWasCalled = true;
    }


    fun *.hasNext (): boolean
    {
        result = index > 0;
    }


    fun *.remove (): void
    {
        checkForComodification();

        if (!nextWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        self.parent._unlinkAny(index);
        index = index - 1;
        nextWasCalled = false;

        expectedModCount = expectedModCount + 1;
    }


    fun *.forEachRemaining (action: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    proc checkForComodification (): void
    {
        if (self.parent.modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

}
*/



/*
@Private
@Implements("java.util.Spliterator")
@WrapperMeta(
    src="java.util.ListItr",
    dst="org.utbot.engine.overrides.collections.UtLLSpliterator",
    matchInterfaces=true,
)
automaton LLSpliterator: int(
    @Final var BATCH_UNIT: int = 1 << 10,
    @Final var MAX_BATCH: int = 1 << 25,
    @Final var list: LinkedList,
    est: int,
    expectedModCount: int,
    batch: int
)
{

    //constructors

    constructor LLSpliterator (list: LinkedList, est: int, expectedModCount: int)
    {
        action NOT_IMPLEMENTED();
    }

    //sub's

    proc getEst (): int
    {
        action NOT_IMPLEMENTED();
    }

    //methods

    fun *.estimateSize (): long
    {
        action NOT_IMPLEMENTED();
    }

    fun *.trySplit (): Spliterator
    {
        action NOT_IMPLEMENTED();
    }

    fun *.forEachRemaining (action: Consumer): void
    {
        action NOT_IMPLEMENTED();
    }

    fun *.tryAdvance (action: Consumer): boolean
    {
        action NOT_IMPLEMENTED();
    }

    fun *.characteristics (): int
    {
        action NOT_IMPLEMENTED();
    }

}
*/
