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

    @KeepVisible proc _checkValidIndex (index: int, length: int): void
    {
        if (index < 0 || length <= index)
        {
            //val idx: String = action OBJECT_TO_STRING(index);
            //val len: String = action OBJECT_TO_STRING(this.length);
            //val message: String = "Index "+ idx + " out of bounds for length "+ len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }
    }


    @KeepVisible proc _rangeCheckForAdd (index: int): void
    {
        if (index > this.length || index < 0)
        {
            //val idx: String = action OBJECT_TO_STRING(index);
            //val len: String = action OBJECT_TO_STRING(this.length);
            //val message: String = "Index: " + idx + ", Size: " + len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }
    }


    @KeepVisible proc _addAllElements (index: int, c: Collection): boolean
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
    @KeepVisible proc _subListRangeCheck (fromIndex: int, toIndex: int, size: int): void
    {
        if (fromIndex < 0)
        {
            //val message1: String = "fromIndex = " + action OBJECT_TO_STRING(fromIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }

        if (toIndex > size)
        {
            //val message2: String = "toIndex = " + action OBJECT_TO_STRING(toIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }

        if (fromIndex > toIndex)
        {
            //val from: String = action OBJECT_TO_STRING(fromIndex);
            //val to: String = action OBJECT_TO_STRING(toIndex);
            //val message3: String = "fromIndex(" + from + ") > toIndex(" + to + ")";
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }
    }


    @KeepVisible proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    @KeepVisible proc _deleteElement (index: int): Object
    {
        _checkValidIndex(index, this.length);

        result = action LIST_GET(this.storage, index);
        action LIST_REMOVE(this.storage, index);

        this.length -= 1;
        this.modCount += 1;
    }


    @KeepVisible proc _addElement (index: int, element: Object): void
    {
        _rangeCheckForAdd(index);

        action LIST_INSERT_AT(this.storage, index, element);

        this.length += 1;
        this.modCount += 1;
    }


    proc _setElement (index: int, element: Object): Object
    {
        _checkValidIndex(index, this.length);

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
            //val message: String = "Illegal Capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
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
        result = action LIST_FIND(this.storage, item, 0, this.length) >= 0;

        i += 1;
    }

    @Phantom proc containsAll_loop_regular (iter: Iterator, result: boolean): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        result = action LIST_FIND(this.storage, item, 0, this.length) >= 0;
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
        _checkValidIndex(index, this.length);

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
        // #todo: use custom stream implementation
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
        val otherHasItem: boolean = action LIST_FIND(otherStorage, item, 0, otherLength) >= 0;

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

            // plain bubble sorting algorithm
            val outerLimit: int = this.length - 1;
            var innerLimit: int = 0;
            var i: int = 0;
            var j: int = 0;

            // check the comparator
            if (c == null)
            {
                // using Comparable::compareTo as a comparator

                // plain bubble sorting algorithm
                action LOOP_FOR(
                    i, 0, outerLimit, +1,
                    sort_loop_outer_noComparator(i, j, innerLimit)
                );
            }
            else
            {
                // using the provided comparator

                // plain bubble sorting algorithm (with a comparator)
                action LOOP_FOR(
                    i, 0, outerLimit, +1,
                    sort_loop_outer(i, j, innerLimit, c)
                );
            }

            _checkForComodification(expectedModCount);
        }

        this.modCount += 1;
    }

    @Phantom proc sort_loop_outer_noComparator (i: int, j: int, innerLimit: int): void
    {
        innerLimit = this.length - i - 1;
        action LOOP_FOR(
            j, 0, innerLimit, +1,
            sort_loop_inner_noComparator(j)
        );
    }

    @Phantom proc sort_loop_inner_noComparator (j: int): void
    {
        val idxA: int = j;
        val idxB: int = j + 1;
        val a: Object = action LIST_GET(this.storage, idxA);
        val b: Object = action LIST_GET(this.storage, idxB);

        if (action CALL_METHOD(a as Comparable, "compareTo", [b]) > 0)
        {
            action LIST_SET(this.storage, idxA, b);
            action LIST_SET(this.storage, idxB, a);
        }
    }

    @Phantom proc sort_loop_outer (i: int, j: int, innerLimit: int, c: Comparator): void
    {
        innerLimit = this.length - i - 1;
        action LOOP_FOR(
            j, 0, innerLimit, +1,
            sort_loop_inner(j, c)
        );
    }

    @Phantom proc sort_loop_inner (j: int, c: Comparator): void
    {
        val idxA: int = j;
        val idxB: int = j + 1;
        val a: Object = action LIST_GET(this.storage, idxA);
        val b: Object = action LIST_GET(this.storage, idxB);

        if (action CALL(c, [a, b]) > 0)
        {
            action LIST_SET(this.storage, idxA, b);
            action LIST_SET(this.storage, idxB, a);
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
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    fun *.subList (@target self: ArrayList, fromIndex: int, toIndex: int): List
    {
        _subListRangeCheck(fromIndex, toIndex, this.length);

        result = new ArrayList_SubListAutomaton(state = Initialized,
            root = self,
            parentList = null,
            offset = fromIndex,
            length = toIndex - fromIndex,
            modCount = this.modCount,
        );
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

        if (aLen < len)
            // #problem: a.getClass() should be called to construct a type-valid array (USVM issue)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result)
        );

        if (aLen > len)
            result[len] = null;
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
