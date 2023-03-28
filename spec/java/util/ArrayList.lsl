libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";
import "list-actions.lsl";
import "java/util/interfaces.lsl"
import "java/util/function/interfaces.lsl"

//For generation this imports are needed:
include java.util.AbstractList;
include java.util.ArrayList;
include java.util.Collection;
include java.util.Iterator;
include java.util.List;
include java.util.ListIterator;
include java.util.NoSuchElementException;
include java.util.Objects;
include java.util.RandomAccess;
include java.util.function.Consumer;
include java.util.function.Predicate;
include java.util.function.UnaryOperator;
include java.util.stream.Stream;

// automata

@extends("java.util.AbstractList")
@implements(["java.util.List", "java.util.RandomAccess","java.lang.Cloneable","java.io.Serializable"])
@WrapperMeta(
    src="java.util.ArrayList",
    dst="ru.spbpu.libsl.overrides.collections.ArrayList",
    forceMatchInterfaces=true)
automaton ArrayList: int (
    @private @static @final var serialVersionUID: long = 8683452581122892189,
    @transient var storage: List<Object> = null,
    var length: int = 0,
    @transient var modCount: int = 0
) {

    initstate Allocated;
    state Initialized;

    // constructors
    shift Allocated -> Initialized by [
        ArrayList(),
        ArrayList(int),
        ArrayList(Collection)
    ];

    shift Initialized -> self by [
        // read operations
        contains,
        get,
        indexOf,
        isEmpty,
        lastIndexOf,
        size

        toString,
        hashCode,
        clone,

        iterator,
        listIterator(),
        listIterator(int),
        spliterator,
        subList,
        toArray(),
        toArray(array<Object>)

        // write operations
        add(Object),
        add(int, Object),
        addAll(Collection),
        addAll(int, Collection),
        clear,
        ensureCapacity,
        forEach,
        remove(int),
        remove(Object),
        removeAll,
        removeIf,
        replaceAll,
        retainAll,
        set,
        sort,
        trimToSize
    ];

    //constructors

    constructor ArrayList (initialCapacity: int)
    {
        if (initialCapacity >= 0)
        {
            action LIST_RESIZE(storage, initialCapacity);
        }
        else
        {
            var message = "Illegal Capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.NoSuchElementException", [message]);
        }
    }


    constructor ArrayList ()
    {
        action LIST_RESIZE(storage, 0);
    }


    constructor ArrayList (c: Collection)
    {
        //I suppose that "c" is another automaton and it has "toArray" sub (or with another sub name).
        //That's why we can invoke this.
        //action ARRAY_TO_LIST(c.toArray(), storage);
        // #problem:
        //In the next code of the original class can be such situation:  https://bugs.openjdk.java.net/browse/JDK-6260652
        //(you can see at the original class); But as a understand, this bug can be reproduced only
        //in jdk 1.5; We must think about this ? Or we don't have to do anything with it ?
        //It wasn't reproduced in JDK  11.0.1

        action NOT_IMPLEMENTED();
    }


    //subs

    proc _checkValidIndex (index: int, length: int): void
    {
        if (index < 0 || index >= length)
        {
            var message = "Index "+ action OBJECT_TO_STRING(index) + " out of bounds for length "+ action OBJECT_TO_STRING(length);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _rangeCheckForAdd (index: int, length: int): void
    {
        if (index < 0 || index > length)
        {
            var message = "Index: " + action OBJECT_TO_STRING(index) + ", Size: " + action OBJECT_TO_STRING(length);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _addAllElements (index:int, c:Collection): boolean
    {
        modCount = modCount + 1;

        // #problem:
        //we don't know how to avoid cycle in this method;
        //for e in c:
        //   storage.add(e);
        action NOT_IMPLEMENTED();

        length = length + c.size();
    }

    proc _subListRangeCheck (int fromIndex, int toIndex, int size): void
    {
        if (fromIndex < 0)
        {
            var message: String = "fromIndex = " + action OBJECT_TO_STRING(fromIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (toIndex > size)
        {
            var message: String = "toIndex = " + action OBJECT_TO_STRING(toIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (fromIndex > toIndex)
        {
            var message: String = "fromIndex(" + action OBJECT_TO_STRING(fromIndex) + ") > toIndex(" + action OBJECT_TO_STRING(toIndex) + ")";
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
    }


    proc _checkForComodification (expectedModCount: int): void
    {
        if (modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

    proc _deleteElement (index: int): Object
    {
        _checkValidIndex(index, length);
        result = action LIST_GET(storage, index);
        action LIST_REMOVE(storage, index, 1);
        modCount = modCount + 1;
        length = length - 1;
    }


    proc _addElement (index: int, e: Object): void
    {
        _rangeCheckForAdd(index, length);
        modCount = modCount + 1;
        action LIST_INSERT_AT(storage, index, e);
        length = length + 1;
    }


    proc _setElement (index: int, e: Object): Object
    {
        _checkValidIndex(index, length);
        result = action LIST_GET(storage, index);
        action LIST_SET(storage, index, element);
    }


    //methods

    fun trimToSize (): void
    {
        modCount = modCount + 1;
        //As we work with List we mustn't resize it... Or not ?
    }


    fun ensureCapacity (minCapacity: int): void
    {
        modCount = modCount + 1;
        //As we work with List we mustn't resize it... Or not ?
    }


    fun size (): int
    {
        result = length;
    }


    fun isEmpty (): boolean
    {
        result = length == 0;
    }


    fun contains (o: Object): boolean
    {
        result = action LIST_FIND(storage, o, 0, length, +1) >= 0;
    }


    fun indexOf (o: Object): int
    {
        result = action LIST_FIND(storage, o, 0, length, +1);
    }



    fun lastIndexOf (o: Object): int
    {
        result = action LIST_FIND(storage, o, 0, length, -1);
    }


    fun clone (): Object
    {
        storageCopy = action LIST_DUP(storage);
        result = new ArrayList(
            state=self.state, storage=storageCopy, length=self.length);
    }


    fun toArray (): array<Object>
    {
        // #problem
        //How to create a new array correctly ?
        var a: array<int>;
        result = action LIST_TO_ARRAY(storage, a, 0, length);
    }


    fun toArray (a: list<Object>): array<Object>
    {
        result = action LIST_TO_ARRAY(storage, a, 0, length);
    }


    fun get (index: int): Object
    {
        _checkValidIndex(index, length);
        result = action LIST_GET(storage, index);
    }


    fun set (index: int, element: Object): Object
    {
        result = _setElement(index, element);
    }


    fun add (e: Object): boolean
    {
        modCount = modCount + 1;
        action LIST_INSERT_AT(storage, length, e);
        length = length + 1;
        result = true;
    }


    fun add (index: int, element: Object): void
    {
        _addElement(index, e);
    }


    fun remove (index: int): Object
    {
        result = _deleteElement(index);
    }


    fun equals (other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            // #problem
            //We don't know at this moment how create this method.
            action NOT_IMPLEMENTED();
        }
    }


    fun hashCode (): int
    {
        // result = action OBJECT_HASH_CODE(self);
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun remove (o: Object): boolean
    {
        var index = action LIST_FIND(storage, o, 0, length, +1);
        if (index == -1)
        {
            result = false;
        }
        else
        {
            action LIST_REMOVE(storage, index, 1);
            result = true;
        }
    }


    fun clear (): void
    {
        action LIST_RESIZE(storage, 0);
        length = 0;
        modCount = modCount + 1;
    }


    fun addAll (c: Collection): boolean
    {
        result = _addAllElements(length, c);
    }



    fun addAll (index: int, c: Collection): boolean
    {
        _rangeCheckForAdd(index, length);
        result = _addAllElements(index, c);
    }


    fun removeAll (c: Collection): boolean
    {
        // #problem.
        //I want to create such action:

        //define action SUBTRACTING_SETS(
        //        aListSubtracting: array<any>,
        //        aListDeductible: array<any>
        //    ): list<any>;

        //But Collection isn't List.
        //But it has method: toArray();
        //Maybe we must have two arrays as params ?

        //storage = action SUBTRACTING_SETS(storage, c);

        action NOT_IMPLEMENTED();
    }


    fun retainAll (c: Collection): boolean
    {
        // #problem.
        //I want to create such action:

        //define action INTERSECTION(
        //        aListSubtracting: array<any>,
        //        aListDeductible: array<any>
        //    ): list<any>;

        //But Collection isn't List.
        //But it has method: toArray();
        //Maybe we must have two arrays as params ?

        //storage = action INTERSECTION(storage, c);

        action NOT_IMPLEMENTED();
    }


    @private
    @throws(["java.io.IOException"])
    fun writeObject (s: ObjectOutputStream): void
    {
        var expectedModCount = modCount;

        // #problem
        //Here is cycle and some operations with ObjectOutputStream.
        action NOT_IMPLEMENTED();

        if (modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    @private
    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    fun readObject (s: ObjectInputStream): void
    {
        // #problem
        //Here is cycle and some operations with ObjectInputStream.
        action NOT_IMPLEMENTED();
    }


    fun listIterator (index: int): ListIterator
    {
        _rangeCheckForAdd(index, length);

        result = new ListItr(state=Created,
            cursor=index,
            expectedModCount=modCount);
    }


    fun listIterator (): ListIterator
    {
        result = new ListItr(state=Created,
            cursor=0,
            expectedModCount=modCount);
    }


    fun iterator (): Iterator
    {
        result = new Itr(state=Created,
            expectedModCount=modCount);
    }


    fun subList (fromIndex: int, toIndex: int): List
    {
        _subListRangeCheck(fromIndex, toIndex, length);

        // #problem
        //We don't have decision about sublists.
        //TODO
        result = new SubList(state=Created,
            startIndex=fromIndex,
            endIndex=toIndex);
    }


    fun forEach (action: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun spliterator (): Spliterator
    {
        result = new ArrayListSpliterator(state=Initialized,
            //This is right ? "parent=self"
            parent=self,
            origin = 0,
            est=-1,
            expectedModCount=0);
    }


    fun removeIf (filter: Predicate): boolean
    {
        // #problem
        //We don't know how to work with lambda.
        action NOT_IMPLEMENTED();
    }


    fun replaceAll (operator: UnaryOperator): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun sort (c: Comparator): void
    {
        var expectedModCount = modCount;

        // #problem
        //We don't know what to do with sorting of the List.
        action NOT_IMPLEMENTED();

        if (modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }

        modCount = modCount + 1;
    }
}



@packagePrivate
@implements("java.util.Iterator")
@WrapperMeta(
    src="java.util.ArrayList$Itr",
    //Maybe will be another name of the dst class
    dst="ru.spbpu.libsl.overrides.collections.ArrayList_Itr",
    forceMatchInterfaces=true)
automaton Itr: int (
    var cursor: int,
    var lastRet: int = -1,
    var expectedModCount: int
) {

    initstate Initialized;

    shift Allocated -> Initialized by [
        Itr()
    ];

    shift Initialized -> self by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
        forEachRemaining
    ]


    // constructors


    //Maybe here is needed @DefaultModifier ?
    constructor Itr()
    {
    }


    // methods


    fun hasNext (): boolean
    {
        result = cursor != self.parent.length;
    }


    fun next (): Object
    {
        self.parent._checkForComodification(expectedModCount);
        var i = cursor;

        if (i >= parent.length)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        // #problem
        //I don't know what to do with ConcurrentModificationException(); ?

        cursor = i + 1;
        lastRet = i;
        result = action LIST_GET(self.parent.storage, lastRet);
    }


    fun remove (): void
    {
        if (lastRet < 0)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        self.parent._checkForComodification(expectedModCount);

        // #problem
        //What i must to do with try-catch in this method ?

        self.parent._deleteElement(lastRet);
        cursor = lastRet;
        lastRet = -1;
        expectedModCount = self.parent.modCount;
    }


    fun forEachRemaining (action: Consumer): void
    {
        action NOT_IMPLEMENTED();
    }

}



@packagePrivate
@extends("java.util.ArrayList$Itr")
@implements("java.util.Iterator")
@WrapperMeta(
    src="java.util.ArrayList$ListItr",
    //Maybe will be another name of the dst class
    dst="ru.spbpu.libsl.overrides.collections.ArrayList_ListItr",
    forceMatchInterfaces=true)
automaton ListItr: int (
    var cursor: int,
    var lastRet: int = -1,
    var expectedModCount: int
) {

    initstate Initialized;

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
        // #problem
        //How invoke super() ??
        cursor = index;
    }


    //methods


    fun hasPrevious (): boolean
    {
        result = cursor != 0;
    }


    fun nextIndex (): int
    {
        result = cursor;
    }


    fun previousIndex (): int
    {
        result = cursor - 1;
    }


    fun hasNext (): boolean
    {
        result = cursor != self.parent.length;
    }


    fun next (): Object
    {
        self.parent._checkForComodification(expectedModCount);
        var i = cursor;

        if (i >= parent.length)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        // #problem
        //I don't know what to do with ConcurrentModificationException(); ?

        cursor = i + 1;
        lastRet = i;
        result = action LIST_GET(self.parent.storage, lastRet);
    }


    fun previous (): Object
    {
        self.parent._checkForComodification(expectedModCount);
        var i = cursor - 1;

        if (i < 0)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        // #problem
        //I don't know what to do with ConcurrentModificationException(); ?

        cursor = i;
        lastRet = i;
        result = action LIST_GET(self.parent.storage, lastRet);
    }


    fun remove (): void
    {
        if (lastRet < 0)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        self.parent._checkForComodification(expectedModCount);

        // #problem
        //What i must to do with try-catch in this method ?

        self.parent._deleteElement(lastRet);
        cursor = lastRet;
        lastRet = -1;
        expectedModCount = self.parent.modCount;
    }

    fun set (e: Object): void
    {
        if (lastRet < 0)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }

        self.parent._checkForComodification(expectedModCount);

        // #problem
        //What i must to do with try-catch in this method ?

        self.parent._setElement(lastRet, e);
    }


    fun add (e: Object): void
    {
        self.parent._checkForComodification(expectedModCount);

        // #problem
        //What i must to do with try-catch in this method ?

        var i = cursor;
        self.parent._addElement(self.parent.length, e);
        cursor = i + 1;
        lastRet = -1;
        expectedModCount = self.parent.modCount;
    }


    fun forEachRemaining (action: Consumer): void
    {
        action NOT_IMPLEMENTED();
    }

}



@final
@implements("java.util.Spliterator")
@WrapperMeta(
    src="java.util.ArrayList$ArrayListSpliterator",
    dst="org.utbot.engine.overrides.collections.ArrayList$UtArrayListSpliterator",
    forceMatchInterfaces=true,
)
automaton ArrayListSpliterator: int(
    var index: int,
    var fence: int,
    var expectedModCount: int
)
{

    initstate Initialized;

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
        self.index = origin;
        self.fence = fence;
        self.expectedModCount = expectedModCount;
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



@private
@static
@extends("java.util.AbstractList")
@implements("java.util.RandomAccess")
@WrapperMeta(
    src="java.util.ArrayList$SubList",
    dst="org.utbot.engine.overrides.collections.ArrayList_SubList",
    forceMatchInterfaces=true,
)
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
        modCount = self.parent.modCount;
    }


    @private
    constructor SubList(parentList: SubList, startIndex: int, endIndex: int)
    {
        // #problem
        //???
        offset = startIndex;
        length = endIndex - startIndex;
        modCount = self.parent.modCount;
    }


    //subs

    proc _addAllElements (index:int, c:Collection): boolean
    {
        self.parent._rangeCheckForAdd(index, length);

        //I use suppose that Collection interface will have size sub or analog
        var collectionSize = c.size();

        if (collectionSize == 0)
        {
            result = false;
        }
        else
        {
            self.parent._checkForComodification(modCount);

            var curIndex = offset + index;

            self.parent._addAllElements(index, c);

            _updateSizeAndModCount(collectionSize);

            result = true;
        }
    }


    proc _updateSizeAndModCount (sizeChange: int): void
    {
        // #problem
        //Here is cycle
        action NOT_IMPLEMENTED();
    }


    proc _indexOfElement (o: Object): int
    {
        var index = action LIST_FIND(self.parent.storage, o);
        self.parent._checkForComodification(modCount);

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
        self.parent._checkValidIndex(index, length);
        self.parent._checkForComodification(modCount);

        var curIndex = offset + index;

        result = action LIST_GET(self.parent.storage, curIndex);
        action LIST_SET(self.parent.storage, curIndex, element);
    }


    fun get (index: int): Object
    {
        self.parent._checkValidIndex(index, length);
        self.parent._checkForComodification(modCount);

        var curIndex = offset + index;

        result = action LIST_GET(self.parent.storage, curIndex);
    }


    fun size (): int
    {
        self.parent._checkForComodification(modCount);
        result = length;
    }


    fun add (index: int, element: Object): void
    {
        self.parent._rangeCheckForAdd(index, length);
        self.parent._checkForComodification(modCount);

        var curIndex = offset + index;
        self.parent._addElement(curIndex, element);

        _updateSizeAndModCount(1);
    }


    fun remove (index: int): Object
    {
        self.parent._checkValidIndex(index, length);
        self.parent._checkForComodification(modCount);

        var curIndex = offset + index;

        result = self.parent._deleteElement(curIndex);

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
        action NOT_IMPLEMENTED();
    }


    fun removeAll (c: Collection): boolean
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun retainAll (c: Collection): boolean
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun removeIf (filter: Predicate): boolean
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun toArray (): array<Object>
    {
        // #problem
        //How set size of the array ?
        var a: array<int>;

        var end = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    fun toArray (a: list<Object>): array<Object>
    {
        var end = offset + length;
        result = action LIST_TO_ARRAY(storage, a, offset, end);
    }


    fun equals (o: Object): boolean
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun hashCode (): int
    {
        // result = action OBJECT_HASH_CODE(self);
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun indexOf (o: Object): int
    {
        result = _indexOfElement(o);
    }


    fun lastIndexOf (o: Object): int
    {
        //I must think about this new action.
        action NOT_IMPLEMENTED();
    }


    fun contains (o: Object): boolean
    {
        result = _indexOfElement(o) >= 0;
    }


    fun subList (fromIndex: int, toIndex: int): List
    {
        self.parent._subListRangeCheck(fromIndex, toIndex, length);
        result = new SubList(state=Created,
            //Think about THIS !
            //TODO
            parentList = self,
            startIndex=fromIndex,
            endIndex=toIndex);
    }


    fun iterator (): Iterator
    {

    }


    fun spliterator (): Spliterator
    {
        action NOT_IMPLEMENTED();
    }

}



@packagePrivate
@extends("java.util.ArrayList$Itr")
@implements("java.util.Iterator")
@WrapperMeta(
    src="java.util.ArrayList$SubList$1",
    //Maybe will be another name of the dst class
    dst="ru.spbpu.libsl.overrides.collections.ArrayList_SubList_Itr",
    forceMatchInterfaces=true)
automaton ListItr: int (
    var cursor: int,
    var lastRet: int = -1,
    var expectedModCount: int
) {


    //subs


    proc _checkForComodification (expectedModCount: int): void
    {
        if (modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    //methods


    fun hasNext(): boolean
    {
        result = cursor != self.parent.length;
    }


    fun next(): Object
    {
        _checkForComodification(self.parent.modCount);

    }


}

