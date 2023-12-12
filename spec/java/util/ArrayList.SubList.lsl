libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java/util/ArrayList;


// automata

automaton ArrayList_SubListAutomaton
(
    var root: ArrayList,
    var parentList: ArrayList_SubList,
    var offset: int,
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
        `<init>` (ArrayList_SubList, ArrayList, int, int),
        `<init>` (ArrayList_SubList, ArrayList_SubList, int, int),
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

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _checkForComodification(): void
    {
        ArrayListAutomaton(this.root)._checkForComodification(this.modCount);
    }


    proc _addAllElements (index: int, c: Collection): boolean
    {
        action ASSUME(this.root != null);

        val effectiveIndex: int = this.offset + index;
        ArrayListAutomaton(this.root)._rangeCheckForAdd(effectiveIndex);

        val collectionSize: int = action CALL_METHOD(c, "size", []);
        if (collectionSize == 0)
        {
            result = false;
        }
        else
        {
            result = true;

            _checkForComodification();
            ArrayListAutomaton(this.root)._addAllElements(effectiveIndex, c);
            _updateSizeAndModCount(collectionSize);
        }
    }


    @KeepVisible proc _updateSizeAndModCount (sizeChange: int): void
    {
        action ASSUME(this.root != null);

        // update self first
        this.length += sizeChange;
        this.modCount = ArrayListAutomaton(this.root).modCount;

        // then propagate changes up the chain
        var aList: ArrayList_SubList = this.parentList;
        action LOOP_WHILE(
            aList != null,
            _updateSizeAndModCount_loop(aList, sizeChange)
        );
    }

    @Phantom proc _updateSizeAndModCount_loop (aList: ArrayList_SubList, sizeChange: int): void
    {
        ArrayList_SubListAutomaton(aList).length += sizeChange;
        ArrayList_SubListAutomaton(aList).modCount = this.modCount;

        aList = ArrayList_SubListAutomaton(aList).parentList;
    }


    proc _indexOfElement (o: Object): int
    {
        action ASSUME(this.root != null);

        _checkForComodification();
        val parentStorage: list<Object> = ArrayListAutomaton(this.root).storage;

        val index: int = action LIST_FIND(parentStorage, o, this.offset, this.offset + this.length);
        if (index != -1)
            result = index - this.offset;
        else
            result = -1;
    }


    proc _makeStream (parallel: boolean): Stream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
        action ASSUME(action CALL_METHOD(result, "isParallel", []) == parallel);
    }


    proc _batchRemove (c: Collection, complement: boolean): boolean
    {
        action ASSUME(this.root != null);
        _checkForComodification();

        if (this.length != 0)
        {
            val oldRootLength: int = action LIST_SIZE(ArrayListAutomaton(this.root).storage);

            result = ArrayListAutomaton(this.root)._batchRemove(c, complement, this.offset, this.offset + this.length);
            if (result)
            {
                val newRootLength: int = action LIST_SIZE(ArrayListAutomaton(this.root).storage);
                _updateSizeAndModCount(newRootLength - oldRootLength);
            }
        }
        else
        {
            result = false;
        }
    }


    // constructors

    constructor *.`<init>` (@target self: ArrayList_SubList, root: ArrayList, fromIndex: int, toIndex: int)
    {
        // #problem: this constructor is useless
        action NOT_IMPLEMENTED("inaccessible constructor");
    }


    @private constructor *.`<init>` (@target self: ArrayList_SubList, parent: ArrayList_SubList, fromIndex: int, toIndex: int)
    {
        // #problem: this constructor is useless
        action NOT_IMPLEMENTED("inaccessible constructor");
    }


    // static methods

    // methods

    // within java.util.AbstractList
    fun *.add (@target self: ArrayList_SubList, e: Object): boolean
    {
        action ASSUME(this.root != null);

        _checkForComodification();

        val effectiveIndex: int = this.offset + this.length;
        ArrayListAutomaton(this.root)._addElement(effectiveIndex, e);

        _updateSizeAndModCount(+1);
    }


    fun *.add (@target self: ArrayList_SubList, index: int, element: Object): void
    {
        action ASSUME(this.root != null);

        _checkForComodification();

        val effectiveIndex: int = this.offset + index;
        ArrayListAutomaton(this.root)._addElement(effectiveIndex, element);

        _updateSizeAndModCount(+1);
    }


    fun *.addAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        _addAllElements(this.length, c);
    }


    fun *.addAll (@target self: ArrayList_SubList, index: int, c: Collection): boolean
    {
        _addAllElements(index, c);
    }


    // within java.util.AbstractList
    fun *.clear (@target self: ArrayList_SubList): void
    {
        action ASSUME(this.root != null);
        _checkForComodification();

        val size: int = this.length;
        if (size != 0)
        {
            action ASSUME(size > 0);
            val end: int = this.offset - 1;
            val start: int = end + size;

            val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;

            var i: int = 0;
            action LOOP_FOR(
                i, start, end, -1,
                clear_loop(i, rootStorage)
            );

            ArrayListAutomaton(this.root).modCount += 1;

            _updateSizeAndModCount(-size);
        }
    }

    @Phantom proc clear_loop (i: int, rootStorage: list<Object>): void
    {
        action LIST_REMOVE(rootStorage, i);
    }


    fun *.contains (@target self: ArrayList_SubList, o: Object): boolean
    {
        result = _indexOfElement(o) != -1;
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        result = true;

        if (!action CALL_METHOD(c, "isEmpty", []))
        {
            action ASSUME(this.root != null);

            val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;
            val end: int = this.offset + this.length;

            if (c has ArrayList_SubListAutomaton)
            {
                val otherRoot: ArrayList = ArrayList_SubListAutomaton(c).root;
                action ASSUME(otherRoot != null);

                val otherStorage: list<Object> = ArrayListAutomaton(otherRoot).storage;
                val otherOffset: int = ArrayList_SubListAutomaton(c).offset;
                val otherEnd: int = otherOffset + ArrayList_SubListAutomaton(c).length;

                action ASSUME(otherStorage != null);
                action ASSUME(otherOffset >= 0);
                action ASSUME(otherEnd >= 0);

                var i: int = otherOffset;
                action LOOP_WHILE(
                    result && i < otherEnd,
                    containsAll_loop_optimized(rootStorage, end, otherStorage, i, result)
                );
            }
            else
            {
                val iter: Iterator = action CALL_METHOD(c, "iterator", []);
                action LOOP_WHILE(
                    result && action CALL_METHOD(iter, "hasNext", []),
                    containsAll_loop_regular(rootStorage, end, iter, result)
                );
            }
        }
    }

    @Phantom proc containsAll_loop_optimized (rootStorage: list<Object>, end: int, otherStorage: list<Object>, i: int, result: boolean): void
    {
        val item: Object = action LIST_GET(otherStorage, i);
        result = action LIST_FIND(rootStorage, item, this.offset, end) != -1;

        i += 1;
    }

    @Phantom proc containsAll_loop_regular (rootStorage: list<Object>, end: int, iter: Iterator, result: boolean): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        result = action LIST_FIND(rootStorage, item, this.offset, end) != -1;
    }


    fun *.equals (@target self: ArrayList_SubList, o: Object): boolean
    {
        if (o == self)
        {
            result = true;
        }
        else
        {
            result = o has ArrayList_SubListAutomaton;
            if (result)
            {
                action ASSUME(this.root != null);

                val otherLength: int = ArrayList_SubListAutomaton(o).length;
                action ASSUME(otherLength >= 0);

                result = this.length == otherLength;
                if (result)
                {
                    result = ArrayListAutomaton(this.root)._equalsRange(o as List, this.offset, this.offset + this.length);
                    _checkForComodification();
                }
            }
        }
    }


    // within java.lang.Iterable
    fun *.forEach (@target self: ArrayList_SubList, _action: Consumer): void
    {
        if (this.length != 0)
        {
            action ASSUME(this.length > 0);
            action ASSUME(this.root != null);

            val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;
            val expectedModCount: int = ArrayListAutomaton(this.root).modCount;

            this.modCount = expectedModCount;

            var i: int = this.offset;
            val end: int = this.offset + this.length;
            action LOOP_WHILE(
                i < end && ArrayListAutomaton(this.root).modCount == expectedModCount,
                forEach_loop(i, rootStorage, _action)
            );

            ArrayListAutomaton(this.root)._checkForComodification(expectedModCount);
        }
    }

    @Phantom proc forEach_loop (i: int, rootStorage: list<Object>, _action: Consumer): void
    {
        val item: Object = action LIST_GET(rootStorage, i);
        action CALL(_action, [item]);

        i += 1;
    }


    fun *.get (@target self: ArrayList_SubList, index: int): Object
    {
        action ASSUME(this.root != null);

        ArrayListAutomaton(this.root)._checkValidIndex(index, this.length);
        _checkForComodification();

        val effectiveIndex: int = this.offset + index;
        result = action LIST_GET(ArrayListAutomaton(this.root).storage, effectiveIndex);
    }


    fun *.hashCode (@target self: ArrayList_SubList): int
    {
        result = 1;

        if (this.length != 0)
        {
            action ASSUME(this.length > 0);
            action ASSUME(this.root != null);
            val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;

            var i: int = this.offset;
            val end: int = this.offset + this.length;
            action LOOP_FOR(
                i, i, end, +1,
                hashCode_loop(i, rootStorage, result)
            );

            _checkForComodification();
        }
    }

    @Phantom proc hashCode_loop (i: int, rootStorage: list<Object>, result: int): void
    {
        val item: Object = action LIST_GET(rootStorage, i);
        result = 31 * result + action OBJECT_HASH_CODE(item);
    }


    fun *.indexOf (@target self: ArrayList_SubList, o: Object): int
    {
        result = _indexOfElement(o);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: ArrayList_SubList): boolean
    {
        result = this.length == 0;
    }


    fun *.iterator (@target self: ArrayList_SubList): Iterator
    {
        result = new ArrayList_SubList_ListIteratorAutomaton(state = Initialized,
            root = this.root,
            sublist = self,
            cursor = 0,
            expectedModCount = this.modCount,
            offset = this.offset,
            size = this.length,
        );
    }


    fun *.lastIndexOf (@target self: ArrayList_SubList, o: Object): int
    {
        action ASSUME(this.root != null);
        _checkForComodification();

        if (this.length == 0)
        {
            result = -1;
        }
        else
        {
            action ASSUME(this.length > 0);

            val end: int = this.offset + this.length;
            val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;

            result = action LIST_FIND(rootStorage, o, this.offset, end);
            if (result != -1)
            {
                // there should be no elements to the right of the previously found position
                val nextIndex: int = result + 1;
                if (nextIndex < end)
                {
                    val rightIndex: int = action LIST_FIND(rootStorage, o, nextIndex, end);
                    action ASSUME(rightIndex == -1);
                }

                result -= this.offset;
            }
        }
    }


    // within java.util.AbstractList
    fun *.listIterator (@target self: ArrayList_SubList): ListIterator
    {
        result = new ArrayList_SubList_ListIteratorAutomaton(state = Initialized,
            root = this.root,
            sublist = self,
            cursor = 0,
            expectedModCount = this.modCount,
            offset = this.offset,
            size = this.length,
        );
    }


    fun *.listIterator (@target self: ArrayList_SubList, index: int): ListIterator
    {
        result = new ArrayList_SubList_ListIteratorAutomaton(state = Initialized,
            root = this.root,
            sublist = self,
            cursor = index,
            expectedModCount = this.modCount,
            offset = this.offset,
            size = this.length,
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: ArrayList_SubList): Stream
    {
        result = _makeStream(/* parallel = */true);
    }


    // within java.util.AbstractCollection
    fun *.remove (@target self: ArrayList_SubList, o: Object): boolean
    {
        action ASSUME(this.root != null);

        val end: int = this.offset + this.length;
        val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;

        val index: int = action LIST_FIND(rootStorage, o, this.offset, end);
        result = index != -1;

        if (result)
        {
            _checkForComodification();
            ArrayListAutomaton(this.root)._deleteElement(index);

            _updateSizeAndModCount(-1);
        }
    }


    fun *.remove (@target self: ArrayList_SubList, index: int): Object
    {
        action ASSUME(this.root != null);

        ArrayListAutomaton(this.root)._checkValidIndex(index, this.length);
        _checkForComodification();

        val effectiveIndex: int = this.offset + index;
        result = ArrayListAutomaton(this.root)._deleteElement(effectiveIndex);

        _updateSizeAndModCount(-1);
    }


    fun *.removeAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        _batchRemove(c, false);
    }


    fun *.removeIf (@target self: ArrayList_SubList, filter: Predicate): boolean
    {
        action ASSUME(this.root != null);
        _checkForComodification();

        val size: int = this.length;
        if (size != 0)
        {
            val oldRootLength: int = action LIST_SIZE(ArrayListAutomaton(this.root).storage);

            result = ArrayListAutomaton(this.root)._removeIf(filter, this.offset, this.offset + this.length);
            if (result)
            {
                val newRootLength: int = action LIST_SIZE(ArrayListAutomaton(this.root).storage);
                _updateSizeAndModCount(newRootLength - oldRootLength);
            }
        }
        else
        {
            result = false;
        }
    }


    fun *.replaceAll (@target self: ArrayList_SubList, operator: UnaryOperator): void
    {
        action ASSUME(this.root != null);
        ArrayListAutomaton(this.root)._replaceAllRange(operator, this.offset, this.offset + this.length);
    }


    fun *.retainAll (@target self: ArrayList_SubList, c: Collection): boolean
    {
        _batchRemove(c, true);
    }


    fun *.set (@target self: ArrayList_SubList, index: int, element: Object): Object
    {
        action ASSUME(this.root != null);

        ArrayListAutomaton(this.root)._checkValidIndex(index, this.length);
        _checkForComodification();

        val parentStorage: list<Object> = ArrayListAutomaton(this.root).storage;
        val effectiveIndex: int = this.offset + index;
        result = action LIST_GET(parentStorage, effectiveIndex);
        action LIST_SET(parentStorage, effectiveIndex, element);
    }


    fun *.size (@target self: ArrayList_SubList): int
    {
        action ASSUME(this.root != null);

        _checkForComodification();
        result = this.length;
    }


    // within java.util.List
    fun *.sort (@target self: ArrayList_SubList, c: Comparator): void
    {
        action ASSUME(this.root != null);
        ArrayListAutomaton(this.root)._do_sort(this.offset, this.offset + this.length, c);
        this.modCount = ArrayListAutomaton(this.root).modCount;
    }


    fun *.spliterator (@target self: ArrayList_SubList): Spliterator
    {
        result = new ArrayList_SubList_SpliteratorAutomaton(state = Initialized,
            root = this.root,
            parent = self,
        );
    }


    // within java.util.Collection
    fun *.stream (@target self: ArrayList_SubList): Stream
    {
        result = _makeStream(/* parallel = */false);
    }


    fun *.subList (@target self: ArrayList_SubList, fromIndex: int, toIndex: int): List
    {
        action ASSUME(this.root != null);

        ArrayListAutomaton(this.root)._subListRangeCheck(fromIndex, toIndex, this.length);

        result = new ArrayList_SubListAutomaton(state = Initialized,
            root = this.root,
            parentList = self,
            offset = this.offset + fromIndex,
            length = toIndex - fromIndex,
            modCount = this.modCount,
        );
    }


    fun *.toArray (@target self: ArrayList_SubList): array<Object>
    {
        action ASSUME(this.root != null);
        _checkForComodification();

        result = action ARRAY_NEW("java.lang.Object", this.length);

        val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;
        val end: int = this.offset + this.length;
        var i: int = 0;
        var j: int = 0;
        action LOOP_FOR(
            i, this.offset, end, +1,
            toArray_loop(i, j, result, rootStorage)
        );
    }

    @Phantom proc toArray_loop (i: int, j: int, result: array<Object>, rootStorage: list<Object>): void
    {
        result[j] = action LIST_GET(rootStorage, i);
        j += 1;
    }


    // within java.util.Collection
    fun *.toArray (@target self: ArrayList_SubList, generator: IntFunction): array<Object>
    {
        // acting just like JDK
        val a: array<Object> = action CALL(generator, [0]) as array<Object>;
        val aSize: int = action ARRAY_SIZE(a);

        action ASSUME(this.root != null);
        _checkForComodification();

        result = action ARRAY_NEW("java.lang.Object", this.length);

        val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;
        val end: int = this.offset + this.length;
        var i: int = 0;
        var j: int = 0;
        action LOOP_FOR(
            i, this.offset, end, +1,
            toArray_loop(i, j, result, rootStorage)
        );
    }


    fun *.toArray (@target self: ArrayList_SubList, a: array<Object>): array<Object>
    {
        action ASSUME(this.root != null);
        _checkForComodification();

        val aSize: int = action ARRAY_SIZE(a);
        if (aSize < this.length)
            // #problem: a.getClass() should be called to construct a type-valid array (USVM issue)
            a = action ARRAY_NEW("java.lang.Object", this.length);

        result = a;

        val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;
        val end: int = this.offset + this.length;
        var i: int = 0;
        var j: int = 0;
        action LOOP_FOR(
            i, this.offset, end, +1,
            toArray_loop(i, j, result, rootStorage)
        );

        if (aSize > this.length)
            result[aSize] = null;
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: ArrayList_SubList): String
    {
        if (this.length == 0)
        {
            result = "[]";
        }
        else
        {
            result = "[";

            action ASSUME(this.root != null);

            val rootStorage: list<Object> = ArrayListAutomaton(this.root).storage;

            var i: int = this.offset;
            val end: int = this.offset + this.length;
            var counter: int = this.length;
            action LOOP_FOR(
                i, i, end, +1,
                toString_loop(i, rootStorage, result, counter)
            );

            result += "]";
        }
    }

    @Phantom proc toString_loop (i: int, rootStorage: list<Object>, result: String, counter: int): void
    {
        val item: Object = action LIST_GET(rootStorage, i);
        result += action OBJECT_TO_STRING(item);

        counter -= 1;
        if (counter != 0)
            result += ", ";
    }

}
