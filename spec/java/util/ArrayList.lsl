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

    sub checkValidIndex (index: int): void
    {
        if (index < 0 || index >= length)
        {
            var message = "Index "+ action TO_STRING(index) + " out of bounds for length "+ action TO_STRING(length);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    sub rangeCheckForAdd (index: int): void
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
        checkValidIndex(index);
        result = action LIST_GET(storage, index);
        action LIST_REMOVE(storage, index, 1);
        modCount = modCount + 1;
        length = length - 1;
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
        result = action LIST_TO_ARRAY(storage, a);
    }


    fun toArray (a: list<Object>): array<Object>
    {
        result = action LIST_TO_ARRAY(storage, a);
    }


    fun get (index: int): Object
    {
        checkValidIndex(index);
        result = action LIST_GET(storage, index);
    }


    fun set (index: int, element: Object): Object
    {
        checkValidIndex(index);
        result = action LIST_GET(storage, index);
        action LIST_SET(storage, index, element);
    }


    fun add (e: Object): boolean
    {
        modCount = modCount + 1;
        action LIST_INSERT_AT(storage, length, e);
        length = length + 1;
    }


    fun add (index: int, element: Object): void
    {
         rangeCheckForAdd(index);
         modCount = modCount + 1;
         action LIST_INSERT_AT(storage, index, e);
         length = length + 1;
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
        rangeCheckForAdd(index);

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
            start=fromIndex,
            end=toIndex);
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
    src="java.util.ArrayList$Itr",
    //Maybe will be another name of the dest class
    dest="org.utbot.engine.overrides.collections.ArrayList$Itr",
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
       hasPrevious,
       nextIndex,

       // write operations
       previous,
       set,
       add
    ]

    //constructors


    constructor ListItr(index: int)
    {
        //Problem
        //How invoke super() ??

    }


    //methods


    fun hasPrevious (): boolean
    {

    }


    fun nextIndex (): int
    {

    }


    fun previousIndex (): int
    {

    }


    fun previous (): Object
    {

    }


    fun set (e: Object): void
    {

    }


    fun add (e: Object): void
    {

    }

}


