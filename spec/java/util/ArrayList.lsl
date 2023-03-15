libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";
import "list-actions.lsl";

@Extends("java.util.AbstractList")
@Implements(["java.util.List", "java.util.RandomAccess","java.lang.Cloneable","java.io.Serializable"])
@WrapperMeta(
    src="java.util.ArrayList",
    dest="org.utbot.engine.overrides.collections.UtArrayList",
    matchInterface=true)
automaton ArrayList: int (
    @Private @Final serialVersionUID: long = 8683452581122892189,
    @Private @Final serialVersion DEFAULT_CAPACITY: int = 10,
    @Transient elementData: List<Object>,
    @Private size: int

) {


    //constructors

    constructor ArrayList (initialCapacity: int)
    {

    }


    constructor ArrayList ()
    {

    }


    constructor ArrayList (c: Collection)
    {

    }


    //subs


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

    }


    fun ensureCapacity (minCapacity: int): void
    {

    }


    fun size (): int
    {

    }


    fun isEmpty (): boolean
    {

    }


    fun contains (o: Object): boolean
    {

    }


    fun indexOf (o: Object): int
    {

    }



    fun lastIndexOf (o: Object): int
    {

    }


    fun clone (): Object
    {

    }


    fun toArray (): list<Object>
    {

    }


    fun toArray (a: list<Object>): list<Object>
    {

    }


    fun get (index: int): Object
    {

    }


    fun set (index: int, element: Object): Object
    {

    }


    fun add (e: Object): boolean
    {

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
