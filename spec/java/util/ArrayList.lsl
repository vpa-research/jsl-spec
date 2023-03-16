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

    sub grow (minCapacity: int): list<Object>
    {

    }


    sub grow (): list<Object>
    {

    }


    sub indexOfRange (o: Object, start: int, end: int): int
    {

    }


    sub lastIndexOfRange (o: Object, start: int, end: int): int
    {

    }


    sub elementData (index: int): Object
    {

    }


    sub elementAt (es: list<Object>, index: int): Object
    {

    }


    sub add (e: Object, elementData: list<Object>, s: int): void
    {

    }


    sub equalsRange (other: List, from: int, to: int): boolean
    {

    }


    sub equalsArrayList (other: ArrayList): boolean
    {

    }


    sub checkForComodification (@Final expectedModCount: int): void
    {

    }


    sub hashCodeRange (from: int, to: int):int
    {

    }


    sub fastRemove (es: list<Object>, I: int): void
    {

    }


    sub removeRange (fromIndex: int, toIndex): void
    {

    }


    sub shiftTailOverGap (es: list<Object>, lo: int, hi: int): void
    {

    }


    sub rangeCheckForAdd (index: int): void
    {

    }


    sub outOfBoundsMsg (index: int): String
    {

    }


    sub outOfBoundsMsg (fromIndex: int, toIndex: int): String
    {

    }


    sub batchRemove (c: Collection, complement: boolean, @Final from: int, @Final end: int)
    {

    }


    sub removeIf (filter: Predicate, i: int, @Final end: int): boolean
    {

    }


    sub replaceAllRange (operator: UnaryOperator, i: int, end: int): void
    {

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

    }


    fun remove (index: int): Object
    {

    }


    fun equals (o: Object): boolean
    {

    }


    fun hashCode (): int
    {

    }


    fun remove (o: Object): boolean
    {

    }


    fun clear (): void
    {

    }


    fun addAll (c: Collection): boolean
    {

    }



    fun addAll (index: int, c: Collection): boolean
    {

    }


    fun removeAll (c: Collection): boolean
    {

    }


    fun retainAll (c: Collection): boolean
    {

    }


    @Private
    fun writeObject (s: ObjectOutputStream): void
    {

    }


    @Private
    fun readObject (s: ObjectInputStream): void
    {

    }


    fun listIterator (index: int): ListIterator
    {

    }


    fun listIterator (): ListIterator
    {

    }


    fun iterator (): Iterator
    {

    }


    fun subList (fromIndex: int, toIndex: int): List
    {

    }


    fun forEach (action: Consumer): void
    {

    }


    fun spliterator (): Spliterator
    {

    }


    fun removeIf (filter: Predicate): boolean
    {

    }


    fun replaceAll (operator: UnaryOperator): void
    {

    }


    fun sort (c: Comparator): void
    {

    }
}
