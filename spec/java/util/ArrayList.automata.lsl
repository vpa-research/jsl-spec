libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java/util/ArrayList;


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


    @KeepVisible proc _removeIf (filter: Predicate, start: int, end: int): boolean
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
                containsAll_loop_optimized(otherStorage, i, result)
            );
        }
        else
        {
            val iter: Iterator = action CALL_METHOD(c, "iterator", []);
            action LOOP_WHILE(
                result && action CALL_METHOD(iter, "hasNext", []),
                containsAll_loop_regular(iter, result)
            );
        }
    }

    @Phantom proc containsAll_loop_optimized (otherStorage: list<Object>, i: int, result: boolean): void
    {
        val item: Object = action LIST_GET(otherStorage, i);
        result &= action LIST_FIND(this.storage, item, 0, this.length) >= 0;

        i += 1;
    }

    @Phantom proc containsAll_loop_regular (iter: Iterator, result: boolean): void
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
                    result = action OBJECT_EQUALS(this.storage, otherStorage);
                else
                    result = false;

                ArrayListAutomaton(other)._checkForComodification(otherExpectedModCount);
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
        if (this.length != 0)
        {
            val expectedModCount: int = this.modCount;

            // Java has no unsigned primitive data types
            action ASSUME(this.length > 0);

            // plain bubble sorting algorithm with no optimizations
            var i: int = 0;
            var j: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                sort_loop_outer(i, j, c)
            );

            _checkForComodification(expectedModCount);
        }

        this.modCount += 1;
    }

    @Phantom proc sort_loop_outer (i: int, j: int, c: Comparator): void
    {
        action LOOP_FOR(
            j, 0, this.length, +1,
            sort_loop_inner(i, j, c)
        );
    }

    @Phantom proc sort_loop_inner (i: int, j: int, c: Comparator): void
    {
        val a: Object = action LIST_GET(this.storage, i);
        val b: Object = action LIST_GET(this.storage, j);

        if (action CALL(c, [a, b]) > 0)
        {
            action LIST_SET(this.storage, i, b);
            action LIST_SET(this.storage, j, a);
        }
    }


    fun *.spliterator (@target self: ArrayList): Spliterator
    {
        result = new ArrayList_SpliteratorAutomaton(state = Initialized,
            parent = self,
        );
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
            toArray_loop(i, result)
        );
    }

    // #problem/todo: use exact parameter names
    @Phantom proc toArray_loop (i: int, result: array<Object>): void
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
            toArray_loop(i, result)
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
                toArray_loop(i, result)
            );
        }
        else
        {
            result = a;

            action LOOP_FOR(
                i, 0, len, +1,
                toArray_loop(i, result)
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




automaton ArrayList_SpliteratorAutomaton
(
    var parent: ArrayList
)
: ArrayList_Spliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        ArrayList_Spliterator,
    ];

    shift Initialized -> self by [
        // instance methods
        characteristics,
        equals,
        estimateSize,
        forEachRemaining,
        getComparator,
        getExactSizeIfKnown,
        hasCharacteristics,
        hashCode,
        toString,
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
        if (this.fence < 0)
        {
            action ASSUME(this.parent != null);
            this.expectedModCount = ArrayListAutomaton(this.parent).modCount;
            this.fence = ArrayListAutomaton(this.parent).length;
        }

        result = this.fence;
    }


    // constructors

    @private constructor *.ArrayList_Spliterator (
                @target self: ArrayList_Spliterator,
                _this: ArrayList,
                origin: int, fence: int, expectedModCount: int)
    {
        // #problem: translator cannot generate and refer to private and/or inner classes, so this is effectively useless
        action NOT_IMPLEMENTED("inaccessible constructor");
    }


    // static methods

    // methods

    fun *.characteristics (@target self: ArrayList_Spliterator): int
    {
        result = SPLITERATOR_ORDERED | SPLITERATOR_SIZED | SPLITERATOR_SUBSIZED;
    }


    // within java.lang.Object
    fun *.equals (@target self: ArrayList_Spliterator, obj: Object): boolean
    {
        action NOT_IMPLEMENTED("no final decision");
    }


    fun *.estimateSize (@target self: ArrayList_Spliterator): long
    {
        result = _getFence() - this.index;
    }


    fun *.forEachRemaining (@target self: ArrayList_Spliterator, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        action ASSUME(this.parent != null);
        val a: list<Object> = ArrayListAutomaton(this.parent).storage;
        if (a == null)
            _throwCME();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        if (hi < 0)
        {
            hi = ArrayListAutomaton(this.parent).length;
            mc = ArrayListAutomaton(this.parent).modCount;
        }

        var i: int = this.index;
        this.index = hi;
        if (i < 0 || hi > ArrayListAutomaton(this.parent).length)
            _throwCME();

        action LOOP_FOR(
            i, i, hi, +1,
            forEachRemaining_loop(i, a, _action)
        );

        if (mc != ArrayListAutomaton(this.parent).modCount)
            _throwCME();
    }

    @Phantom proc forEachRemaining_loop (i: int, a: list<Object>, _action: Consumer): void
    {
        val item: Object = action LIST_GET(a, i);
        action CALL(_action, [item]);
    }


    // within java.util.Spliterator
    @Phantom fun *.getComparator (@target self: ArrayList_Spliterator): Comparator
    {
        // NOTE: using the original method
    }


    // within java.util.Spliterator
    fun *.getExactSizeIfKnown (@target self: ArrayList_Spliterator): long
    {
        result = _getFence() - this.index;
    }


    // within java.util.Spliterator
    @Phantom fun *.hasCharacteristics (@target self: ArrayList_Spliterator, characteristics: int): boolean
    {
        // NOTE: using the original method
    }


    // within java.lang.Object
    fun *.hashCode (@target self: ArrayList_Spliterator): int
    {
        action NOT_IMPLEMENTED("no final decision");
    }


    // within java.lang.Object
    fun *.toString (@target self: ArrayList_Spliterator): String
    {
        action NOT_IMPLEMENTED("no final decision");
    }


    fun *.tryAdvance (@target self: ArrayList_Spliterator, _action: Consumer): boolean
    {
        if (_action == null)
            _throwNPE();

        val hi: int = _getFence();
        val i: int = this.index;

        if (i < hi)
        {
            this.index = i + 1;

            action ASSUME(this.parent != null);
            val parentStorage: list<Object> = ArrayListAutomaton(this.parent).storage;
            val item: Object = action LIST_GET(parentStorage, i);
            action CALL(_action, [item]);

            if (ArrayListAutomaton(this.parent).modCount != this.expectedModCount)
                _throwCME();

            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun *.trySplit (@target self: ArrayList_Spliterator): ArrayList_Spliterator
    {
        val hi: int = _getFence();
        val lo: int = this.index;
        val mid: int = (lo + hi) >>> 1;

        // JDK comment: divide range in half unless too small
        if (lo >= mid)
            result = null;
        else
            result = new ArrayList_SpliteratorAutomaton(state = Initialized,
                parent = this.parent,
                index = lo,
                fence = mid,
                expectedModCount = this.expectedModCount,
            );

        this.index = mid;
    }

}




/*
automaton ArrayList_SubListAutomaton
(
   var index: offset,
   var length: int,
   var modCount: int,
)
: ArrayList_SubList
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        SubList (ArrayList_SubList, ArrayList, int, int),
        SubList (ArrayList_SubList, ArrayList_SubList, int, int),
    ];

    shift Initialized -> self by [
        // instance methods
        add (ArrayList_SubList, Object),
        add (ArrayList_SubList, int, Object),
        addAll (ArrayList_SubList, Collection),
        addAll (ArrayList_SubList, int, Collection),
        clear,
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
        listIterator (ArrayList_SubList),
        listIterator (ArrayList_SubList, int),
        parallelStream,
        remove (ArrayList_SubList, Object),
        remove (ArrayList_SubList, int),
        removeAll,
        removeIf,
        replaceAll,
        retainAll,
        set,
        size,
        sort,
        spliterator,
        stream,
        subList,
        toArray (ArrayList_SubList),
        toArray (ArrayList_SubList, IntFunction),
        toArray (ArrayList_SubList, array<Object>),
        toString,
    ];

    // internal variables

    // utilities

    proc _addAllElements (index: int, c: Collection): boolean
    {
        ArrayListAutomaton(this.parent)._rangeCheckForAdd(index);

        val collectionSize: int = c.size();
        if (collectionSize == 0)
        {
            result = false;
        }
        else
        {
            result = true;

            this.parent._checkForComodification(modCount);
            this.parent._addAllElements(offset + index, c);
            _updateSizeAndModCount(collectionSize);
        }
    }


    proc _updateSizeAndModCount (sizeChange: int): void
    {
        action TODO();
    }


    proc _indexOfElement (o: Object): int
    {
        ArrayListAutomaton(this.parent)._checkForComodification(this.modCount);

        val index: int = action LIST_FIND(this.parent.storage, o, 0, this.parent.length);
        if (index >= 0)
            result = index - offset;
        else
            result = -1;
    }


    // constructors

    constructor *.SubList (@target self: ArrayList_SubList, root: ArrayList, fromIndex: int, toIndex: int)
    {
        // #problem: this constructor is useless
        action NOT_IMPLEMENTED("inaccessible constructor");
    }


    @private constructor *.SubList (@target self: ArrayList_SubList, parent: ArrayList_SubList, fromIndex: int, toIndex: int)
    {
        // #problem: this constructor is useless
        action NOT_IMPLEMENTED("inaccessible constructor");
    }


    // static methods

    // methods

    // within java.util.AbstractList
    fun *.add (@target self: ArrayList_SubList, e: Object): boolean
    {
        action TODO();
    }


    fun *.add (@target self: ArrayList_SubList, index: int, element: Object): void
    {
        this.parent._rangeCheckForAdd(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;
        this.parent._addElement(curIndex, element);

        _updateSizeAndModCount(+1);
    }


    fun *.addAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        _addAllElements(length, c);
    }


    fun *.addAll (@target self: ArrayList_SubList, index: int, c: Collection): boolean
    {
        _addAllElements(index, c);
    }


    // within java.util.AbstractList
    fun *.clear (@target self: ArrayList_SubList): void
    {
        action TODO();
    }


    fun *.contains (@target self: ArrayList_SubList, o: Object): boolean
    {
        result = _indexOfElement(o) >= 0;
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        action TODO();
    }


    fun *.equals (@target self: ArrayList_SubList, o: Object): boolean
    {
        action TODO();
    }


    // within java.lang.Iterable
    fun *.forEach (@target self: ArrayList_SubList, _action: Consumer): void
    {
        action TODO();
    }


    fun *.get (@target self: ArrayList_SubList, index: int): Object
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = action LIST_GET(this.parent.storage, curIndex);
    }


    fun *.hashCode (@target self: ArrayList_SubList): int
    {
        action TODO();
    }


    fun *.indexOf (@target self: ArrayList_SubList, o: Object): int
    {
        result = _indexOfElement(o);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: ArrayList_SubList): boolean
    {
        action TODO();
    }


    fun *.iterator (@target self: ArrayList_SubList): Iterator
    {
        action TODO();
    }


    fun *.lastIndexOf (@target self: ArrayList_SubList, o: Object): int
    {
        action TODO();
    }


    // within java.util.AbstractList
    fun *.listIterator (@target self: ArrayList_SubList): ListIterator
    {
        action TODO();
    }


    fun *.listIterator (@target self: ArrayList_SubList, index: int): ListIterator
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: ArrayList_SubList): Stream
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.remove (@target self: ArrayList_SubList, o: Object): boolean
    {
        action TODO();
    }


    fun *.remove (@target self: ArrayList_SubList, index: int): Object
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = this.parent._deleteElement(curIndex);

        _updateSizeAndModCount(-1);
    }


    fun *.removeAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        action TODO();
    }


    fun *.removeIf (@target self: ArrayList_SubList, filter: Predicate): boolean
    {
        action TODO();
    }


    fun *.replaceAll (@target self: ArrayList_SubList, operator: UnaryOperator): void
    {
        action TODO();
    }


    fun *.retainAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        action TODO();
    }


    fun *.set (@target self: ArrayList_SubList, index: int, element: Object): Object
    {
        this.parent._checkValidIndex(index);
        this.parent._checkForComodification(modCount);

        val curIndex: int = offset + index;

        result = action LIST_GET(this.parent.storage, curIndex);
        action LIST_SET(this.parent.storage, curIndex, element);
    }


    fun *.size (@target self: ArrayList_SubList): int
    {
        this.parent._checkForComodification(modCount);
        result = this.length;
    }


    // within java.util.List
    fun *.sort (@target self: ArrayList_SubList, c: Comparator): void
    {
        action TODO();
    }


    fun *.spliterator (@target self: ArrayList_SubList): Spliterator
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.stream (@target self: ArrayList_SubList): Stream
    {
        action TODO();
    }


    fun *.subList (@target self: ArrayList_SubList, fromIndex: int, toIndex: int): List
    {
        this.parent._subListRangeCheck(fromIndex, toIndex, length);

        result = new ArrayList_SubListAutomaton(state = Created,
            parentList = self,
            startIndex = fromIndex,
            endIndex = toIndex
        );
    }


    fun *.toArray (@target self: ArrayList_SubList): array<Object>
    {
        val a: array<int> = action ARRAY_NEW("java.lang.Object", this.length);

        val end: int = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    // within java.util.Collection
    fun *.toArray (@target self: ArrayList_SubList, generator: IntFunction): array<Object>
    {
        action TODO();
    }


    fun *.toArray (@target self: ArrayList_SubList, a: array<Object>): array<Object>
    {
        val end: int = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: ArrayList_SubList): String
    {
        action TODO();
    }

}
// */




/*
automaton ArrayList_StreamAutomaton
(
)
: ArrayList_Stream
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        allMatch,
        anyMatch,
        close,
        collect (ArrayList_Stream, Collector),
        collect (ArrayList_Stream, Supplier, BiConsumer, BiConsumer),
        count,
        distinct,
        dropWhile,
        equals,
        filter,
        findAny,
        findFirst,
        flatMap,
        flatMapToDouble,
        flatMapToInt,
        flatMapToLong,
        forEach,
        forEachOrdered,
        hashCode,
        isParallel,
        iterator,
        limit,
        map,
        mapToDouble,
        mapToInt,
        mapToLong,
        max,
        min,
        noneMatch,
        onClose,
        parallel,
        peek,
        reduce (ArrayList_Stream, BinaryOperator),
        reduce (ArrayList_Stream, Object, BiFunction, BinaryOperator),
        reduce (ArrayList_Stream, Object, BinaryOperator),
        sequential,
        skip,
        sorted (ArrayList_Stream),
        sorted (ArrayList_Stream, Comparator),
        spliterator,
        takeWhile,
        toArray (ArrayList_Stream),
        toArray (ArrayList_Stream, IntFunction),
        toString,
        unordered,
    ];

    // internal variables

    // utilities

    // constructors

    // static methods

    // methods

    // within java.util.stream.ReferencePipeline
    fun *.allMatch (@target self: ArrayList_Stream, predicate: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.anyMatch (@target self: ArrayList_Stream, predicate: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.close (@target self: ArrayList_Stream): void
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.collect (@target self: ArrayList_Stream, collector: Collector): Object
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.collect (@target self: ArrayList_Stream, supplier: Supplier, accumulator: BiConsumer, combiner: BiConsumer): Object
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.count (@target self: ArrayList_Stream): long
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.distinct (@target self: ArrayList_Stream): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.dropWhile (@target self: ArrayList_Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.equals (@target self: ArrayList_Stream, obj: Object): boolean
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.filter (@target self: ArrayList_Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.findAny (@target self: ArrayList_Stream): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.findFirst (@target self: ArrayList_Stream): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMap (@target self: ArrayList_Stream, mapper: Function): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMapToDouble (@target self: ArrayList_Stream, mapper: Function): DoubleStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMapToInt (@target self: ArrayList_Stream, mapper: Function): IntStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.flatMapToLong (@target self: ArrayList_Stream, mapper: Function): LongStream
    {
        action TODO();
    }


    fun *.forEach (@target self: ArrayList_Stream, _action: Consumer): void
    {
        action TODO();
    }


    fun *.forEachOrdered (@target self: ArrayList_Stream, _action: Consumer): void
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.hashCode (@target self: ArrayList_Stream): int
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.isParallel (@target self: ArrayList_Stream): boolean
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.iterator (@target self: ArrayList_Stream): Iterator
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.limit (@target self: ArrayList_Stream, maxSize: long): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.map (@target self: ArrayList_Stream, mapper: Function): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.mapToDouble (@target self: ArrayList_Stream, mapper: ToDoubleFunction): DoubleStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.mapToInt (@target self: ArrayList_Stream, mapper: ToIntFunction): IntStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.mapToLong (@target self: ArrayList_Stream, mapper: ToLongFunction): LongStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.max (@target self: ArrayList_Stream, comparator: Comparator): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.min (@target self: ArrayList_Stream, comparator: Comparator): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.noneMatch (@target self: ArrayList_Stream, predicate: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.onClose (@target self: ArrayList_Stream, closeHandler: Runnable): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.parallel (@target self: ArrayList_Stream): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.peek (@target self: ArrayList_Stream, _action: Consumer): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.reduce (@target self: ArrayList_Stream, accumulator: BinaryOperator): Optional
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.reduce (@target self: ArrayList_Stream, identity: Object, accumulator: BiFunction, combiner: BinaryOperator): Object
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.reduce (@target self: ArrayList_Stream, identity: Object, accumulator: BinaryOperator): Object
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.sequential (@target self: ArrayList_Stream): BaseStream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.skip (@target self: ArrayList_Stream, n: long): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.sorted (@target self: ArrayList_Stream): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.sorted (@target self: ArrayList_Stream, comparator: Comparator): Stream
    {
        action TODO();
    }


    // within java.util.stream.AbstractPipeline
    fun *.spliterator (@target self: ArrayList_Stream): Spliterator
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.takeWhile (@target self: ArrayList_Stream, predicate: Predicate): Stream
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.toArray (@target self: ArrayList_Stream): array<Object>
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.toArray (@target self: ArrayList_Stream, generator: IntFunction): array<Object>
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.toString (@target self: ArrayList_Stream): String
    {
        action TODO();
    }


    // within java.util.stream.ReferencePipeline
    fun *.unordered (@target self: ArrayList_Stream): Stream
    {
        action TODO();
    }

}
// */
