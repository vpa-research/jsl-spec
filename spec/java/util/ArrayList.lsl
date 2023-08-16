///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/io/_interfaces;
import java/util/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// local semantic types

@extends("java.util.AbstractList")
@implements("java.util.List")
@implements("java.util.RandomAccess")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type ArrayList
    is java.util.ArrayList
    for List
{
    //@private @static @final var serialVersionUID: long = 8683452581122892189;
}


@GenerateMe
//@implements("java.util.ListIterator")
@implements("java.util.Iterator")
@public @final type ArrayList_ListIterator
    is java.util.ArrayList_ListItr  // NOTE: do not use inner classes
    for Iterator
{
}


// automata

automaton ArrayListAutomaton
(
    var storage: list<Object>,
    @transient var length: int
)
: ArrayList
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        ArrayList(ArrayList),
        ArrayList(ArrayList, int),
        ArrayList(ArrayList, Collection)
    ];

    shift Initialized -> self by [
        // read operations
        contains,
        get,
        indexOf,
        isEmpty,
        lastIndexOf,
        size,

        toString,
        hashCode,
        clone,

        iterator,
        listIterator(ArrayList),
        listIterator(ArrayList, int),
        spliterator,
        subList,
        toArray(ArrayList),
        //toArray(ArrayList, array<Object>), // #problem

        // write operations
        add(ArrayList, Object),
        add(ArrayList, int, Object),
        addAll(ArrayList, Collection),
        addAll(ArrayList, int, Collection),
        clear,
        ensureCapacity,
        forEach,
        remove(ArrayList, int),
        remove(ArrayList, Object),
        removeAll,
        removeIf,
        replaceAll,
        retainAll,
        set,
        sort,
        trimToSize,
    ];


    // automaton instance-specific local variables

    @transient var modCount: int = 0;


    // subroutines

    proc _checkValidIndex (index: int): void
    {
        if (index < 0 || this.length <= index)
        {
            val idx: String = action OBJECT_TO_STRING(index);
            val len: String = action OBJECT_TO_STRING(this.length);
            val message: String = "Index "+ idx + " out of bounds for length "+ len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _rangeCheckForAdd (index: int): void
    {
        if (index > this.length || index < 0)
        {
            val idx: String = action OBJECT_TO_STRING(index);
            val len: String = action OBJECT_TO_STRING(this.length);
            val message: String = "Index: " + idx + ", Size: " + len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
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
        this.length += 1;
    }


    // checks range [from, to) against [0, size)
    proc _subListRangeCheck (fromIndex: int, toIndex: int, size: int): void
    {
        if (fromIndex < 0)
        {
            val message: String = "fromIndex = " + action OBJECT_TO_STRING(fromIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (toIndex > size)
        {
            val message: String = "toIndex = " + action OBJECT_TO_STRING(toIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (fromIndex > toIndex)
        {
            val from: String = action OBJECT_TO_STRING(fromIndex);
            val to: String = action OBJECT_TO_STRING(toIndex);
            val message: String = "fromIndex(" + from + ") > toIndex(" + to + ")";
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
    }


    proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
            {action THROW_NEW("java.util.ConcurrentModificationException", []);}
    }

    proc _deleteElement (index: int): Object
    {
        _checkValidIndex(index);

        result = action LIST_GET(this.storage, index);

        this.modCount += 1;

        action LIST_REMOVE(this.storage, index);

        this.length -= 1;
    }


    proc _addElement (index: int, element: Object): void
    {
        _rangeCheckForAdd(index);

        this.modCount += 1;

        action LIST_INSERT_AT(this.storage, index, element);

        this.length += 1;
    }


    proc _setElement (index: int, element: Object): Object
    {
        _checkValidIndex(index);

        result = action LIST_GET(this.storage, index);

        action LIST_SET(this.storage, index, element);
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _replaceAllRange (i: int, end: int, @Parameterized(["E"]) op: UnaryOperator): void
    {
        val expectedModCount: int = this.modCount;

        action LOOP_WHILE(
            this.modCount == expectedModCount && i < end,
            _replaceAllRange_loop(i, op)
        );

        if (this.modCount != expectedModCount)
            {action THROW_NEW("java.util.ConcurrentModificationException", []);}
    }

    @Phantom proc _replaceAllRange_loop (i: int, op: UnaryOperator): void
    {
        val oldItem: Object = action LIST_GET(this.storage, i);
        val newItem: Object = action CALL(op, [oldItem]);
        action LIST_SET(this.storage, i, newItem);

        i += 1;
    }


    //constructors

    constructor ArrayList (@target self: ArrayList)
    {
        this.storage = action LIST_NEW();
        this.length = 0;
    }


    constructor ArrayList (@target self: ArrayList, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            val message: String = "Illegal Capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
        this.storage = action LIST_NEW();
        this.length = 0;
    }


    constructor ArrayList (@target self: ArrayList, c: Collection)
    {
        if (c == null)
            {_throwNPE();}

        this.storage = action LIST_NEW();
        this.length = 0;

        _addAllElements(0, c);
    }


    //methods

    fun trimToSize (@target self: ArrayList): void
    {
        // method is not applicable to this approximation
        this.modCount += 1;
    }


    fun ensureCapacity (@target self: ArrayList, minCapacity: int): void
    {
        // method is not applicable to this approximation
        this.modCount += 1;
    }


    fun size (@target self: ArrayList): int
    {
        result = this.length;
    }


    fun isEmpty (@target self: ArrayList): boolean
    {
        result = this.length == 0;
    }


    fun contains (@target self: ArrayList, o: Object): boolean
    {
        result = action LIST_FIND(this.storage, o, 0, this.length) >= 0;
    }


    fun indexOf (@target self: ArrayList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, this.length);
    }


    fun lastIndexOf (@target self: ArrayList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, this.length);
        if (result != -1)
        {
            // there should be no elements to the right of the previously found position
            val nextIndex: int = result + 1;
            if (nextIndex < this.length)
            {
                val rightIndex: int = action LIST_FIND(this.storage, o, nextIndex, this.length);
                action ASSUME(rightIndex == -1);
            }
        }
    }


    fun clone (@target self: ArrayList): Object
    {
        val storageCopy: list<Object> = action LIST_NEW();
        action LIST_COPY(this.storage, storageCopy, 0, 0, this.length);

        result = new ArrayListAutomaton(state = Initialized,
            storage = storageCopy,
            length = this.length
        );
    }


    fun toArray (@target self: ArrayList): array<Object>
    {
        val size: int = this.length;
        result = action ARRAY_NEW("java.lang.Object", size);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            toArray_loop(i) // result assignment is implicit
        );
    }


    // #problem/todo: use exact parameter names
    @Phantom proc toArray_loop(i: int): array<Object>
    {
        result[i] = action LIST_GET(this.storage, i);
    }


    fun toArray (@target self: ArrayList, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val size: int = this.length;
        var i: int = 0;

        if (aLen < size)
        {
            // #problem: a.getClass() should be called to construct a type-valid array (USVM issue)
            result = action ARRAY_NEW("java.lang.Object", size);

            action LOOP_FOR(
                i, 0, size, +1,
                toArray_loop(i) // result assignment is implicit
            );
        }
        else
        {
            result = a;

            action LOOP_FOR(
                i, 0, size, +1,
                toArray_loop(i) // result assignment is implicit
            );

            if (aLen > size)
                {result[size] = null;}
        }
    }


    fun get (@target self: ArrayList, index: int): Object
    {
        _checkValidIndex(index);
        result = action LIST_GET(this.storage, index);
    }


    fun set (@target self: ArrayList, index: int, element: Object): Object
    {
        result = _setElement(index, element);
    }


    fun add (@target self: ArrayList, e: Object): boolean
    {
        this.modCount += 1;
        action LIST_INSERT_AT(this.storage, this.length, e);
        this.length += 1;
        result = true;
    }


    fun add (@target self: ArrayList, index: int, element: Object): void
    {
        _addElement(index, element);
    }


    fun remove (@target self: ArrayList, index: int): Object
    {
        result = _deleteElement(index);
    }


    fun equals (@target self: ArrayList, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            val isSameType: boolean = action OBJECT_SAME_TYPE(self, other);
            if (isSameType)
            {
                val expectedModCount: int = this.modCount;
                val otherExpectedModCount: int = ArrayListAutomaton(other).modCount;

                val otherStorage: list<Object> = ArrayListAutomaton(other).storage;
                val otherLength: int = ArrayListAutomaton(other).length;

                if (this.length == otherLength)
                {
                    result = action OBJECT_EQUALS(this.storage, otherStorage);
                }
                else
                {
                    result = false;
                }

                // #problem
                action DEBUG_DO("((ArrayList) other)._checkForComodification(otherExpectedModCount)");
                _checkForComodification(expectedModCount);
            }
            else
            {
                result = false;
            }
        }
    }


    fun toString (@target self: ArrayList): String
    {
        result = action OBJECT_TO_STRING(this.storage);
    }


    fun hashCode (@target self: ArrayList): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun remove (@target self: ArrayList, o: Object): boolean
    {
        val index: int = action LIST_FIND(this.storage, o, 0, this.length);
        if (index == -1)
        {
            result = false;
        }
        else
        {
            action LIST_REMOVE(this.storage, index);
            result = true;
        }
    }


    fun clear (@target self: ArrayList): void
    {
        this.storage = action LIST_NEW();
        this.length = 0;
        this.modCount += 1;
    }


    fun addAll (@target self: ArrayList, c: Collection): boolean
    {
        result = _addAllElements(this.length, c);
    }



    fun addAll (@target self: ArrayList, index: int, c: Collection): boolean
    {
        _rangeCheckForAdd(index);
        result = _addAllElements(index, c);
    }


    fun removeAll (@target self: ArrayList, c: Collection): boolean
    {
        // TODO: interface call
        action NOT_IMPLEMENTED("no support for interface calls yet");
    }


    fun retainAll (@target self: ArrayList, c: Collection): boolean
    {
        // TODO: interface call
        action NOT_IMPLEMENTED("no support for interface calls yet");
    }


    @throws(["java.io.IOException"])
    @private fun writeObject (@target self: ArrayList, s: ObjectOutputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun readObject (@target self: ArrayList, s: ObjectInputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    fun listIterator (@target self: ArrayList, index: int): ListIterator
    {
        _rangeCheckForAdd(index);

        /*
        result = new ArrayList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = index,
            expectedModCount = this.modCount
        );
        */
        action NOT_IMPLEMENTED("testing creation and usage of new types");
    }


    fun listIterator (@target self: ArrayList): ListIterator
    {
        /*
        result = new ArrayList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
            expectedModCount = this.modCount
        );
        */
        action NOT_IMPLEMENTED("testing creation and usage of new types");
    }


    fun iterator (@target self: ArrayList): Iterator
    {
        val res: ArrayList_ListIterator = new ArrayList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
            expectedModCount = this.modCount
        );
        result = res;
    }


    fun subList (@target self: ArrayList, fromIndex: int, toIndex: int): List
    {
        _subListRangeCheck(fromIndex, toIndex, this.length);

        // #problem
        //We don't have decision about sublists.
        result = action SYMBOLIC("java.util.List");
        action ASSUME(result != null);
        /*
        result = new ArrayList_SubListAutomaton(state = Created,
            startIndex = fromIndex,
            endIndex = toIndex
        );
        */
    }


    fun forEach (@target self: ArrayList, anAction: Consumer): void
    {
        if (anAction == null)
            {_throwNPE();}

        val expectedModCount: int = this.modCount;
        val size: int = this.length;

        var i: int = 0;
        action LOOP_WHILE(
            this.modCount == expectedModCount && i < size,
            forEach_loop(i, anAction)
        );

        if (this.modCount != expectedModCount)
            {action THROW_NEW("java.util.ConcurrentModificationException", []);}
    }

    @Phantom proc forEach_loop(i: int, anAction: Consumer): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        action CALL(anAction, [item]);

        i += 1;
    }


    fun spliterator (@target self: ArrayList): Spliterator
    {
        /*
        result = new ArrayList_SpliteratorAutomaton(state = Initialized,
            origin = 0,
            est = -1,
            expectedModCount = 0
        );
        */
        result = action SYMBOLIC("java.util.Spliterator");
        action ASSUME(result != null);
    }


    fun removeIf (@target self: ArrayList, filter: Predicate): boolean
    {
        if (filter == null)
            {_throwNPE();}

        val expectedModCount: int = modCount;

        // #problem: loop with interface calls
        action NOT_IMPLEMENTED("no support for interface calls");

        //val res = action CALL(filter, [storage]);
        // if (res == null)
        // {
        //     result = false;
        //     if (modCount != expectedModCount)
        //     {
        //         action THROW_NEW("java.util.ConcurrentModificationException", []);
        //     }
        // }
        // else
        // {
        //     result = true;
        //     if (modCount != expectedModCount)
        //     {
        //         action THROW_NEW("java.util.ConcurrentModificationException", []);
        //     }
        //     modCount = modCount + 1;
        // }
    }


    fun replaceAll (@target self: ArrayList, @Parameterized(["E"]) op: UnaryOperator): void
    {
        if (op == null)
            {_throwNPE();}

        _replaceAllRange(0, this.length, op);
        this.modCount += 1;
    }


    fun sort (@target self: ArrayList, c: Comparator): void
    {
        if (c == null)
            {_throwNPE();}

        val expectedModCount: int = this.modCount;

        // #problem: loops, extremely complex
        action NOT_IMPLEMENTED("too complex, no decision yet");

        if (this.modCount != expectedModCount)
            {action THROW_NEW("java.util.ConcurrentModificationException", []);}

        this.modCount += 1;
    }
}




automaton ArrayList_ListIteratorAutomaton
(
    var parent: ArrayList,
    var cursor: int,
    var expectedModCount: int
)
: ArrayList_ListIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       add,
       forEachRemaining,
       hasNext,
       hasPrevious,
       next,
       nextIndex,
       previous,
       previousIndex,
       remove,
       set,
    ];


    // local variables

    var lastRet: int = -1;


    // utilities

    proc _checkForComodification(): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val modCount: int = action DEBUG_DO("parent.modCount");
        if (modCount != this.expectedModCount)
            {action THROW_NEW("java.util.ConcurrentModificationException", []);}
    }


    // methods

    fun hasPrevious (@target self: ArrayList_ListIterator): boolean
    {
        result = this.cursor != 0;
    }


    fun nextIndex (@target self: ArrayList_ListIterator): int
    {
        result = this.cursor;
    }


    fun previousIndex (@target self: ArrayList_ListIterator): int
    {
        result = this.cursor - 1;
    }


    fun hasNext (@target self: ArrayList_ListIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != action DEBUG_DO("parent.length");
    }


    fun next (@target self: ArrayList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val parentStorage: list<Object> = action DEBUG_DO("parent.storage");

        val i: int = this.cursor;
        if (i >= action DEBUG_DO("parent.length"))
            {action THROW_NEW("java.util.NoSuchElementException", []);}

        // iterrator validity check
        if (i >= action LIST_SIZE(parentStorage))
            {action THROW_NEW("java.util.ConcurrentModificationException", []);}

        this.cursor = i + 1;
        this.lastRet = i;

        result = action LIST_GET(parentStorage, i);
    }


    fun previous (@target self: ArrayList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val parentStorage: list<Object> = action DEBUG_DO("parent.storage");

        val i: int = this.cursor - 1;
        if (i < 0)
            {action THROW_NEW("java.util.NoSuchElementException", []);}

        // iterrator validity check
        if (i >= action LIST_SIZE(parentStorage))
            {action THROW_NEW("java.util.ConcurrentModificationException", []);}

        this.cursor = i;
        this.lastRet = i;

        result = action LIST_GET(parentStorage, i);
    }


    fun remove (@target self: ArrayList_ListIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            {action THROW_NEW("java.lang.IllegalStateException", []);}

        _checkForComodification();

        val pStorage: list<Object> = action DEBUG_DO("parent.storage");
        if (this.lastRet >= action LIST_SIZE(pStorage))
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
        else
        {
            action DEBUG_DO("parent.modCount += 1");

            action LIST_REMOVE(pStorage, this.lastRet);

            action DEBUG_DO("parent.length -= 1");
        }

        this.cursor = this.lastRet;
        this.lastRet = -1;
        this.expectedModCount = action DEBUG_DO("parent.modCount");
    }


    fun set (@target self: ArrayList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            {action THROW_NEW("java.lang.IllegalStateException", []);}

        _checkForComodification();

        val pStorage: list<Object> = action DEBUG_DO("parent.storage");
        if (this.lastRet >= action LIST_SIZE(pStorage))
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
        else
        {
            action LIST_SET(pStorage, this.lastRet, e);
        }
    }


    fun add (@target self: ArrayList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val i: int = this.cursor;

        val pStorage: list<Object> = action DEBUG_DO("parent.storage");
        if (this.lastRet > action LIST_SIZE(pStorage))
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
        else
        {
            action DEBUG_DO("parent.modCount += 1");

            action LIST_INSERT_AT(pStorage, i, e);

            action DEBUG_DO("parent.length += 1");
        }

        this.cursor = i + 1;
        this.lastRet = -1;
        this.expectedModCount = action DEBUG_DO("parent.modCount");
    }


    fun forEachRemaining (@target self: ArrayList_ListIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            {action THROW_NEW("java.lang.NullPointerException", []);}

        var i: int = this.cursor;
        val size: int = action DEBUG_DO("parent.length");

        if (i < size)
        {
            val es: list<Object> = action DEBUG_DO("parent.storage");

            if (i >= action LIST_SIZE(es))
                {action THROW_NEW("java.util.ConcurrentModificationException", []);}

            // using this exact loop form here due to coplex termination expression
            action LOOP_WHILE(
                i < size && action DEBUG_DO("parent.modCount") == this.expectedModCount,
                forEachRemaining_loop(userAction, es, i)
            );

            // JDK NOTE: "update once at end to reduce heap write traffic"
            this.cursor = i;
            this.lastRet = i - 1;
            _checkForComodification();
        }
    }

    @Phantom proc forEachRemaining_loop (userAction: Consumer, es: list<Object>, i: int): void
    {
        val item: Object = action LIST_GET(es, i);
        action CALL(userAction, [item]);
        i += 1;
    }

}




/*
@final
@implements(["java.util.Spliterator"])
automaton ArrayListSpliterator: int(
    var index: int,
    var fence: int,
    var expectedModCount: int
)
{

    initstate Initialized;
    state Allocated;

    shift Allocated -> Initialized by [
        ArrayListSpliterator(int, int, int)
    ];

    shift Initialized -> self by [
       // read operations
       estimateSize,
       characteristics

       // write operations
       trySplit,
       tryAdvance,
       forEachRemaining
    ]

    //constructors


    constructor ArrayListSpliterator (origin: int, fence: int, expectedModCount: int)
    {
        action ERROR("Dangerous behavior");
    }


    //methods


    fun trySplit (): ArrayListSpliterator
    {
        action TODO();
    }


    fun tryAdvance (action: Consumer): void
    {
        action TODO();
    }


    fun forEachRemaining (action: Consumer): void
    {
        action TODO();
    }


    fun estimateSize (): long
    {
        action TODO();
    }


    fun characteristics (): int
    {
        action TODO();
    }

}
// */




/*
@extends("java.util.AbstractList")
@implements("java.util.RandomAccess")
automaton SubList: int(
   @private @final var index: offset,
   @private var length: int,
   @transient var modCount: int,

)
{

    initstate Initialized;

    shift Allocated -> Initialized by [
    ];

    shift Initialized -> self by [
        // read operations

        // write operations
    ]


    //constructors


    constructor SubList(startIndex: int, endIndex: int)
    {
        offset = startIndex;
        length = endIndex - startIndex;
        modCount = this.parent.modCount;
    }


    @private
    constructor SubList(parentList: SubList, startIndex: int, endIndex: int)
    {
        // #problem
        //???
        offset = startIndex;
        length = endIndex - startIndex;
        modCount = this.parent.modCount;
    }


    //subs

    proc _addAllElements (index:int, c:Collection): boolean
    {
        this.parent._rangeCheckForAdd(index);

        //I use suppose that Collection interface will have size sub or analog
        val collectionSize: int = c.size();

        if (collectionSize == 0)
        {
            result = false;
        }
        else
        {
            this.parent._checkForComodification(modCount);

            val curIndex = offset + index;

            this.parent._addAllElements(index, c);

            _updateSizeAndModCount(collectionSize);

            result = true;
        }
    }


    proc _updateSizeAndModCount (sizeChange: int): void
    {
        // #problem
        //Here is cycle
        action TODO();
    }


    proc _indexOfElement (o: Object): int
    {
        val index: int = action LIST_FIND(this.parent.storage, o, 0, this.parent.length);
        this.parent._checkForComodification(modCount);

        if (index >= 0)
        {
            result = index - offset;
        }
        else
        {
            result = -1;
        }
    }


    //methods


    fun set (index: int, element: Object): void
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = action LIST_GET(this.parent.storage, curIndex);
        action LIST_SET(this.parent.storage, curIndex, element);
    }


    fun get (index: int): Object
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = action LIST_GET(this.parent.storage, curIndex);
    }


    fun size (): int
    {
        this.parent._checkForComodification(modCount);
        result = length;
    }


    fun add (index: int, element: Object): void
    {
        this.parent._rangeCheckForAdd(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;
        this.parent._addElement(curIndex, element);

        _updateSizeAndModCount(1);
    }


    fun remove (index: int): Object
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = this.parent._deleteElement(curIndex);

        _updateSizeAndModCount(-1);
    }


    fun addAll (c: Collection): boolean
    {
        _addAllElements(length, c);
    }


    fun addAll (index: int, c: Collection): boolean
    {
        _addAllElements(index, c);
    }


    fun replaceAll (operator: UnaryOperator): void
    {
        // #problem
        action TODO();
    }


    fun removeAll (c: Collection): boolean
    {
        // #problem
        action TODO();
    }


    fun retainAll (c: Collection): boolean
    {
        // #problem
        action TODO();
    }


    fun removeIf (filter: Predicate): boolean
    {
        // #problem
        action TODO();
    }


    fun toArray (): array<Object>
    {
        val a: array<int> = action ARRAY_NEW("java.lang.Object", this.length);

        val end: int = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    fun toArray (a: list<Object>): array<Object>
    {
        val end: int = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    fun equals (o: Object): boolean
    {
        // #problem
        action TODO();
    }


    fun hashCode (): int
    {
        // result = action OBJECT_HASH_CODE(self);
        // #problem
        action TODO();
    }


    fun indexOf (o: Object): int
    {
        result = _indexOfElement(o);
    }


    fun lastIndexOf (o: Object): int
    {
        //I must think about this new action.
        action TODO();
    }


    fun contains (o: Object): boolean
    {
        result = _indexOfElement(o) >= 0;
    }


    fun subList (fromIndex: int, toIndex: int): List
    {
        this.parent._subListRangeCheck(fromIndex, toIndex, length);
        result = new SubList(state=Created,
            //Think about THIS !
            //TODO
            parentList = self,
            startIndex=fromIndex,
            endIndex=toIndex);
    }


    fun iterator (): Iterator
    {
        action TODO();
    }


    fun spliterator (): Spliterator
    {
        action TODO();
    }

}
// */
