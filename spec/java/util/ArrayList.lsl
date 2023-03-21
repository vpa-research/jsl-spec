libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";
import "list-actions.lsl";

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

@Extends("java.util.AbstractList")
@Implements(["java.util.List", "java.util.RandomAccess","java.lang.Cloneable","java.io.Serializable"])
@WrapperMeta(
    src="java.util.ArrayList",
    dest="org.utbot.engine.overrides.collections.UtArrayList",
    matchInterface=true)
automaton ArrayList: int (
    @Private @Final serialVersionUID: long = 8683452581122892189,
    @Private @Final serialVersion DEFAULT_CAPACITY: int = 10,
    @Transient storage: List<Object>,
    @Private length: int,
    @Private @Static @Final DEFAULT_CAPACITY: int = 10,
    @Private @Transient modCount: int = 0
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
            //We are thinking about this action: "TO_STRING"
            var message = "Illegal Capacity: "+ action TO_STRING(initialCapacity);
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
        action ARRAY_TO_LIST(c.toArray(), storage);
        //Problem:
        //In the next code of the original class can be such situation:  https://bugs.openjdk.java.net/browse/JDK-6260652
        //(you can see at the original class); But as a understand, this bug can be reproduced only
        //in jdk 1.5; We must think about this ? Or we don't have to do anything with it ?
        //It wasn't reproduced in JDK  11.0.1
        action NOT_IMPLEMENTED();
    }


    //subs

    sub checkValidIndex (index: int, length: int): void
    {
        if (index < 0 || index >= length)
        {
            var message = "Index "+ action TO_STRING(index) + " out of bounds for length "+ action TO_STRING(length);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    sub rangeCheckForAdd (index: int, length: int): void
    {
        if (index < 0 || index > length)
        {
            var message = "Index: " + action TO_STRING(index) + ", Size: " + action TO_STRING(length);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    sub addAllElements (index:int, c:Collection): boolean
    {
        modCount = modCount + 1;

        //problem:
        //we don't know how to avoid cycle i this method
        action NOT_IMPLEMENTED();

        length = length + c.length;
    }

    sub subListRangeCheck (int fromIndex, int toIndex, int size): void
    {
        if (fromIndex < 0)
        {
            var message: String = "fromIndex = " + action TO_STRING(fromIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (toIndex > size)
        {
            var message: String = "toIndex = " + action TO_STRING(toIndex);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }

        if (fromIndex > toIndex)
        {
            var message: String = "fromIndex(" + action TO_STRING(fromIndex) + ") > toIndex(" + action TO_STRING(toIndex) + ")";
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
    }


    sub checkForComodification (expectedModCount: int): void
    {
        if (modCount != expectedModCount)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }

    sub deleteElement (index: int): Object
    {
        checkValidIndex(index, length);
        result = action LIST_GET(storage, index);
        action LIST_REMOVE(storage, index, 1);
        modCount = modCount + 1;
        length = length - 1;
    }


    sub addElement (index: int, e: Object): void
    {
        rangeCheckForAdd(index, length);
        modCount = modCount + 1;
        action LIST_INSERT_AT(storage, index, e);
        length = length + 1;
    }


    sub setElement (index: int, e: Object): void
    {
        checkValidIndex(index, length);
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
        result = action LIST_FIND(storage, o) >= 0;
    }


    fun indexOf (o: Object): int
    {
        result = action LIST_FIND(storage, o);
    }



    fun lastIndexOf (o: Object): int
    {
        //I must think about this new action.
        action NOT_IMPLEMENTED();
    }


    fun clone (): Object
    {
        storageCopy = action LIST_DUP(storage);
        result = new ArrayList(
            state=self.state, storage=storageCopy, length=self.length);
    }


    fun toArray (): array<Object>
    {
        //Problem
        //How set size of the array ?
        var a: array<int>;
        result = action LIST_TO_ARRAY(storage, a, 0, length);
    }


    fun toArray (a: list<Object>): array<Object>
    {
        result = action LIST_TO_ARRAY(storage, a, 0, length);
    }


    fun get (index: int): Object
    {
        checkValidIndex(index, length);
        result = action LIST_GET(storage, index);
    }


    fun set (index: int, element: Object): Object
    {
        setElement(index, element);
    }


    fun add (e: Object): boolean
    {
        modCount = modCount + 1;
        action LIST_INSERT_AT(storage, length, e);
        length = length + 1;
    }


    fun add (index: int, element: Object): void
    {
        addElement(index, e);
    }


    fun remove (index: int): Object
    {
        result = deleteElement(index);
    }


    fun equals (o: Object): boolean
    {
        //Problem
        //We don't know at this moment how create this method.
        action NOT_IMPLEMENTED();
    }


    fun hashCode (): int
    {
        // result = action OBJECT_HASH_CODE(self);
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun remove (o: Object): boolean
    {
        var index = action LIST_FIND(storage, o);
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
        result = addAllElements(length, c);
    }



    fun addAll (index: int, c: Collection): boolean
    {
        result = addAllElements(length, c);
    }


    fun removeAll (c: Collection): boolean
    {
        //Problem.
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
        //Problem.
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


    @Private
    fun writeObject (s: ObjectOutputStream): void
    {
        action NOT_IMPLEMENTED();
    }


    @Private
    fun readObject (s: ObjectInputStream): void
    {
        action NOT_IMPLEMENTED();
    }


    fun listIterator (index: int): ListIterator
    {
        rangeCheckForAdd(index, length);

        result = new ListItr(state=Created,
            cursor=index,
            expectedModCount=modCount);
    }


    fun listIterator (): ListIterator
    {
        result = new ListItr(state=Created,
            cursor=index,
            expectedModCount=modCount);
    }


    fun iterator (): Iterator
    {
        result = new Itr(state=Created,
            expectedModCount=modCount);
    }


    fun subList (fromIndex: int, toIndex: int): List
    {
        subListRangeCheck(fromIndex, toIndex, length);
        result = new SubList(state=Created,
            //Think about THIS !
            //TODO
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
        action NOT_IMPLEMENTED();
    }


    fun replaceAll (operator: UnaryOperator): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }


    fun sort (c: Comparator): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }
}



@PackagePrivate
@Implements("java.util.Iterator")
@WrapperMeta(
    src="java.util.ArrayList$Itr",
    //Maybe will be another name of the dest class
    dest="org.utbot.engine.overrides.collections.ArrayList$Itr",
    matchInterface=true)
automaton Itr: int (
    cursor: int,
    lastRet: int = -1,
    expectedModCount: int
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
        self.parent.checkForComodification(expectedModCount);
        var i = cursor;

        if (i >= parent.length)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        //Problem
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

        self.parent.checkForComodification(expectedModCount);

        //Problem
        //What i must to do with try-catch in this method ?

        self.parent.deleteElement(lastRet);
        cursor = lastRet;
        lastRet = -1;
        expectedModCount = self.parent.modCount;
    }


    fun forEachRemaining (action: Consumer): void
    {
        action NOT_IMPLEMENTED();
    }

}



@PackagePrivate
@Extends("java.util.ArrayList$Itr")
@Implements("java.util.Iterator")
@WrapperMeta(
    src="java.util.ArrayList$ListItr",
    //Maybe will be another name of the dest class
    dest="org.utbot.engine.overrides.collections.ArrayList$ListItr",
    matchInterface=true)
automaton ListItr: int (
    cursor: int,
    lastRet: int = -1,
    expectedModCount: int
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
        //Problem
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
        self.parent.checkForComodification(expectedModCount);
        var i = cursor;

        if (i >= parent.length)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        //Problem
        //I don't know what to do with ConcurrentModificationException(); ?

        cursor = i + 1;
        lastRet = i;
        result = action LIST_GET(self.parent.storage, lastRet);
    }


    fun previous (): Object
    {
        self.parent.checkForComodification(expectedModCount);
        var i = cursor - 1;

        if (i < 0)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        //Problem
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

        self.parent.checkForComodification(expectedModCount);

        //Problem
        //What i must to do with try-catch in this method ?

        self.parent.deleteElement(lastRet);
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

        self.parent.checkForComodification(expectedModCount);

        //Problem
        //What i must to do with try-catch in this method ?

        self.parent.setElement(lastRet, e);
    }


    fun add (e: Object): void
    {
        self.parent.checkForComodification(expectedModCount);

        //Problem
        //What i must to do with try-catch in this method ?

        var i = cursor;
        self.parent.addElement(self.parent.length, e);
        cursor = i + 1;
        lastRet = -1;
        expectedModCount = self.parent.modCount;
    }


    fun forEachRemaining (action: Consumer): void
    {
        action NOT_IMPLEMENTED();
    }

}



@Final
@Implements("java.util.Spliterator")
@WrapperMeta(
    src="java.util.ArrayList$ArrayListSpliterator",
    dst="org.utbot.engine.overrides.collections.ArrayList$UtArrayListSpliterator",
    matchInterfaces=true,
)
automaton ArrayListSpliterator: int(
    index: int,
    fence: int,
    expectedModCount: int
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



@Private
@Static
@Extends("java.util.AbstractList")
@Implements("java.util.RandomAccess")
@WrapperMeta(
    src="java.util.ArrayList$SubList",
    dst="org.utbot.engine.overrides.collections.ArrayList$UtSubList",
    matchInterfaces=true,
)
automaton SubList: int(
    @Final index: offset,
    length: int,
    @Transient modCount: int,

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


    @Private
    constructor SubList(parentList: SubList, startIndex: int, endIndex: int)
    {
        //Problem
        //???
        offset = startIndex;
        length = endIndex - startIndex;
        modCount = self.parent.modCount;
    }


    //subs

    sub addAllElements (index:int, c:Collection): boolean
    {
        self.parent.rangeCheckForAdd(index, length);

        //I use suppose that Collection interface will have size sub or analog
        var collectionSize = c.size();

        if (collectionSize == 0)
        {
            result = false;
        }
        else
        {
            self.parent.checkForComodification(modCount);

            var curIndex = offset + index;

            self.parent.addAllElements(index, c);

            updateSizeAndModCount(collectionSize);

            result = true;
        }
    }


    sub updateSizeAndModCount (sizeChange: int): void
    {
        //Problem
        //Here is cycle
        action NOT_IMPLEMENTED();
    }


    sub indexOfElement (o: Object): int
    {
        var index = action LIST_FIND(self.parent.storage, o);
        self.parent.checkForComodification(modCount);

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
        self.parent.checkValidIndex(index, length);
        self.parent.checkForComodification(modCount);

        var curIndex = offset + index;

        result = action LIST_GET(self.parent.storage, curIndex);
        action LIST_SET(self.parent.storage, curIndex, element);
    }


    fun get (index: int): Object
    {
        self.parent.checkValidIndex(index, length);
        self.parent.checkForComodification(modCount);

        var curIndex = offset + index;

        result = action LIST_GET(self.parent.storage, curIndex);
    }


    fun size (): int
    {
        self.parent.checkForComodification(modCount);
        result = length;
    }


    fun add (index: int, element: Object): void
    {
        self.parent.rangeCheckForAdd(index, length);
        self.parent.checkForComodification(modCount);

        var curIndex = offset + index;
        self.parent.addElement(curIndex, element);

        updateSizeAndModCount(1);
    }


    fun remove (index: int): Object
    {
        self.parent.checkValidIndex(index, length);
        self.parent.checkForComodification(modCount);

        var curIndex = offset + index;

        result = self.parent.deleteElement(curIndex);

        updateSizeAndModCount(-1);
    }


    fun addAll (c: Collection): boolean
    {
        addAllElements(length, c);
    }


    fun addAll (index: int, c: Collection): boolean
    {
        addAllElements(index, c);
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
        //Problem
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
        result = indexOfElement(o);
    }


    fun lastIndexOf (o: Object): int
    {
        //I must think about this new action.
        action NOT_IMPLEMENTED();
    }


    fun contains (o: Object): boolean
    {
        result = indexOfElement(o) >= 0;
    }


    fun subList (fromIndex: int, toIndex: int): List
    {
        self.parent.subListRangeCheck(fromIndex, toIndex, length);
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



@PackagePrivate
@Extends("java.util.ArrayList$Itr")
@Implements("java.util.Iterator")
@WrapperMeta(
    src="java.util.ArrayList$SubList$1",
    //Maybe will be another name of the dest class
    dest="org.utbot.engine.overrides.collections.UtArrayList$SubList$1",
    matchInterface=true)
automaton ListItr: int (
    cursor: int,
    lastRet: int = -1,
    expectedModCount: int
) {


    //subs


    sub checkForComodification (expectedModCount: int): void
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
        checkForComodification(self.parent.modCount);

    }


}

