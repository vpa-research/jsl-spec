///#! pragma: non-synthesizable
libsl "1.1.0";

library `std`
    version "11"
    language "Java"
    url "-";

// imports

import java.common;
import java/lang/_interfaces;
import java/io/_interfaces;
import java/util/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;

import list.actions;


// local semantic types

@extends("java.util.AbstractList<Object>")
@implements("java.util.List<Object>")
@implements("java.util.RandomAccess")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public @final type ArrayList
    is java.util.ArrayList
    for Object
{
    //@private @static @final var serialVersionUID: long = 8683452581122892189;
}


// automata

automaton ArrayListAutomaton
(
)
: ArrayList
{
    var storage: list<Object>;
    var length: int;
    @transient var modCount: int;

    initstate Allocated;
    state Initialized;

    // constructors
    shift Allocated -> Initialized by [
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

    //constructors

    constructor ArrayList (@target self: ArrayList, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            var initCapacity: string = action OBJECT_TO_STRING(initialCapacity);
            var message: string = "Illegal Capacity: " + initCapacity;
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
    }


    constructor ArrayList (@target self: ArrayList)
    {
        action LIST_RESIZE(this.storage, 0);
    }


    constructor ArrayList (@target self: ArrayList, c: Collection)
    {
        // TODO: interface calls
        action NOT_IMPLEMENTED();
    }


    // subroutines

    proc _checkValidIndex (index: int, length: int): void
    {
        if (index < 0 || index >= length)
        {
            var idx: string = action OBJECT_TO_STRING(index);
            var len: string = action OBJECT_TO_STRING(length);
            var message: string = "Index "+ idx + " out of bounds for length "+ len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _rangeCheckForAdd (index: int, length: int): void
    {
        if (index < 0 || index > length)
        {
            var idx: string = action OBJECT_TO_STRING(index);
            var len: string = action OBJECT_TO_STRING(length);
            var message: string = "Index: " + idx + ", Size: " + len;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _addAllElements (index:int, c:Collection): boolean
    {
        this.modCount += 1;

        // #problem:
        //we don't know how to avoid cycle in this method;
        //for e in c:
        //   storage.add(e);
        action NOT_IMPLEMENTED();

        //At this moment we can't work with Collection, because this is interface.
        //this.length = this.length + c.size();
    }


    // checks range [from, to) against [0, size)
    proc _subListRangeCheck (fromIndex: int, toIndex: int, size: int): void
    {
        if (fromIndex < 0)
        {
            var from: string = action OBJECT_TO_STRING(fromIndex);
            var message: String = "fromIndex = " + from;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (toIndex > size)
        {
            var to: string = action OBJECT_TO_STRING(toIndex);
            var message: String = "toIndex = " + to;
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (fromIndex > toIndex)
        {
            var from: string = action OBJECT_TO_STRING(fromIndex);
            var to: string = action OBJECT_TO_STRING(toIndex);
            var message: String = "fromIndex(" + from + ") > toIndex(" + to + ")";
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
    }


    proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

    proc _deleteElement (index: int): Object
    {
        _checkValidIndex(index, this.length);
        result = action LIST_GET(this.storage, index);
        action LIST_REMOVE(this.storage, index, 1);
        this.modCount += 1;
        this.length -= 1;
    }


    proc _addElement (index: int, element: Object): void
    {
        _rangeCheckForAdd(index, this.length);
        this.modCount += 1;
        action LIST_INSERT_AT(this.storage, index, element);
        this.length += 1;
    }


    proc _setElement (index: int, element: Object): Object
    {
        _checkValidIndex(index, this.length);
        result = action LIST_GET(this.storage, index);
        action LIST_SET(this.storage, index, element);
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    //methods

    fun trimToSize (@target self: ArrayList): void
    {
        this.modCount += 1;
    }


    fun ensureCapacity (@target self: ArrayList, minCapacity: int): void
    {
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
        result = action LIST_FIND(this.storage, o, 0, this.length, +1) >= 0;
    }


    fun indexOf (@target self: ArrayList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, 0, this.length, +1);
    }



    fun lastIndexOf (@target self: ArrayList, o: Object): int
    {
        result = action LIST_FIND(this.storage, o, this.length-1, -1, -1);
    }


    fun clone (@target self: ArrayList): Object
    {
        var storageCopy: list<Object> = action LIST_DUP(this.storage);
        result = new ArrayListAutomaton(
            state=Initialized, storage=storageCopy, length=this.length);
    }


    fun toArray (@target self: ArrayList): array<Object>
    {
        // #problem
        //How to create a new array correctly ?
        //var a: array<int> = null;
        //result = action LIST_TO_ARRAY(this.storage, a, 0, this.length);
        action NOT_IMPLEMENTED();
    }


    fun toArray (@target self: ArrayList, a: array<Object>): array<Object>
    {
        result = action LIST_TO_ARRAY(this.storage, a, 0, this.length);
    }


    fun get (@target self: ArrayList, index: int): Object
    {
        _checkValidIndex(index, this.length);
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

                action DO("other._checkForComodification(otherExpectedModCount)"); // #problem
                action DO("this._checkForComodification(expectedModCount)");       // #problem
            }
            else
            {
                result = false;
            }
        }
    }


    fun toString (@target self: ArrayList): String
    {
        action NOT_IMPLEMENTED();
    }


    fun hashCode (@target self: ArrayList): int
    {
         result = action OBJECT_HASH_CODE(this.storage);
    }


    fun remove (@target self: ArrayList, o: Object): boolean
    {
        var index: int = action LIST_FIND(this.storage, o, 0, this.length, +1);
        if (index == -1)
        {
            result = false;
        }
        else
        {
            action LIST_REMOVE(this.storage, index, 1);
            result = true;
        }
    }


    fun clear (@target self: ArrayList): void
    {
        action LIST_RESIZE(this.storage, 0);
        this.length = 0;
        this.modCount += 1;
    }


    fun addAll (@target self: ArrayList, c: Collection): boolean
    {
        result = _addAllElements(this.length, c);
    }



    fun addAll (@target self: ArrayList, index: int, c: Collection): boolean
    {
        _rangeCheckForAdd(index, this.length);
        result = _addAllElements(index, c);
    }


    fun removeAll (@target self: ArrayList, c: Collection): boolean
    {
        // TODO: interface call
        action NOT_IMPLEMENTED();
    }


    fun retainAll (@target self: ArrayList, c: Collection): boolean
    {
        // TODO: interface call
        action NOT_IMPLEMENTED();
    }


    @throws(["java.io.IOException"])
    @private fun writeObject (@target self: ArrayList, s: ObjectOutputStream): void
    {
        var expectedModCount: int = this.modCount;

        // #problem
        //Here is cycle and some operations with ObjectOutputStream.
        action NOT_IMPLEMENTED();

        if (this.modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun readObject (@target self: ArrayList, s: ObjectInputStream): void
    {
        // #problem
        //Here is cycle and some operations with ObjectInputStream.
        action NOT_IMPLEMENTED();
    }


    fun listIterator (@target self: ArrayList, index: int): ListIterator
    {
        /*this._rangeCheckForAdd(index, this.length);

        result = new ListItr(state=Created,
            cursor=index,
            expectedModCount=this.modCount);*/
        action TODO();
    }


    fun listIterator (@target self: ArrayList): ListIterator
    {
        /*result = new ListItr(state=Created,
            cursor=0,
            expectedModCount=this.modCount);*/
        action TODO();
    }


    fun iterator (@target self: ArrayList): Iterator
    {
        /*result = new ListItr(state=Created,
            cursor=0,
            expectedModCount=this.modCount);*/
        action TODO();
    }


    fun subList (@target self: ArrayList, fromIndex: int, toIndex: int): List
    {
        _subListRangeCheck(fromIndex, toIndex, this.length);

        // #problem
        //We don't have decision about sublists.
        action TODO();
        /*result = new SubList(state=Created,
            startIndex=fromIndex,
            endIndex=toIndex);*/
    }


    fun forEach (@target self: ArrayList, anAction: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun spliterator (@target self: ArrayList): Spliterator
    {
        /*result = new ArrayListSpliterator(state=Initialized,
            origin = 0,
            est=-1,
            expectedModCount=0);*/
        action TODO();
    }


    fun removeIf (@target self: ArrayList, filter: Predicate): boolean
    {
        if (filter == null)
        {
            _throwNPE();
        }

        var expectedModCount: int = modCount;

        // #problem
        // Action CALL can't work with cycles.
        action NOT_IMPLEMENTED();

        //var res = action CALL(filter, [storage]);
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


    fun replaceAll (@target self: ArrayList, op: UnaryOperator): void
    {
        if (op == null)
        {
            _throwNPE();
        }

        var expectedModCount: int = modCount;

        // #problem
        // Action CALL can't work with cycles.
        // action CALL(op, [storage]);

        action NOT_IMPLEMENTED();

        if (this.modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }

        this.modCount += 1;
    }


    fun sort (@target self: ArrayList, c: Comparator): void
    {
        var expectedModCount: int = modCount;

        // #problem
        //We don't know what to do with sorting of the List.
        action NOT_IMPLEMENTED();

        if (this.modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }

        this.modCount += 1;
    }
}


/*
@packagePrivate
@implements(["java.util.ListIterator"])
automaton ListItr: int (
    var cursor: int,
    var lastRet: int = -1,
    var expectedModCount: int
) {

    initstate Initialized;
    state Allocated;

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
       forEachRemaining,
       previous,
       set,
       add
    ]

    //constructors


    constructor ListItr(index: int)
    {
        action ERROR("Dangerous behavior, IDK");
    }


    //methods


    fun hasPrevious (): boolean
    {
        result = this.cursor != 0;
    }


    fun nextIndex (): int
    {
        result = this.cursor;
    }


    fun previousIndex (): int
    {
        result = this.cursor - 1;
    }


    fun hasNext (): boolean
    {
        result = this.cursor != this.parent.length;
    }


    fun next (): Object
    {
        this.parent._checkForComodification(this.expectedModCount);
        var i: int = this.cursor;

        if (i >= this.parent.length)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        // #problem
        //I don't know what to do with ConcurrentModificationException(); ?
        action NOT_IMPLEMENTED();

        this.cursor = i + 1;
        this.lastRet = i;
        result = action LIST_GET(this.parent.storage, this.lastRet);
    }


    fun previous (): Object
    {
        this.parent._checkForComodification(this.expectedModCount);
        var i: int = this.cursor - 1;

        if (i < 0)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        // #problem
        //I don't know what to do with ConcurrentModificationException(); ?
        action NOT_IMPLEMENTED();

        this.cursor = i;
        this.lastRet = i;
        result = action LIST_GET(this.parent.storage, this.lastRet);
    }


    fun remove (): void
    {
        if (this.lastRet < 0)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        this.parent._checkForComodification(this.expectedModCount);

        // #problem
        //What i must to do with try-catch in this method ?
        action NOT_IMPLEMENTED();

        this.parent._deleteElement(this.lastRet);
        this.cursor = this.lastRet;
        this.lastRet = -1;
        this.expectedModCount = this.parent.modCount;
    }


    fun set (e: Object): void
    {
        if (this.lastRet < 0)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        this.parent._checkForComodification(this.expectedModCount);

        // #problem
        //What i must to do with try-catch in this method ?
        action NOT_IMPLEMENTED();

        this.parent._setElement(this.lastRet, e);
    }


    fun add (e: Object): void
    {
        this.parent._checkForComodification(this.expectedModCount);

        // #problem
        //What i must to do with try-catch in this method ?
        action NOT_IMPLEMENTED();

        var i: int = this.cursor;
        this.parent._addElement(this.parent.length, e);
        this.cursor = i + 1;
        this.lastRet = -1;
        this.expectedModCount = this.parent.modCount;
    }


    fun forEachRemaining (action: Consumer): void
    {
        // TODO: loops and interface calls
        action NOT_IMPLEMENTED();
    }

}
*/


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
        action NOT_IMPLEMENTED();
    }


    fun tryAdvance (action: Consumer): void
    {
        action NOT_IMPLEMENTED();
    }


    fun forEachRemaining (action: Consumer): void
    {
        action NOT_IMPLEMENTED();
    }


    fun estimateSize (): long
    {
        action NOT_IMPLEMENTED();
    }


    fun characteristics (): int
    {
        action NOT_IMPLEMENTED();
    }

}
*/


//@private
//@static
//@extends("java.util.AbstractList")
//@implements("java.util.RandomAccess")
//@WrapperMeta(
//    src="java.util.ArrayList$SubList",
//    dst="org.utbot.engine.overrides.collections.ArrayList_SubList",
//    forceMatchInterfaces=true,
//)
//automaton SubList: int(
//    @private @final var index: offset,
//    @private var length: int,
//    @transient var modCount: int,

//)
//{

//    initstate Initialized;

//    shift Allocated -> Initialized by [
//    ];

//    shift Initialized -> self by [
//       // read operations

//       // write operations
//    ]


//    //constructors


//    constructor SubList(startIndex: int, endIndex: int)
//    {
//        offset = startIndex;
//        length = endIndex - startIndex;
//        modCount = this.parent.modCount;
//    }


//    @private
//    constructor SubList(parentList: SubList, startIndex: int, endIndex: int)
//    {
//        // #problem
//        //???
//        offset = startIndex;
//        length = endIndex - startIndex;
//        modCount = this.parent.modCount;
//    }


//    //subs

//    proc _addAllElements (index:int, c:Collection): boolean
//    {
//        this.parent._rangeCheckForAdd(index, length);

//        //I use suppose that Collection interface will have size sub or analog
//        var collectionSize = c.size();

//        if (collectionSize == 0)
//        {
//            result = false;
//        }
//        else
//        {
//            this.parent._checkForComodification(modCount);

//            var curIndex = offset + index;

//            this.parent._addAllElements(index, c);

//            _updateSizeAndModCount(collectionSize);

//            result = true;
//        }
//    }


//    proc _updateSizeAndModCount (sizeChange: int): void
//    {
//        // #problem
//        //Here is cycle
//        action NOT_IMPLEMENTED();
//    }


//    proc _indexOfElement (o: Object): int
//    {
//        var index = action LIST_FIND(this.parent.storage, o);
//        this.parent._checkForComodification(modCount);

//        if (index >= 0)
//        {
//            result = index - offset;
//        }
//        else
//        {
//            result = -1;
//        }
//    }


//    //methods


//     fun set (index: int, element: Object): void
//     {
//         this.parent._checkValidIndex(index, length);
//         this.parent._checkForComodification(modCount);

//         var curIndex = offset + index;

//         result = action LIST_GET(this.parent.storage, curIndex);
//         action LIST_SET(this.parent.storage, curIndex, element);
//     }


//     fun get (index: int): Object
//     {
//         this.parent._checkValidIndex(index, length);
//         this.parent._checkForComodification(modCount);

//         var curIndex = offset + index;

//         result = action LIST_GET(this.parent.storage, curIndex);
//     }


//     fun size (): int
//     {
//         this.parent._checkForComodification(modCount);
//         result = length;
//     }


//     fun add (index: int, element: Object): void
//     {
//         this.parent._rangeCheckForAdd(index, length);
//         this.parent._checkForComodification(modCount);

//         var curIndex = offset + index;
//         this.parent._addElement(curIndex, element);

//         _updateSizeAndModCount(1);
//     }


//     fun remove (index: int): Object
//     {
//         this.parent._checkValidIndex(index, length);
//         this.parent._checkForComodification(modCount);

//         var curIndex = offset + index;

//         result = this.parent._deleteElement(curIndex);

//         _updateSizeAndModCount(-1);
//     }


//     fun addAll (c: Collection): boolean
//     {
//         _addAllElements(length, c);
//     }


//     fun addAll (index: int, c: Collection): boolean
//     {
//         _addAllElements(index, c);
//     }


//     fun replaceAll (operator: UnaryOperator): void
//     {
//         // #problem
//         action NOT_IMPLEMENTED();
//     }


//     fun removeAll (c: Collection): boolean
//     {
//         // #problem
//         action NOT_IMPLEMENTED();
//     }


//     fun retainAll (c: Collection): boolean
//     {
//         // #problem
//         action NOT_IMPLEMENTED();
//     }


//     fun removeIf (filter: Predicate): boolean
//     {
//         // #problem
//         action NOT_IMPLEMENTED();
//     }


//     fun toArray (): array<Object>
//     {
//         // #problem
//         //How set size of the array ?
//         var a: array<int>;

//         var end = offset + length;
//         result = action LIST_TO_ARRAY(storage, a, offset, end);
//     }


//     fun toArray (a: list<Object>): array<Object>
//     {
//         var end = offset + length;
//         result = action LIST_TO_ARRAY(storage, a, offset, end);
//     }


//     fun equals (o: Object): boolean
//     {
//         // #problem
//         action NOT_IMPLEMENTED();
//     }


//     fun hashCode (): int
//     {
//         // result = action OBJECT_HASH_CODE(self);
//         // #problem
//         action NOT_IMPLEMENTED();
//     }


//     fun indexOf (o: Object): int
//     {
//         result = _indexOfElement(o);
//     }


//     fun lastIndexOf (o: Object): int
//     {
//         //I must think about this new action.
//         action NOT_IMPLEMENTED();
//     }


//     fun contains (o: Object): boolean
//     {
//         result = _indexOfElement(o) >= 0;
//     }


//     fun subList (fromIndex: int, toIndex: int): List
//     {
//         this.parent._subListRangeCheck(fromIndex, toIndex, length);
//         result = new SubList(state=Created,
//             //Think about THIS !
//             //TODO
//             parentList = self,
//             startIndex=fromIndex,
//             endIndex=toIndex);
//     }


//     fun iterator (): Iterator
//     {

//     }


//     fun spliterator (): Spliterator
//     {
//         action NOT_IMPLEMENTED();
//     }

// }



// @packagePrivate
// @extends("java.util.ArrayList$Itr")
// @implements("java.util.Iterator")
// @WrapperMeta(
//     src="java.util.ArrayList$SubList$1",
//     //Maybe will be another name of the dst class
//     dst="ru.spbpu.libsl.overrides.collections.ArrayList_SubList_Itr",
//     forceMatchInterfaces=true)
// automaton ListItr: int (
//     var cursor: int,
//     var lastRet: int = -1,
//     var expectedModCount: int
// ) {


//     //subs


//     proc _checkForComodification (expectedModCount: int): void
//     {
//         if (modCount != expectedModCount)
//         {
//             action THROW_NEW("java.util.ConcurrentModificationException", []);
//         }
//     }


//     //methods


//     fun hasNext(): boolean
//     {
//         result = cursor != this.parent.length;
//     }


//     fun next(): Object
//     {
//         _checkForComodification(this.parent.modCount);

//     }


// }

