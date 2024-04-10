//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java/util/stream/Stream;

import java/util/ArrayList;


// automata

automaton ArrayListAutomaton
(
    var storage: list<Object>
)
: ArrayList
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (ArrayList),
        `<init>` (ArrayList, Collection),
        `<init>` (ArrayList, int),
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
            //val len: String = action OBJECT_TO_STRING(action LIST_SIZE(this.storage));
            //val message: String = "Index "+ idx + " out of bounds for length "+ len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }
    }


    @KeepVisible proc _rangeCheckForAdd (index: int): void
    {
        if (index > action LIST_SIZE(this.storage) || index < 0)
        {
            //val idx: String = action OBJECT_TO_STRING(index);
            //val len: String = action OBJECT_TO_STRING(action LIST_SIZE(this.storage));
            //val message: String = "Index: " + idx + ", Size: " + len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }
    }


    @KeepVisible proc _addAllElements (index: int, c: Collection): boolean
    {
        val oldLength: int = action LIST_SIZE(this.storage);

        if (c has ArrayListAutomaton)
        {
            val otherStorage: list<Object> = ArrayListAutomaton(c).storage;
            val otherLength: int = action LIST_SIZE(otherStorage);

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

        result = oldLength != action LIST_SIZE(this.storage);
        if (result)
            this.modCount += 1;
    }

    @Phantom proc _addAllElements_loop_optimized (otherStorage: list<Object>, i: int, index: int): void
    {
        val item: Object = action LIST_GET(otherStorage, i);
        action LIST_INSERT_AT(this.storage, index, item);

        index += 1;
    }

    @Phantom proc _addAllElements_loop_regular (iter: Iterator, index: int): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        action LIST_INSERT_AT(this.storage, index, item);

        index += 1;
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
        _checkValidIndex(index, action LIST_SIZE(this.storage));

        result = action LIST_GET(this.storage, index);
        action LIST_REMOVE(this.storage, index);

        this.modCount += 1;
    }


    @KeepVisible proc _addElement (index: int, element: Object): void
    {
        _rangeCheckForAdd(index);

        action LIST_INSERT_AT(this.storage, index, element);

        this.modCount += 1;
    }


    proc _setElement (index: int, element: Object): Object
    {
        _checkValidIndex(index, action LIST_SIZE(this.storage));

        result = action LIST_GET(this.storage, index);
        action LIST_SET(this.storage, index, element);
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @KeepVisible proc _replaceAllRange (op: UnaryOperator, i: int, end: int): void
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

        val oldLength: int = action LIST_SIZE(this.storage);
        val expectedModCount: int = this.modCount;

        // remove elements from the back first
        action ASSUME(start <= end);
        var i: int = 0;
        action LOOP_FOR(
            i, end - 1, start, -1,
            _removeIf_loop(i, filter)
        );

        _checkForComodification(expectedModCount);

        result = oldLength != action LIST_SIZE(this.storage);
    }

    @Phantom proc _removeIf_loop (i: int, filter: Predicate): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        if (action CALL(filter, [item]))
            action LIST_REMOVE(this.storage, i);
    }


    @KeepVisible proc _equalsRange (other: List, from: int, to: int): boolean
    {
        result = true;
        var i: int = from;

        var otherStorage: list<Object> = null;

        if (other has ArrayListAutomaton)
        {
            otherStorage = ArrayListAutomaton(other).storage;

            // assumptions: no multithreading, from == 0
            result = to == action LIST_SIZE(otherStorage);
            if (result)
                action LOOP_WHILE(
                    result && i < to,
                    _equalsRange_loop_optimized(i, otherStorage, result)
                );
        }
        else if (other has ArrayList_SubListAutomaton)
        {
            val otherRoot: ArrayList = ArrayList_SubListAutomaton(other).root;
            otherStorage = ArrayListAutomaton(otherRoot).storage;

            // assumptions: no multithreading, from >= 0
            result = to == ArrayList_SubListAutomaton(other).length;
            if (result)
                action LOOP_WHILE(
                    result && i < to,
                    _equalsRange_loop_optimized(i, otherStorage, result)
                );
        }
        else
        {
            val iter: Iterator = action CALL_METHOD(other, "iterator", []);
            action LOOP_WHILE(
                result && i < to && action CALL_METHOD(iter, "hasNext", []),
                _equalsRange_loop_regular(iter, i, result)
            );

            result &= !action CALL_METHOD(iter, "hasNext", []);
        }
    }

    @Phantom proc _equalsRange_loop_optimized (i: int, otherStorage: list<Object>, result: boolean): void
    {
        val a: Object = action LIST_GET(otherStorage, i);
        val b: Object = action LIST_GET(this.storage, i);

        result = action OBJECT_EQUALS(a, b);

        i += 1;
    }

    @Phantom proc _equalsRange_loop_regular (iter: Iterator, i: int, result: boolean): void
    {
        val a: Object = action CALL_METHOD(iter, "next", []);
        val b: Object = action LIST_GET(this.storage, i);

        result = action OBJECT_EQUALS(a, b);

        i += 1;
    }


    proc _makeStream (parallel: boolean): Stream
    {
        val count: int = action LIST_SIZE(this.storage);
        val items: array<Object> = action ARRAY_NEW("java.lang.Object", count);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, count, +1,
            _makeStream_loop(i, items)
        );

        // #problem: unable to catch concurrent modifications during stream processing

        result = new StreamAutomaton(state = Initialized,
            storage = items,
            length = count,
            closeHandlers = action LIST_NEW(),
            isParallel = parallel,
        );
    }

    @Phantom proc _makeStream_loop (i: int, items: array<Object>): void
    {
        items[i] = action LIST_GET(this.storage, i);
    }


    @KeepVisible proc _batchRemove (c: Collection, complement: boolean, start: int, end: int): boolean
    {
        if (c == null)
            _throwNPE();

        val oldLength: int = action LIST_SIZE(this.storage);
        if (oldLength == 0 || start >= end)
        {
            result = false;
        }
        else
        {
            val otherLength: int = action CALL_METHOD(c, "size", []);
            if (otherLength == 0)
            {
                if (complement)
                {
                    result = true;
                    this.storage = action LIST_NEW();
                    this.modCount += 1;
                }
                else
                {
                    result = false;
                }
            }
            else
            {
                action ASSUME(otherLength > 0);

                var i: int = 0;
                start -= 1;
                end -= 1;

                if (c has ArrayListAutomaton)
                {
                    val otherStorage: list<Object> = ArrayListAutomaton(c).storage;
                    action ASSUME(otherStorage != null);

                    action LOOP_FOR(
                        i, end, start, -1,
                        _batchRemove_loop_optimized(i, otherStorage, complement)
                    );
                }
                else
                {
                    action LOOP_FOR(
                        i, end, start, -1,
                        _batchRemove_loop_regular(i, c, complement)
                    );
                }

                result = oldLength != action LIST_SIZE(this.storage);
            }
        }
    }

    @Phantom proc _batchRemove_loop_optimized (i: int, otherStorage: list<Object>, complement: boolean): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        if ((action LIST_FIND(otherStorage, item, 0, action LIST_SIZE(this.storage)) == -1) == complement)
            _deleteElement(i);
    }

    @Phantom proc _batchRemove_loop_regular (i: int, c: Collection, complement: boolean): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        if (action CALL_METHOD(c, "contains", [item]) != complement)
            _deleteElement(i);
    }


    // sort every item in the list within [start, end) range
    @KeepVisible proc _do_sort (start: int, end: int, c: Comparator): void
    {
        if (start < end)
        {
            val expectedModCount: int = this.modCount;

            // Java has no unsigned primitive data types
            action ASSUME(start >= 0);
            action ASSUME(end > 0);

            // plain bubble sorting algorithm
            val outerLimit: int = end - 1;
            var innerLimit: int = 0;
            var i: int = 0;
            var j: int = 0;

            // check the comparator
            if (c == null)
            {
                // using Comparable::compareTo as a comparator

                // plain bubble sorting algorithm
                action LOOP_FOR(
                    i, start, outerLimit, +1,
                    sort_loop_outer_noComparator(i, j, innerLimit, start, end)
                );
            }
            else
            {
                // using the provided comparator

                // plain bubble sorting algorithm (with a comparator)
                action LOOP_FOR(
                    i, start, outerLimit, +1,
                    sort_loop_outer(i, j, innerLimit, start, end, c)
                );
            }

            _checkForComodification(expectedModCount);
        }

        this.modCount += 1;
    }

    @Phantom proc sort_loop_outer_noComparator (i: int, j: int, innerLimit: int, start: int, end: int): void
    {
        innerLimit = end - i - 1;
        action LOOP_FOR(
            j, start, innerLimit, +1,
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

    @Phantom proc sort_loop_outer (i: int, j: int, innerLimit: int, start: int, end: int, c: Comparator): void
    {
        innerLimit = end - i - 1;
        action LOOP_FOR(
            j, start, innerLimit, +1,
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


    // constructors

    constructor *.`<init>` (@target self: ArrayList)
    {
        this.storage = action LIST_NEW();
    }


    constructor *.`<init>` (@target self: ArrayList, c: Collection)
    {
        if (c == null)
            _throwNPE();

        this.storage = action LIST_NEW();

        _addAllElements(0, c);
    }


    constructor *.`<init>` (@target self: ArrayList, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            //val message: String = "Illegal Capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }
        this.storage = action LIST_NEW();
    }


    // methods

    fun *.add (@target self: ArrayList, e: Object): boolean
    {
        action LIST_INSERT_AT(this.storage, action LIST_SIZE(this.storage), e);

        this.modCount += 1;

        result = true;
    }


    fun *.add (@target self: ArrayList, index: int, element: Object): void
    {
        _addElement(index, element);
    }


    fun *.addAll (@target self: ArrayList, c: Collection): boolean
    {
        result = _addAllElements(action LIST_SIZE(this.storage), c);
    }


    fun *.addAll (@target self: ArrayList, index: int, c: Collection): boolean
    {
        _rangeCheckForAdd(index);
        result = _addAllElements(index, c);
    }


    fun *.clear (@target self: ArrayList): void
    {
        this.storage = action LIST_NEW();
        this.modCount += 1;
    }


    fun *.clone (@target self: ArrayList): Object
    {
        val storageCopy: list<Object> = action LIST_NEW();
        action LIST_COPY(this.storage, storageCopy, 0, 0, action LIST_SIZE(this.storage));

        result = new ArrayListAutomaton(state = Initialized,
            storage = storageCopy,
        );
    }


    fun *.contains (@target self: ArrayList, o: Object): boolean
    {
        result = action LIST_FIND(this.storage, o, 0, action LIST_SIZE(this.storage)) != -1;
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: ArrayList, c: Collection): boolean
    {
        result = true;

        if (c has ArrayListAutomaton)
        {
            val otherStorage: list<Object> = ArrayListAutomaton(c).storage;
            action ASSUME(otherStorage != null);

            val otherLength: int = action LIST_SIZE(otherStorage);
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
        result = action LIST_FIND(this.storage, item, 0, action LIST_SIZE(this.storage)) != -1;

        i += 1;
    }

    @Phantom proc containsAll_loop_regular (iter: Iterator, result: boolean): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        result = action LIST_FIND(this.storage, item, 0, action LIST_SIZE(this.storage)) != -1;
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

                if (action LIST_SIZE(this.storage) == action LIST_SIZE(otherStorage))
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
            this.modCount == expectedModCount && i < action LIST_SIZE(this.storage),
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
        _checkValidIndex(index, action LIST_SIZE(this.storage));

        result = action LIST_GET(this.storage, index);
    }


    fun *.hashCode (@target self: ArrayList): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.indexOf (@target self: ArrayList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, action LIST_SIZE(this.storage));
    }


    fun *.isEmpty (@target self: ArrayList): boolean
    {
        result = action LIST_SIZE(this.storage) == 0;
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
        result = -1;

        val size: int = action LIST_SIZE(this.storage);
        if (size != 0)
        {
            action ASSUME(size > 0);

            val items: list<Object> = this.storage;

            var i: int = 0;
            action LOOP_FOR(
                i, size - 1, -1, -1,
                lastIndexOf_loop(i, items, o, result)
            );
        }
    }

    @Phantom proc lastIndexOf_loop (i: int, items: list<Object>, o: Object, result: int): void
    {
        val e: Object = action LIST_GET(items, i);

        if (action OBJECT_EQUALS(o, e))
        {
            result = i;
            action LOOP_BREAK();
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
        result = _makeStream(/* parallel = */true);
    }


    fun *.remove (@target self: ArrayList, o: Object): boolean
    {
        val index: int = action LIST_FIND(this.storage, o, 0, action LIST_SIZE(this.storage));
        result = index != -1;
        if (result)
            _deleteElement(index);
    }


    fun *.remove (@target self: ArrayList, index: int): Object
    {
        result = _deleteElement(index);
    }


    fun *.removeAll (@target self: ArrayList, c: Collection): boolean
    {
        result = _batchRemove(c, /* complement = */false, 0, action LIST_SIZE(this.storage));
    }


    fun *.removeIf (@target self: ArrayList, filter: Predicate): boolean
    {
        result = _removeIf(filter, 0, action LIST_SIZE(this.storage));
    }


    fun *.replaceAll (@target self: ArrayList, op: UnaryOperator): void
    {
        if (op == null)
            _throwNPE();

        _replaceAllRange(op, 0, action LIST_SIZE(this.storage));
        this.modCount += 1;
    }


    fun *.retainAll (@target self: ArrayList, c: Collection): boolean
    {
        result = _batchRemove(c, /* complement = */true, 0, action LIST_SIZE(this.storage));
    }


    fun *.set (@target self: ArrayList, index: int, element: Object): Object
    {
        result = _setElement(index, element);
    }


    fun *.size (@target self: ArrayList): int
    {
        result = action LIST_SIZE(this.storage);
    }


    fun *.sort (@target self: ArrayList, c: Comparator): void
    {
        _do_sort(0, action LIST_SIZE(this.storage), c);
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
        result = _makeStream(/* parallel = */false);
    }


    fun *.subList (@target self: ArrayList, fromIndex: int, toIndex: int): List
    {
        _subListRangeCheck(fromIndex, toIndex, action LIST_SIZE(this.storage));

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
        val len: int = action LIST_SIZE(this.storage);
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

        val len: int = action LIST_SIZE(this.storage);
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
        val len: int = action LIST_SIZE(this.storage);

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
    @private fun *.writeObject (@target self: ArrayList, s: ObjectOutputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun *.readObject (@target self: ArrayList, s: ObjectInputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }

}
