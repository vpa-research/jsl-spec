libsl '1.1.0';

library 'std:collections' language 'Java' version '11' url '-';

import 'java-common.lsl';
import 'list-actions.lsl';

include java.util.function.Consumer;

//For generation this imports are needed:
include java.util.AbstractSequentialList;
include java.util.Collection;
include java.util.Deque;
include java.util.Iterator;
include java.util.List;
include java.util.ListIterator;

@Public
@Extends('java.util.AbstractSequentialList')
@Implements(['java.util.List','java.util.Deque','java.lang.Cloneable','java.io.Serializable'])
@WrapperMeta(
    src='java.util.LinkedList',
    dst='org.utbot.engine.overrides.collections.UtLinkedList',
    matchInterfaces=true,
)
automaton LinkedList: int(
    var storage: list<any>,
    @Transient var size: int = 0,
    @Transient var modCount: int = 0,
    @Final var serialVersionUID:long = 876323262645176354
)
{

    // constructors
    shift Allocated -> Initialized by [
        LinkedList(),
        LinkedList(Collection)
    ];
    
    shift Initialized -> self by [
        // read operations
        getFirst,
        getLast,
        contains,
        size,
        get,
        indexOf(any),
        indexOf(int),
        lastIndexOf,
        peek,
        element,
        peekFirst,
        peekLast,
        toArray,
        spliterator,
        listIterator

        toString,
        hashCode,
        clone,
        
        // write operations
        removeFirst,
        removeLast,
        addFirst,
        addLast,
        add(any),
        remove(any),
        addAll(Collection),
        addAll(int, Collection),
        clear,
        set,
        add(int, any),
        remove(int),
        poll,
        remove(),
        offer,
        offerFirst,
        offerLast,
        pollFirst,
        pollLast,
        push,
        pop,
        removeFirstOccurrence,
        removeLastOccurrence
        ];

    //constructors

    constructor LinkedList ()
    {
        action LIST_RESIZE(storage, 0);
    }
    
    //problem:
    // we need add constraint for collection type: Collection<? extends E> c
    constructor LinkedList (c: Collection)
    {
        self();
        addAllElements(size, c);
    }
    
    //subs
    
    sub unlinkAny (index: int): any
    {
        result = action LIST_GET(storage, index);
        action LIST_REMOVE(storage, index, 1);
        //Problem
        //We need add decrement and increment in the LibSL
        size = size - 1;
        modCount = modCount + 1;
    }
    
    
    sub linkAny (index: int, e: any): void 
    {
        action LIST_INSERT_AT(storage, index, e);
        //Problem
        //We need add decrement and increment in the LibSL
        size = size + 1;
        modCount = modCount + 1;
    }
    
    
    sub checkElementIndex (index: int): void 
    {
        //Do we have operator not "!" in the LibSL ?
        if (!isElementIndex(index)) 
        {
            var message: string =  "Index: "+index+", Size: "+size;
            action THROW_NEW('java.util._IndexOutOfBoundsException', [message]);
        }
    }
    
    
    sub isElementIndex (index: int): boolean 
    {
        return index >= 0 && index < size;
    }
    
    
    sub isPositionIndex (index: int): boolean 
    {
        return index >= 0 && index <= size;
    }
    
    
    sub checkPositionIndex (index: int): void 
    {
        if (!isPositionIndex(index))
        {
            var message: string =  "Index: "+index+", Size: "+size;
            action THROW_NEW('java.util._IndexOutOfBoundsException', [message]);
        }
    }
    
    
    sub unlinkFirst (): any
    {
        if (size==0)
        {
            action THROW_NEW('java.util.NoSuchElementException', []);
        }
        else 
        {
            result = unlinkAny(0);
        }
    }
    
    
    sub unlinkByFirstEqualsObject (o: any): boolean
    {
        var index = action LIST_FIND(storage,o, 0, size, 1);
        result = action LIST_REMOVE(storage, index, 1);
        if (result == true)
        {
            size = size -1;
            modCount = modCount + 1;    
        }
    }
    
    
    sub addAllElements (index:int, c:Collection): boolean
    {
        //problem:
        //we don't know how to avoid cycle i this method
        action NOT_IMPLEMENTED();
    }
    
    
    sub getFirstElement (): any
    {
        if (size == 0)
        {
            action THROW_NEW('java.util.NoSuchElementException', []);
        }
        else
        {
            result = action LIST_GET(storage, 0);
        }
    }
    
    
    // methods
    
    
    fun getFirst (): any 
    {
        result = getFirstElement();
    }


    fun getLast (): any 
    {
        if (size==0)
        {
            action THROW_NEW('java.util.NoSuchElementException', []);
        }
        else
        {
            result = action LIST_GET(storage, size-1);
        }
    }
    
    
    fun removeFirst (): any 
    {
        result = unlinkFirst();
    }


    fun removeLast (): any 
    {
        if (size==0)
        {
            action THROW_NEW('java.util.NoSuchElementException', []);
        }
        else 
        {
            result = unlinkAny(size-1);
        }
    }
    
    
    fun addFirst (e: any): void 
    {
        linkAny(0, e);
    }


    fun addLast (e: any): void 
    {
        linkAny(size, e);
    }


    fun contains (o: any): boolean
    {
        //Problem
        //Can we write such expressions in the LibSL ?
        result = action LIST_FIND(storage,o,0,size,1) >= 0;
    }


    fun size (): int
    {
        result = size;
    }


    fun add (e: any): boolean 
    {
        linkAny(size, e);
        result = true;
    }

    
    fun remove (o: any): boolean 
    {
        result = unlinkByFirstEqualsObject(o);
    }
    
    
    //problem:
    // we need add constraint for collection type: Collection<? extends E> 
    fun addAll (c: Collection): boolean 
    {
        result = addAllElements(size, c);
    }
    
    
    fun addAll (index:int, c:Collection): boolean 
    {
        result = addAllElements(index, c);
    }
    
    
    fun clear (): void 
    {
        action LIST_RESIZE(storage, 0);
        size = 0;
        modCount = modCount + 1;
    }
    
    
    fun get (index: int): any 
    {
        checkElementIndex(index);
        result = action LIST_GET(storage, index);
    }

    
    fun set (index: int, element: any): any 
    {
        checkElementIndex(index);
        action LIST_SET(storage, index, element);
        result = action LIST_GET(storage, index);
    }
    
    
    fun add (index: int, element: any): void 
    {
        checkPositionIndex(index);
        linkAny(index, element);
    }
    
    
    fun remove (index: int): any 
    {
        checkElementIndex(index);
        result = unlinkAny(index);
    }
    
    
    fun indexOf (o: any): int 
    {
        result = action LIST_FIND(storage,o, 0, size, 1);
    }
    
    
    fun lastIndexOf (o: any): int 
    {
        result = action LIST_FIND(storage,o, size, 0, -1);
    }
    
    
    fun peek(): any 
    {
        if (size == 0)
        {
            result = null;
        }
        else
        {
            result = action LIST_GET(storage, 0);
        }
    }
    
    
    fun element (): any 
    {
        result = getFirstElement();    
    }
    
    
    fun poll (): any 
    {
        if (size==0)
        {
            result = null;
        }
        else 
        {
            result = unlinkAny(0);
        }
    }
    
    
    fun remove (): any 
    {
        result = unlinkFirst();
    }
    
    
    fun offer (e: any): boolean 
    {
        linkAny(size, e);
        result = true;
    }

    
    fun offerFirst (e: any): boolean 
    {
        linkAny(0, e);
        result = true;
    }


    fun offerLast (e: any): boolean 
    {
        linkAny(size, e);
        result = true;
    }
    
    
    fun peekFirst (): any 
    {
        if (size == 0)
        {
            result = null;
        }
        else
        {
            result = action LIST_GET(storage, 0);
        }
    }
    
    
    fun peekLast (): any 
    {
        if (size == 0)
        {
            result = null;
        }
        else
        {
            result = action LIST_GET(storage, size-1);
        }
    }


    fun pollFirst (): any 
    {
        if (size == 0)
        {
            result = null;
        }
        else
        {
            result = unlinkAny(0);
        }
    }
    
    
    fun pollLast (): any 
    {
        if (size == 0)
        {
            result = null;
        }
        else
        {
            result = unlinkAny(size-1);
        }
    }
    
    
    fun push (e: any): void 
    {
        linkAny(0, e);
    }


    fun pop (): any 
    {
        result = unlinkFirst();
    }
    
    
    fun removeFirstOccurrence (o: any): boolean 
    {
        result = unlinkByFirstEqualsObject(o);
    }
    
    
    fun removeLastOccurrence (o: any): boolean 
    {
        //I need think about this action
        action NOT_IMPLEMENTED();
    }
    
    
    //We need add type: typealias ArrayObject = array<any>;
    fun toArray (a: ArrayObject): ArrayObject 
    {
        result = action LIST_TO_ARRAY(storage, a);
    }

    
    fun spliterator (): Spliterator 
    {
        result = new LLSpliterator(state=Initialized,
            //This is right ? "parent=self"
            parent=self,
            est=-1,
            expectedModCount=0);
    } 


    fun listIterator (index: int): ListIterator 
    {
        checkPositionIndex(index);
            result = new ListItr(state=Created,
            parent = self,
            expectedModCount=self.modCounter);
    }
    
    fun descendingIterator (): Iterator 
    {
        result = new DescendingIterator(state=Created,
            parent = self);
    }


    fun clone (): any
    { 
        result = action LIST_DUP(storage);
    }
    
    
    fun hashCode (): int
    {
        // result = action OBJECT_HASH_CODE(self);
        // #problem
        action NOT_IMPLEMENTED();
    }
    
    
    fun toString (): string
    {
        // result = action OBJECT_TO_STRING(self);
        // #problem
        action NOT_IMPLEMENTED();
    }

}






@Private
@Implements('java.util.ListIterator')
@WrapperMeta(
    src='java.util.ListItr',
    dst='org.utbot.engine.overrides.collections.UtListItr',
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
    
    fun hasNext (): boolean
    {
        result = index < self.parent.size;
    }
    
    
    fun next (): any
    {
        checkForComodification();
        val atValidPosition = index < self.parent.length;
        
        if (!atValidPosition)
        {
            action THROW_NEW('java.util.NoSuchElementException', []);
        }
        
        result = action LIST_GET(self.parent.storage, index);
        index = index + 1;
        nextWasCalled = true;
        prevWasCalled = false;
    }
    
    
    fun hasPrevious (): boolean 
    {
        result = index > 0;
    }
    
    
    fun previous (): any
    {
        checkForComodification();
        val atValidPosition = index > 0;
        
        if (!atValidPosition)
        {
            action THROW_NEW('java.util.NoSuchElementException', []);
        }
        
        index = index - 1;
        result = LIST_GET(self.parent.storage, index);
        prevWasCalled = true;
        nextWasCalled = false;
    }
    
    
    fun nextIndex (): int 
    {
        result = index;
    }
    
    
    fun previousIndex (): int 
    {
        result = index - 1;
    }
    
    
    fun remove (): void
    {
        checkForComodification();
        
        if (!nextWasCalled && !prevWasCalled)
        {
            action THROW_NEW('java.lang.IllegalStateException', []);
        }
        
        if (nextWasCalled)
        {
            self.parent.unlinkAny(index - 1);
            nextWasCalled = false;
        }
        else
        {
            self.parent.unlinkAny(index);
            index = index - 1;
            prevWasCalled = false;
        }
    
        expectedModCount = expectedModCount + 1;
    }
    
    
    fun set (e: any): void
    {
        if (!nextWasCalled && !prevWasCalled)
        {
            action THROW_NEW('java.lang.IllegalStateException', []);
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
   
   
    fun add (e: any): void
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
    
    
    fun forEachRemaining (action: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }
    
    
    
    sub checkForComodification (): void 
    {
        if (self.parent.modCount != expectedModCount)
        {
            action THROW_NEW('java.util.ConcurrentModificationException', []);
        }
    }
    
}



@Private
@Implements('java.util.Iterator')
@WrapperMeta(
    src='java.util.ListItr',
    dst='org.utbot.engine.overrides.collections.UtDescendingIterator',
    matchInterfaces=true,
)
automaton DescendingIterator: int(
    //Do we can write in such way or not ??
    var itr = new ListItr(state=Created,
    parent = self.parent,
    index = self.parent.size())
)
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


    fun next (): any
    {
        result = itr.previous();
    }
    
    
    fun hasNext (): boolean
    {
        result = itr.hasPrevious();
    }
    
    
    fun remove (): void
    {
        itr.remove();
    }
    
    
    fun forEachRemaining (action: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }
}



@Private
@Implements('java.util.Spliterator')
@WrapperMeta(
    src='java.util.ListItr',
    dst='org.utbot.engine.overrides.collections.UtLLSpliterator',
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
        
    }
    
    //sub's
    
    sub getEst (): int
    {
    
    }
    
    //methods
    
    fun estimateSize (): long
    {
    
    }
    
    fun trySplit (): Spliterator
    {
    
    }
    
    fun forEachRemaining (action: Consumer): void
    {
    
    }
    
    fun tryAdvance (action: Consumer): boolean
    {
    
    }
    
    fun characteristics (): int
    {
    
    }
    
}
