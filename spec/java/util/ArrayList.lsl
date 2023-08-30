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
    // #problem: should be 8683452581122892189 instead
    @private @static val serialVersionUID: long = 1;
}


@GenerateMe
@implements("java.util.ListIterator")
@public @final type ArrayList_ListIterator
    is java.util.ArrayList_ListItr  // NOTE: do not use inner classes
    for ListIterator
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
        ArrayList (ArrayList),
        ArrayList (ArrayList, Collection),
        ArrayList (ArrayList, int),
    ];

    shift Initialized -> self by [
        // read operations
        clone,
        contains,
        containsAll,
        equals,
        forEach,
        get,
        hashCode,
        indexOf,
        isEmpty,
        iterator,
        lastIndexOf,
        listIterator (ArrayList),
        listIterator (ArrayList, int),
        parallelStream,
        size,
        spliterator,
        stream,
        subList,
        toArray (ArrayList),
        toArray (ArrayList, IntFunction),
        toArray (ArrayList, array<Object>),
        toString,

        // write operations
        add (ArrayList, Object),
        add (ArrayList, int, Object),
        addAll (ArrayList, Collection),
        addAll (ArrayList, int, Collection),
        clear,
        ensureCapacity,
        remove (ArrayList, Object),
        remove (ArrayList, int),
        removeAll,
        removeIf,
        replaceAll,
        retainAll,
        set,
        sort,
        trimToSize,
    ];

    // internal variables

    @transient var modCount: int = 0;


    // utilities

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


    proc _addAllElements (index: int, c: Collection): boolean
    {
        val oldLength: int = this.length;

        if (c has ArrayListAutomaton)
        {
            val otherStorage: list<Object> = ArrayListAutomaton(c).storage;
            val otherLength: int = ArrayListAutomaton(c).length;

            action ASSUME(otherStorage != null);
            action ASSUME(otherLength >= 0);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, otherLength, +1,
                _addAllElements_loop_optimized(otherStorage, i, index)
            );
        }
        else
        {
            val iter: Iterator = action CALL_METHOD(c, "iterator", []);
            action LOOP_WHILE(
                action CALL_METHOD(iter, "hasNext", []),
                _addAllElements_loop_regular(iter, index)
            );
        }

        result = oldLength != this.length;
        if (result)
            this.modCount += 1;
    }

    @Phantom proc _addAllElements_loop_optimized (otherStorage: list<Object>, i: int, index: int): void
    {
        val item: Object = action LIST_GET(otherStorage, i);
        action LIST_INSERT_AT(this.storage, index, item);

        index += 1;
        this.length += 1;
    }

    @Phantom proc _addAllElements_loop_regular (iter: Iterator, index: int): void
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
            val message1: String = "fromIndex = " + action OBJECT_TO_STRING(fromIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message1]);
        }

        if (toIndex > size)
        {
            val message2: String = "toIndex = " + action OBJECT_TO_STRING(toIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message2]);
        }

        if (fromIndex > toIndex)
        {
            val from: String = action OBJECT_TO_STRING(fromIndex);
            val to: String = action OBJECT_TO_STRING(toIndex);
            val message3: String = "fromIndex(" + from + ") > toIndex(" + to + ")";
            action THROW_NEW("java.lang.IllegalArgumentException", [message3]);
        }
    }


    @KeepVisible proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    proc _deleteElement (index: int): Object
    {
        _checkValidIndex(index);

        result = action LIST_GET(this.storage, index);
        action LIST_REMOVE(this.storage, index);

        this.length -= 1;
        this.modCount += 1;
    }


    proc _addElement (index: int, element: Object): void
    {
        _rangeCheckForAdd(index);

        action LIST_INSERT_AT(this.storage, index, element);

        this.length += 1;
        this.modCount += 1;
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


    proc _replaceAllRange (i: int, end: int, op: UnaryOperator): void
    {
        val expectedModCount: int = this.modCount;

        action LOOP_WHILE(
            this.modCount == expectedModCount && i < end,
            _replaceAllRange_loop(i, op)
        );

        _checkForComodification(expectedModCount);
    }

    @Phantom proc _replaceAllRange_loop (i: int, op: UnaryOperator): void
    {
        val oldItem: Object = action LIST_GET(this.storage, i);
        val newItem: Object = action CALL(op, [oldItem]);
        action LIST_SET(this.storage, i, newItem);

        i += 1;
    }


    @KeepVisible proc _removeIf(filter: Predicate, start: int, end: int): boolean
    {
        if (filter == null)
            _throwNPE();

        val oldLength: int = this.length;
        val expectedModCount: int = this.modCount;

        // remove elements from the back first
        var i: int = 0;
        action LOOP_FOR(
            i, end - 1, start, -1,
            _removeIf_loop(i, filter)
        );

        _checkForComodification(expectedModCount);

        result = oldLength != this.length;
    }

    @Phantom proc _removeIf_loop (i: int, filter: Predicate): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        if (action CALL(filter, [item]))
        {
            action LIST_REMOVE(this.storage, i);
            this.length -= 1;
        }
    }


    // constructors

    constructor *.ArrayList (@target self: ArrayList)
    {
        this.storage = action LIST_NEW();
        this.length = 0;
    }


    constructor *.ArrayList (@target self: ArrayList, c: Collection)
    {
        if (c == null)
            _throwNPE();

        this.storage = action LIST_NEW();
        this.length = 0;

        _addAllElements(0, c);
    }


    constructor *.ArrayList (@target self: ArrayList, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            val message: String = "Illegal Capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
        this.storage = action LIST_NEW();
        this.length = 0;
    }


    // methods

    fun *.add (@target self: ArrayList, e: Object): boolean
    {
        action LIST_INSERT_AT(this.storage, this.length, e);

        this.length += 1;
        this.modCount += 1;

        result = true;
    }


    fun *.add (@target self: ArrayList, index: int, element: Object): void
    {
        _addElement(index, element);
    }


    fun *.addAll (@target self: ArrayList, c: Collection): boolean
    {
        result = _addAllElements(this.length, c);
    }


    fun *.addAll (@target self: ArrayList, index: int, c: Collection): boolean
    {
        _rangeCheckForAdd(index);
        result = _addAllElements(index, c);
    }


    fun *.clear (@target self: ArrayList): void
    {
        this.storage = action LIST_NEW();
        this.length = 0;
        this.modCount += 1;
    }


    fun *.clone (@target self: ArrayList): Object
    {
        val storageCopy: list<Object> = action LIST_NEW();
        action LIST_COPY(this.storage, storageCopy, 0, 0, this.length);

        result = new ArrayListAutomaton(state = Initialized,
            storage = storageCopy,
            length = this.length
        );
    }


    fun *.contains (@target self: ArrayList, o: Object): boolean
    {
        result = action LIST_FIND(this.storage, o, 0, this.length) >= 0;
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: ArrayList, c: Collection): boolean
    {
        result = true;

        if (c has ArrayListAutomaton)
        {
            val otherStorage: list<Object> = ArrayListAutomaton(c).storage;
            val otherLength: int = ArrayListAutomaton(c).length;

            action ASSUME(otherStorage != null);
            action ASSUME(otherLength >= 0);

            var i: int = 0;
            action LOOP_WHILE(
                result && i < otherLength,
                containsAll_loop_optimized(otherStorage, i)
            );
        }
        else
        {
            val iter: Iterator = action CALL_METHOD(c, "iterator", []);
            action LOOP_WHILE(
                result && action CALL_METHOD(iter, "hasNext", []),
                containsAll_loop_regular(iter)
            );
        }
    }

    @Phantom proc containsAll_loop_optimized (otherStorage: list<Object>, i: int): boolean
    {
        val item: Object = action LIST_GET(otherStorage, i);
        result &= action LIST_FIND(this.storage, item, 0, this.length) >= 0;

        i += 1;
    }

    @Phantom proc containsAll_loop_regular (iter: Iterator): boolean
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        result &= action LIST_FIND(this.storage, item, 0, this.length) >= 0;
    }


    fun *.ensureCapacity (@target self: ArrayList, minCapacity: int): void
    {
        // 'storage' [list] is dynamic, so nothing more
        this.modCount += 1;
    }


    fun *.equals (@target self: ArrayList, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            if (other has ArrayListAutomaton)
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

                // #problem: should be something like
                // ArrayListAutomaton(other)._checkForComodification(otherExpectedModCount);
                action DEBUG_DO("((ArrayList) other)._checkForComodification(otherExpectedModCount)");
                _checkForComodification(expectedModCount);
            }
            else
            {
                result = false;
            }
        }
    }


    fun *.forEach (@target self: ArrayList, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        val expectedModCount: int = this.modCount;

        var i: int = 0;
        action LOOP_WHILE(
            this.modCount == expectedModCount && i < this.length,
            forEach_loop(i, _action)
        );

        _checkForComodification(expectedModCount);
    }

    @Phantom proc forEach_loop (i: int, _action: Consumer): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        action CALL(_action, [item]);

        i += 1;
    }


    fun *.get (@target self: ArrayList, index: int): Object
    {
        _checkValidIndex(index);

        result = action LIST_GET(this.storage, index);
    }


    fun *.hashCode (@target self: ArrayList): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.indexOf (@target self: ArrayList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, this.length);
    }


    fun *.isEmpty (@target self: ArrayList): boolean
    {
        result = this.length == 0;
    }


    fun *.iterator (@target self: ArrayList): Iterator
    {
        result = new ArrayList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
            expectedModCount = this.modCount
        );
    }


    fun *.lastIndexOf (@target self: ArrayList, o: Object): int
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


    fun *.listIterator (@target self: ArrayList): ListIterator
    {
        result = new ArrayList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
            expectedModCount = this.modCount
        );
    }


    fun *.listIterator (@target self: ArrayList, index: int): ListIterator
    {
        _rangeCheckForAdd(index);

        result = new ArrayList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = index,
            expectedModCount = this.modCount
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: ArrayList): Stream
    {
        // #problem: no streams
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    fun *.remove (@target self: ArrayList, o: Object): boolean
    {
        val index: int = action LIST_FIND(this.storage, o, 0, this.length);

        result = index >= 0;

        if (result)
            _deleteElement(index);
    }


    fun *.remove (@target self: ArrayList, index: int): Object
    {
        result = _deleteElement(index);
    }


    fun *.removeAll (@target self: ArrayList, c: Collection): boolean
    {
        val oldLength: int = this.length;

        if (c has ArrayListAutomaton)
        {
            val otherStorage: list<Object> = ArrayListAutomaton(c).storage;
            val otherLength: int = ArrayListAutomaton(c).length;

            action ASSUME(otherStorage != null);
            action ASSUME(otherLength >= 0);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, otherLength, +1,
                removeAll_loop_optimized(i, otherStorage)
            );
        }
        else
        {
            val iter: Iterator = action CALL_METHOD(c, "iterator", []);
            action LOOP_WHILE(
                action CALL_METHOD(iter, "hasNext", []),
                removeAll_loop_regular(iter)
            );
        }

        result = oldLength != this.length;
    }

    @Phantom proc removeAll_loop_optimized (i: int, otherStorage: list<Object>): void
    {
        val o: Object = action LIST_GET(otherStorage, i);
        val index: int = action LIST_FIND(this.storage, o, 0, this.length);

        if (index >= 0)
            _deleteElement(index);
    }

    @Phantom proc removeAll_loop_regular (iter: Iterator): void
    {
        val o: Object = action CALL_METHOD(iter, "next", []);
        val index: int = action LIST_FIND(this.storage, o, 0, this.length);

        if (index >= 0)
            _deleteElement(index);
    }


    fun *.removeIf (@target self: ArrayList, filter: Predicate): boolean
    {
        result = _removeIf(filter, 0, this.length);
    }


    fun *.replaceAll (@target self: ArrayList, op: UnaryOperator): void
    {
        if (op == null)
            _throwNPE();

        _replaceAllRange(0, this.length, op);
        this.modCount += 1;
    }


    fun *.retainAll (@target self: ArrayList, c: Collection): boolean
    {
        val oldLength: int = this.length;
        var i: int = 0;

        if (c has ArrayListAutomaton)
        {
            val otherStorage: list<Object> = ArrayListAutomaton(c).storage;
            val otherLength: int = ArrayListAutomaton(c).length;

            action ASSUME(otherStorage != null);
            action ASSUME(otherLength >= 0);

            action LOOP_FOR(
                i, this.length - 1, 0, -1,
                retainAll_loop_optimized(i, otherStorage, otherLength)
            );
        }
        else
        {
            action LOOP_FOR(
                i, this.length - 1, 0, -1,
                retainAll_loop_regular(i, c)
            );
        }

        result = oldLength != this.length;
    }

    @Phantom proc retainAll_loop_optimized (i: int, otherStorage: list<Object>, otherLength: int): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        val otherHasItem: boolean = action LIST_FIND(otherStorage, item, 0, otherLength);

        if (!otherHasItem)
            _deleteElement(i);
    }

    @Phantom proc retainAll_loop_regular (i: int, c: Collection): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        val otherHasItem: boolean = action CALL_METHOD(c, "contains", [item]);

        if (!otherHasItem)
            _deleteElement(i);
    }


    fun *.set (@target self: ArrayList, index: int, element: Object): Object
    {
        result = _setElement(index, element);
    }


    fun *.size (@target self: ArrayList): int
    {
        result = this.length;
    }


    fun *.sort (@target self: ArrayList, c: Comparator): void
    {
        val expectedModCount: int = this.modCount;

        // #problem: loops, extremely complex
        action NOT_IMPLEMENTED("too complex, no decision yet");

        _checkForComodification(expectedModCount);

        this.modCount += 1;
    }


    fun *.spliterator (@target self: ArrayList): Spliterator
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


    // within java.util.Collection
    fun *.stream (@target self: ArrayList): Stream
    {
        // #problem: no streams
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    fun *.subList (@target self: ArrayList, fromIndex: int, toIndex: int): List
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


    fun *.toArray (@target self: ArrayList): array<Object>
    {
        val len: int = this.length;
        result = action ARRAY_NEW("java.lang.Object", len);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i) // result assignment is implicit
        );
    }

    // #problem/todo: use exact parameter names
    @Phantom proc toArray_loop (i: int): array<Object>
    {
        result[i] = action LIST_GET(this.storage, i);
    }


    // within java.util.Collection
    fun *.toArray (@target self: ArrayList, generator: IntFunction): array<Object>
    {
        // acting just like the JDK: trigger NPE and class cast exceptions on invalid generator return value
        val a: array<Object> = action CALL_METHOD(generator, "apply", [0]) as array<Object>;
        val aLen: int = action ARRAY_SIZE(a);

        val len: int = this.length;
        // #problem: a.getClass() should be called to construct a type-valid array (USVM issue)
        result = action ARRAY_NEW("java.lang.Object", len);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i) // result assignment is implicit
        );
    }


    fun *.toArray (@target self: ArrayList, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = this.length;
        var i: int = 0;

        if (aLen < len)
        {
            // #problem: a.getClass() should be called to construct a type-valid array (USVM issue)
            result = action ARRAY_NEW("java.lang.Object", len);

            action LOOP_FOR(
                i, 0, len, +1,
                toArray_loop(i) // result assignment is implicit
            );
        }
        else
        {
            result = a;

            action LOOP_FOR(
                i, 0, len, +1,
                toArray_loop(i) // result assignment is implicit
            );

            if (aLen > len)
                result[len] = null;
        }
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: ArrayList): String
    {
        result = action OBJECT_TO_STRING(this.storage);
    }


    fun *.trimToSize (@target self: ArrayList): void
    {
        // 'storage' [list] is dynamic, so nothing more
        this.modCount += 1;
    }


    // special: serialization

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

    @AutoInline @Phantom proc _throwCME (): void
    {
        action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    proc _checkForComodification (): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val modCount: int = ArrayListAutomaton(this.parent).modCount;
        if (modCount != this.expectedModCount)
            _throwCME();
    }


    // methods

    fun *.hasPrevious (@target self: ArrayList_ListIterator): boolean
    {
        result = this.cursor != 0;
    }


    fun *.nextIndex (@target self: ArrayList_ListIterator): int
    {
        result = this.cursor;
    }


    fun *.previousIndex (@target self: ArrayList_ListIterator): int
    {
        result = this.cursor - 1;
    }


    fun *.hasNext (@target self: ArrayList_ListIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != ArrayListAutomaton(this.parent).length;
    }


    fun *.next (@target self: ArrayList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val parentStorage: list<Object> = ArrayListAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= ArrayListAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        // iterrator validity check
        if (i >= action LIST_SIZE(parentStorage))
            _throwCME();

        this.cursor = i + 1;
        this.lastRet = i;

        result = action LIST_GET(parentStorage, i);
    }


    fun *.previous (@target self: ArrayList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val parentStorage: list<Object> = ArrayListAutomaton(this.parent).storage;

        val i: int = this.cursor - 1;
        if (i < 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        // iterrator validity check
        if (i >= action LIST_SIZE(parentStorage))
            _throwCME();

        this.cursor = i;
        this.lastRet = i;

        result = action LIST_GET(parentStorage, i);
    }


    fun *.remove (@target self: ArrayList_ListIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        val pStorage: list<Object> = ArrayListAutomaton(this.parent).storage;
        if (this.lastRet >= action LIST_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            ArrayListAutomaton(this.parent).modCount += 1;

            action LIST_REMOVE(pStorage, this.lastRet);

            ArrayListAutomaton(this.parent).length -= 1;
        }

        this.cursor = this.lastRet;
        this.lastRet = -1;
        this.expectedModCount = ArrayListAutomaton(this.parent).modCount;
    }


    fun *.set (@target self: ArrayList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        val pStorage: list<Object> = ArrayListAutomaton(this.parent).storage;
        if (this.lastRet >= action LIST_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            action LIST_SET(pStorage, this.lastRet, e);
        }
    }


    fun *.add (@target self: ArrayList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val i: int = this.cursor;

        val pStorage: list<Object> = ArrayListAutomaton(this.parent).storage;
        if (this.lastRet > action LIST_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            ArrayListAutomaton(this.parent).modCount += 1;

            action LIST_INSERT_AT(pStorage, i, e);

            ArrayListAutomaton(this.parent).length += 1;
        }

        this.cursor = i + 1;
        this.lastRet = -1;
        this.expectedModCount = ArrayListAutomaton(this.parent).modCount;
    }


    fun *.forEachRemaining (@target self: ArrayList_ListIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        val size: int = ArrayListAutomaton(this.parent).length;

        if (i < size)
        {
            val es: list<Object> = ArrayListAutomaton(this.parent).storage;

            if (i >= action LIST_SIZE(es))
                _throwCME();

            // using this exact loop form here due to coplex termination expression
            action LOOP_WHILE(
                i < size && ArrayListAutomaton(this.parent).modCount == this.expectedModCount,
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


    fun *.trySplit (): ArrayListSpliterator
    {
        action TODO();
    }


    fun *.tryAdvance (action: Consumer): void
    {
        action TODO();
    }


    fun *.forEachRemaining (action: Consumer): void
    {
        action TODO();
    }


    fun *.estimateSize (): long
    {
        action TODO();
    }


    fun *.characteristics (): int
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


    fun *.set (index: int, element: Object): void
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = action LIST_GET(this.parent.storage, curIndex);
        action LIST_SET(this.parent.storage, curIndex, element);
    }


    fun *.get (index: int): Object
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = action LIST_GET(this.parent.storage, curIndex);
    }


    fun *.size (): int
    {
        this.parent._checkForComodification(modCount);
        result = length;
    }


    fun *.add (index: int, element: Object): void
    {
        this.parent._rangeCheckForAdd(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;
        this.parent._addElement(curIndex, element);

        _updateSizeAndModCount(1);
    }


    fun *.remove (index: int): Object
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = this.parent._deleteElement(curIndex);

        _updateSizeAndModCount(-1);
    }


    fun *.addAll (c: Collection): boolean
    {
        _addAllElements(length, c);
    }


    fun *.addAll (index: int, c: Collection): boolean
    {
        _addAllElements(index, c);
    }


    fun *.replaceAll (operator: UnaryOperator): void
    {
        // #problem
        action TODO();
    }


    fun *.removeAll (c: Collection): boolean
    {
        // #problem
        action TODO();
    }


    fun *.retainAll (c: Collection): boolean
    {
        // #problem
        action TODO();
    }


    fun *.removeIf (filter: Predicate): boolean
    {
        // #problem
        action TODO();
    }


    fun *.toArray (): array<Object>
    {
        val a: array<int> = action ARRAY_NEW("java.lang.Object", this.length);

        val end: int = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    fun *.toArray (a: list<Object>): array<Object>
    {
        val end: int = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    fun *.equals (o: Object): boolean
    {
        // #problem
        action TODO();
    }


    fun *.hashCode (): int
    {
        // result = action OBJECT_HASH_CODE(self);
        // #problem
        action TODO();
    }


    fun *.indexOf (o: Object): int
    {
        result = _indexOfElement(o);
    }


    fun *.lastIndexOf (o: Object): int
    {
        //I must think about this new action.
        action TODO();
    }


    fun *.contains (o: Object): boolean
    {
        result = _indexOfElement(o) >= 0;
    }


    fun *.subList (fromIndex: int, toIndex: int): List
    {
        this.parent._subListRangeCheck(fromIndex, toIndex, length);
        result = new SubList(state=Created,
            //Think about THIS !
            //TODO
            parentList = self,
            startIndex=fromIndex,
            endIndex=toIndex);
    }


    fun *.iterator (): Iterator
    {
        action TODO();
    }


    fun *.spliterator (): Spliterator
    {
        action TODO();
    }

}
// */
