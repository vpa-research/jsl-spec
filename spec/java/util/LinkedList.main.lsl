libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedList.java";

// imports

import java/util/stream/Stream;

import java/util/LinkedList;


// automata

automaton LinkedListAutomaton
(
    var storage: list<Object>
)
: LinkedList
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        LinkedList (LinkedList),
        LinkedList (LinkedList, Collection),
    ];

    shift Initialized -> self by [
        // instance methods
        add (LinkedList, Object),
        add (LinkedList, int, Object),
        addAll (LinkedList, Collection),
        addAll (LinkedList, int, Collection),
        addFirst,
        addLast,
        clear,
        clone,
        contains,
        containsAll,
        descendingIterator,
        element,
        equals,
        forEach,
        get,
        getFirst,
        getLast,
        hashCode,
        indexOf,
        isEmpty,
        iterator,
        lastIndexOf,
        listIterator (LinkedList),
        listIterator (LinkedList, int),
        offer,
        offerFirst,
        offerLast,
        parallelStream,
        peek,
        peekFirst,
        peekLast,
        poll,
        pollFirst,
        pollLast,
        pop,
        push,
        remove (LinkedList),
        remove (LinkedList, Object),
        remove (LinkedList, int),
        removeAll,
        removeFirst,
        removeFirstOccurrence,
        removeIf,
        removeLast,
        removeLastOccurrence,
        replaceAll,
        retainAll,
        set,
        size,
        sort,
        spliterator,
        stream,
        subList,
        toArray (LinkedList),
        toArray (LinkedList, IntFunction),
        toArray (LinkedList, array<Object>),
        toString,
    ];

    // internal variables

    @transient var modCount: int = 0;


    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @KeepVisible proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
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


    @KeepVisible proc _unlinkAny (index: int): Object
    {
        result = action LIST_GET(this.storage, index);
        action LIST_REMOVE(this.storage, index);
        this.modCount += 1;
    }


    @KeepVisible proc _linkAny (index: int, e: Object): void
    {
        action LIST_INSERT_AT(this.storage, index, e);
        this.modCount += 1;
    }


    @KeepVisible proc _checkElementIndex (index: int, size: int): void
    {
        if (!_isValidIndex(index, size))
        {
            //val message: String =
            //    "Index: " + action OBJECT_TO_STRING(index) +
            //    ", Size: " + action OBJECT_TO_STRING(size);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }
    }


    proc _isValidIndex (index: int, size: int): boolean
    {
        result = 0 <= index && index < size;
    }


    proc _isPositionIndex (index: int): boolean
    {
        result = 0 <= index && index <= action LIST_SIZE(this.storage);
    }


    @KeepVisible proc _checkPositionIndex (index: int): void
    {
        if (!_isPositionIndex(index))
        {
            //val message: String =
            //    "Index: " + action OBJECT_TO_STRING(index) +
            //    ", Size: " + action OBJECT_TO_STRING(action LIST_SIZE(this.storage));
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }
    }


    proc _unlinkFirst (): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = _unlinkAny(0);
    }


    proc _unlinkByFirstEqualsObject (o: Object): boolean
    {
        val index: int = action LIST_FIND(this.storage, o, 0, action LIST_SIZE(this.storage));
        result = index != -1;
        if (result)
        {
            action LIST_REMOVE(this.storage, index);
            this.modCount += 1;
        }
    }


    @KeepVisible proc _addAllElements (index: int, @Parameterized(["E"]) c: Collection): boolean
    {
        _checkPositionIndex(index);
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
    }


    proc _getFirstElement (): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = action LIST_GET(this.storage, 0);
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

        val oldSize: int = action LIST_SIZE(this.storage);
        val expectedModCount: int = this.modCount;

        // remove elements from the back first
        action ASSUME(start <= end);
        var i: int = 0;
        action LOOP_FOR(
            i, end - 1, start, -1,
            _removeIf_loop(i, filter)
        );

        _checkForComodification(expectedModCount);

        result = oldSize != action LIST_SIZE(this.storage);
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

        var otherLength: int = 0;
        var otherStorage: list<Object> = null;

        if (other has LinkedListAutomaton)
        {
            otherStorage = LinkedListAutomaton(other).storage;
            otherLength = action LIST_SIZE(otherStorage);

            // assumptions: no multithreading, from == 0
            result = to == otherLength;
            if (result)
                action LOOP_WHILE(
                    result && i < to,
                    _equalsRange_loop_optimized(i, otherStorage, result)
                );
        }
        /*else if (other has LinkedList_SubListAutomaton)
        {
            otherLength = LinkedList_SubListAutomaton(other).size;
            action ASSUME(otherLength >= 0);

            // assumptions: no multithreading, from >= 0
            result = to == otherLength;
            if (result)
            {
                val otherRoot: LinkedList = LinkedList_SubListAutomaton(other).root;
                action ASSUME(otherRoot != null);

                otherStorage = LinkedListAutomaton(otherRoot).storage;
                action ASSUME(otherStorage != null);

                action LOOP_WHILE(
                    result && i < to,
                    _equalsRange_loop_optimized(i, otherStorage, result)
                );
            }
        }*/
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
        val oldSize: int = action LIST_SIZE(this.storage);
        if (oldSize == 0 || start >= end)
        {
            result = false;
        }
        else
        {
            val otherLength: int = action CALL_METHOD(c, "size", []);
            if (otherLength == 0)
            {
                result = false;
            }
            else
            {
                action ASSUME(otherLength > 0);

                var i: int = 0;
                start -= 1;
                end -= 1;

                if (c has LinkedListAutomaton)
                {
                    val otherStorage: list<Object> = LinkedListAutomaton(c).storage;
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

                result = oldSize != action LIST_SIZE(this.storage);
            }
        }
    }

    @Phantom proc _batchRemove_loop_optimized (i: int, otherStorage: list<Object>, complement: boolean): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        if ((action LIST_FIND(otherStorage, item, 0, action LIST_SIZE(this.storage)) == -1) == complement)
            _unlinkAny(i);
    }

    @Phantom proc _batchRemove_loop_regular (i: int, c: Collection, complement: boolean): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        if (action CALL_METHOD(c, "contains", [item]) != complement)
            _unlinkAny(i);
    }


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

    constructor *.LinkedList (@target self: LinkedList)
    {
        this.storage = action LIST_NEW();
    }


    constructor *.LinkedList (@target self: LinkedList, c: Collection)
    {
        if (c == null)
            _throwNPE();

        this.storage = action LIST_NEW();

        _addAllElements(action LIST_SIZE(this.storage), c);
    }


    // methods

    fun *.add (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(action LIST_SIZE(this.storage), e);
        result = true;
    }


    fun *.add (@target self: LinkedList, index: int, element: Object): void
    {
        _checkPositionIndex(index);
        _linkAny(index, element);
    }


    fun *.addAll (@target self: LinkedList, c: Collection): boolean
    {
        result = _addAllElements(action LIST_SIZE(this.storage), c);
    }


    fun *.addAll (@target self: LinkedList, index: int, c: Collection): boolean
    {
        result = _addAllElements(index, c);
    }


    fun *.addFirst (@target self: LinkedList, e: Object): void
    {
        _linkAny(0, e);
    }


    fun *.addLast (@target self: LinkedList, e: Object): void
    {
        _linkAny(action LIST_SIZE(this.storage), e);
    }


    fun *.clear (@target self: LinkedList): void
    {
        this.storage = action LIST_NEW();
        this.modCount += 1;
    }


    fun *.clone (@target self: LinkedList): Object
    {
        val storageCopy: list<Object> = action LIST_NEW();
        action LIST_COPY(this.storage, storageCopy, 0, 0, action LIST_SIZE(this.storage));

        result = new LinkedListAutomaton(state = Initialized,
            storage = storageCopy
        );
    }


    fun *.contains (@target self: LinkedList, o: Object): boolean
    {
        result = action LIST_FIND(this.storage, o, 0, action LIST_SIZE(this.storage)) != -1;
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: LinkedList, c: Collection): boolean
    {
        result = true;

        if (c has LinkedListAutomaton)
        {
            val otherStorage: list<Object> = LinkedListAutomaton(c).storage;
            val otherSize: int = action LIST_SIZE(otherStorage);

            action ASSUME(otherStorage != null);
            action ASSUME(otherSize >= 0);

            var i: int = 0;
            action LOOP_WHILE(
                result && i < otherSize,
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


    fun *.descendingIterator (@target self: LinkedList): Iterator
    {
        // #problem: not implemented
        /*
        result = new DescendingIterator(state = Created);
        */
        result = action SYMBOLIC("java.util.Iterator");
        action ASSUME(result != null);
    }


    fun *.element (@target self: LinkedList): Object
    {
        result = _getFirstElement();
    }


    // within java.util.AbstractList
    fun *.equals (@target self: LinkedList, o: Object): boolean
    {
        if (self == o)
        {
            result = true;
        }
        else
        {
            if (o has LinkedListAutomaton)
            {
                val expectedModCount: int = this.modCount;
                val otherExpectedModCount: int = LinkedListAutomaton(o).modCount;

                val otherStorage: list<Object> = LinkedListAutomaton(o).storage;

                if (action LIST_SIZE(this.storage) == action LIST_SIZE(otherStorage))
                {
                    result = action OBJECT_EQUALS(this.storage, otherStorage);
                }
                else
                {
                    result = false;
                }

                LinkedListAutomaton(o)._checkForComodification(otherExpectedModCount);
                _checkForComodification(expectedModCount);
            }
            else
            {
                result = false;
            }
        }
    }


    // within java.lang.Iterable
    fun *.forEach (@target self: LinkedList, _action: Consumer): void
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

    @Phantom proc forEach_loop(i: int, _action: Consumer): void
    {
        val item: Object = action LIST_GET(this.storage, i);
        action CALL(_action, [item]);

        i += 1;
    }


    fun *.get (@target self: LinkedList, index: int): Object
    {
        _checkElementIndex(index, action LIST_SIZE(this.storage));
        result = action LIST_GET(this.storage, index);
    }


    fun *.getFirst (@target self: LinkedList): Object
    {
        result = _getFirstElement();
    }


    fun *.getLast (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = action LIST_GET(this.storage, action LIST_SIZE(this.storage) - 1);
    }


    // within java.util.AbstractList
    fun *.hashCode (@target self: LinkedList): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.indexOf (@target self: LinkedList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, action LIST_SIZE(this.storage));
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: LinkedList): boolean
    {
        result = action LIST_SIZE(this.storage) == 0;
    }


    // within java.util.AbstractSequentialList
    fun *.iterator (@target self: LinkedList): Iterator
    {
        result = new LinkedList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
            expectedModCount = this.modCount
        );
    }


    fun *.lastIndexOf (@target self: LinkedList, o: Object): int
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


    // within java.util.AbstractList
    fun *.listIterator (@target self: LinkedList): ListIterator
    {
        result = new LinkedList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = 0,
            expectedModCount = this.modCount
        );
    }


    fun *.listIterator (@target self: LinkedList, index: int): ListIterator
    {
        _checkPositionIndex(index);

        result = new LinkedList_ListIteratorAutomaton(state = Initialized,
            parent = self,
            cursor = index,
            expectedModCount = this.modCount
        );
    }


    fun *.offer (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(action LIST_SIZE(this.storage), e);
        result = true;
    }


    fun *.offerFirst (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(0, e);
        result = true;
    }


    fun *.offerLast (@target self: LinkedList, e: Object): boolean
    {
        _linkAny(action LIST_SIZE(this.storage), e);
        result = true;
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: LinkedList): Stream
    {
        result = _makeStream(/* parallel = */true);
    }


    fun *.peek (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            result = null;
        else
            result = action LIST_GET(this.storage, 0);
    }


    fun *.peekFirst (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            result = null;
        else
            result = action LIST_GET(this.storage, 0);
    }


    fun *.peekLast (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            result = null;
        else
            result = action LIST_GET(this.storage, action LIST_SIZE(this.storage) - 1);
    }


    fun *.poll (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            result = null;
        else
            result = _unlinkAny(0);
    }


    fun *.pollFirst (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            result = null;
        else
            result = _unlinkAny(0);
    }


    fun *.pollLast (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            result = null;
        else
            result = _unlinkAny(action LIST_SIZE(this.storage) - 1);
    }


    fun *.pop (@target self: LinkedList): Object
    {
        result = _unlinkFirst();
    }


    fun *.push (@target self: LinkedList, e: Object): void
    {
        _linkAny(0, e);
    }


    fun *.remove (@target self: LinkedList): Object
    {
        result = _unlinkFirst();
    }


    fun *.remove (@target self: LinkedList, o: Object): boolean
    {
        result = _unlinkByFirstEqualsObject(o);
    }


    fun *.remove (@target self: LinkedList, index: int): Object
    {
        _checkElementIndex(index, action LIST_SIZE(this.storage));
        result = _unlinkAny(index);
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: LinkedList, c: Collection): boolean
    {
        result = _batchRemove(c, /* complement = */false, 0, action LIST_SIZE(this.storage));
    }


    fun *.removeFirst (@target self: LinkedList): Object
    {
        result = _unlinkFirst();
    }


    fun *.removeFirstOccurrence (@target self: LinkedList, o: Object): boolean
    {
        result = _unlinkByFirstEqualsObject(o);
    }


    // within java.util.Collection
    fun *.removeIf (@target self: LinkedList, filter: Predicate): boolean
    {
        result = _removeIf(filter, 0, action LIST_SIZE(this.storage));
    }


    fun *.removeLast (@target self: LinkedList): Object
    {
        if (action LIST_SIZE(this.storage) == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = _unlinkAny(action LIST_SIZE(this.storage) - 1);
    }


    fun *.removeLastOccurrence (@target self: LinkedList, o: Object): boolean
    {
        val index: int = action LIST_FIND(this.storage, o, 0, action LIST_SIZE(this.storage));
        if (index == -1)
        {
            result = false;
        }
        else
        {
            result = true;

            // there should be no elements to the right of the previously found position
            val nextIndex: int = index + 1;
            if (nextIndex < action LIST_SIZE(this.storage))
            {
                val rightIndex: int = action LIST_FIND(this.storage, o, nextIndex, action LIST_SIZE(this.storage));
                action ASSUME(rightIndex == -1);
            }

            // actual removal and associated modifications
            action LIST_REMOVE(this.storage, index);
            this.modCount += 1;
        }
    }


    // within java.util.List
    fun *.replaceAll (@target self: LinkedList, op: UnaryOperator): void
    {
        if (op == null)
            _throwNPE();

        _replaceAllRange(op, 0, action LIST_SIZE(this.storage));
        this.modCount += 1;
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: LinkedList, c: Collection): boolean
    {
        result = _batchRemove(c, /* complement = */true, 0, action LIST_SIZE(this.storage));
    }


    fun *.set (@target self: LinkedList, index: int, element: Object): Object
    {
        _checkElementIndex(index, action LIST_SIZE(this.storage));
        result = action LIST_GET(this.storage, index);
        action LIST_SET(this.storage, index, element);
    }


    fun *.size (@target self: LinkedList): int
    {
        result = action LIST_SIZE(this.storage);
    }


    // within java.util.List
    fun *.sort (@target self: LinkedList, c: Comparator): void
    {
        _do_sort(0, action LIST_SIZE(this.storage), c);
    }


    fun *.spliterator (@target self: LinkedList): Spliterator
    {
        result = new LinkedList_SpliteratorAutomaton(state = Initialized,
            parent = self,
        );
    }


    // within java.util.Collection
    fun *.stream (@target self: LinkedList): Stream
    {
        result = _makeStream(/* parallel = */false);
    }


    // within java.util.AbstractList
    fun *.subList (@target self: LinkedList, fromIndex: int, toIndex: int): List
    {
        _subListRangeCheck(fromIndex, toIndex, action LIST_SIZE(this.storage));

        result = new LinkedList_SubListAutomaton(state = Initialized,
            root = self,
            parentList = null,
            offset = fromIndex,
            length = toIndex - fromIndex,
            modCount = this.modCount,
        );
    }


    fun *.toArray (@target self: LinkedList): array<Object>
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
    fun *.toArray (@target self: LinkedList, generator: IntFunction): array<Object>
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


    fun *.toArray (@target self: LinkedList, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = action LIST_SIZE(this.storage);
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
