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
   	var storage: list<Object>,
	@Transient var size: int = 0,
	@Protected @Transient var modCount: int = 0,
    	var serialVersionUID:long = 876323262645176354
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
		indexOf(Object),
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
		add(Object),
		remove(Object),
		addAll(Collection),
		addAll(int, Collection),
		clear,
		set,
		add(int, Object),
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

	constructor LinkedList (): void {
    		action LIST_RESIZE(storage, 0);
	}
    
	//problem:
	// we need add constraint for collection type: Collection<? extends E> c
	constructor LinkedList (c: Collection): void {
    		self();
		addAll(c);
	}
	
	// methods
    
    
	fun getFirst () : Object {
		if (size == 0)
		{
			action THROW_NEW('java.util.NoSuchElementException', []);
		}
		else
		{
			result = action LIST_GET(storage, 0);
		}
	}


	fun getLast() : Object {
		if (size==0)
		{
			action THROW_NEW('java.util.NoSuchElementException', []);
		}
		else
		{
			result = action LIST_GET(storage, size-1);
		}
	}


	@Private
	sub unlinkAny(index: int): Object {
		result = action LIST_GET(storage, index);
		action LIST_REMOVE(storage, index);
		//Problem
		//We need add decrement and increment in the LibSL
		size--;
		modCount++;
	}
	
	
	fun removeFirst() : Object {
		if (size==0)
		{
			action THROW_NEW('java.util.NoSuchElementException', []);
		}
		else {
			//Problem
			//We need add ivocation of the functions in the LibSL
			result = unlinkAny(0);
		}
	}


	fun removeLast() : Object {
		if (size==0)
		{
			action THROW_NEW('java.util.NoSuchElementException', []);
		}
		else {
			result = unlinkAny(size-1);
		}
	}


	@Private
	sub linkAny (index: int, e: Object): void {
		action LIST_INSERT_AT(storage, index, e);
		//Problem
		//We need add decrement and increment in the LibSL
		size++;
		modCount++;
	}
	
	
	fun addFirst(e: Object): void {
		//Problem
		//We need add ivocation of the functions in the LibSL
		linkAny(0, e);
	}


	fun addLast (e: Object): void {
		//Problem
		//We need add ivocation of the functions in the LibSL
		linkAny(size-1, e);
	}


	fun contains (o: Object): boolean{
		//Problem
		//Can we write such expressions in the LibSL ?
		result = action LIST_FIND(storage,o,0,size,1) >= 0;
	}


	fun size (): int{
		result = size;
	}


	fun add (e: Object): boolean {
		linkAny(size-1, e);
		result = true;
	}

	
	
	fun remove (o: Object): boolean {
		var index = indexOf(o);
		result = action LIST_REMOVE(storage, index);
		*Можно ли писать result НЕ в самом конце ? *
		if(result == true)
		{
			*Существует ли такой -= оператор в LibSL ?*
			size--;
			modCount++;	
		}
	}
	
	
	//problem:
	// we need add constraint for collection type: Collection<? extends E> 
	fun addAll (c: Collection): boolean {
		result = addAll(size, c);
	}
	
	
	fun addAll (index:int, c:Collection): boolean {
		//problem:
		//we don't know how to avoid cycle i this method
	}
	
	
	fun clear(): void {
		action LIST_RESIZE(storage, 0);
		size = 0;
		modCount++;
	}

	
	@Private
	sub checkElementIndex (index: int): void {
		//Работает ли в LibSL такой оператор "!" НЕ
		if (!isElementIndex(index)) 
		{
			//Работает ли такая конкатенация строк и можно ли внутри ифа  объявить локальную переменную
			var message: string =  "Index: "+index+", Size: "+size;
			action THROW_NEW('java.util._IndexOutOfBoundsException', [message]);
		}
	}
	
	
	@Private
	sub isElementIndex(index: int): boolean {
       	 	return index >= 0 && index < size;
    	}
	
	
	@Private
	sub isPositionIndex(index: int): boolean {
        	return index >= 0 && index <= size;
    	}
	
	
	@Private
	sub checkPositionIndex(index: int) {
        	if (!isPositionIndex(index))
		{
            		//Работает ли такая конкатенация строк и можно ли внутри ифа  объявить локальную переменную
			var message: string =  "Index: "+index+", Size: "+size;
			action THROW_NEW('java.util._IndexOutOfBoundsException', [message]);
		}
    	}
	
	
	fun get (index: int): Object {
		checkElementIndex(index);
		result = action LIST_GET(storage, index);
	}

	
	fun set (index: int, element: Object): Object {
		checkElementIndex(index);
		action LIST_SET(storage, index, element);
		result = action LIST_GET(storage, index);
	}
	
	
	fun add(index: int, element: Object): void {
		checkPositionIndex(index);
		linkAny(index, element);
	}
	
	
	fun remove (index: int): Object {
		checkElementIndex(index);
		result = unlinkAny(index);
	}
	
	
	fun indexOf(o: Object): int {
		result = action LIST_FIND(storage,o, 0, size, 1);
	}
	
	
	fun lastIndexOf(o: Object): int {
		result = action LIST_FIND(storage,o, size, 0, -1);
	}
	
	
	fun peek(): Object {
		if(size == 0)
		{
			result = null;
		}
		else
		{
			result = action LIST_GET(storage, 0);
		}
	}
	
	
	fun element (): Object {
		result = getFirst();	
	}
	
	
	fun poll(): Object {
		if(size==0)
		{
			result = null;
		}
		else 
		{
			result = unlinkAny(0);
		}
	}
	
	
	fun remove(): Object {
		result = removeFirst();
	}
	
	
	fun offer(e: Object): boolean {
	 	add(e);
		result = true;
	}

	
	fun offerFirst(e: Object): boolean {
		addFirst(e);
		result = true;
	}


	fun offerLast(e: Object): boolean {
		addLast(e);
		result = true;
	}
	
	
	fun peekFirst(): Object {
		if(size == 0)
		{
			result = null;
		}
		else
		{
			result = action LIST_GET(storage, 0);
		}
	}
	
	
	fun peekLast(): Object {
		if(size == 0)
		{
			result = null;
		}
		else
		{
			result = action LIST_GET(storage, size-1);
		}
	}


	fun pollFirst(): Object {
		if(size == 0)
		{
			result = null;
		}
		else
		{
			result = unlinkAny(0);
		}
	}
	
	
	fun pollLast(): Object {
		if(size == 0)
		{
			result = null;
		}
		else
		{
 			result = unlinkAny(size-1);
		}
	}
	
	
	fun push(e: Object): void {
		addFirst(e);
	}


	fun pop(): Object {
		result = removeFirst();
	}
	
	
	fun removeFirstOccurrence(o: Object): boolean {
		result = remove(o);
	}
	
	
	fun removeLastOccurrence(o: Object): boolean {
		//I need think about this
	}
	
	
	//We need add type: typealias ArrayObject = array<Object>;
	fun toArray(a: ArrayObject): ArrayObject {
		result = action LIST_TO_ARRAY(storage, a);
	}

	
	fun spliterator(): Spliterator {
		result = new LLSpliterator(state=Initialized,
		//This is right ? "parent=self"
		parent=self,
		est=-1,
		expectedModCount=0);
	}


	fun listIterator(index: int): ListIterator {
		checkPositionIndex(index);
		result = new ListItr(state=Created,
		parent = self,
		index = self.index);
	}
	
	fun descendingIterator(): Iterator {
        	result = new DescendingIterator(state=Created,
		parent = self);
    	}


	fun clone (): Object
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
	var nextIndex:int,
	var next: Object,
	var lastReturned: Object,
	var expectedModCount = parent.modCount)
{
	initstate Initialized;
	
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
    
    constructor ListItr(index: int): void 
    {
    	if(index == self.parent.size)
	{
		next = null;
	}
	else
	{
		next = action LIST_GET(self.parent.storage, index);
	}
	nextIndex = index;
    }
    
    
    //methods
    
    fun hasNext(): boolean
    {
        result = nextIndex < self.parent.size;
    }
    
    
    fun next(): Object
    {
    	checkForComodification();
	if (!hasNext())
	{
		action THROW_NEW('java.util.NoSuchElementException', []);
	}
	lastReturned = next;
	nextIndex++;
	next = action LIST_GET(self.parent.storage, nextIndex);
	result = lastReturned;
    }
    
    
    fun hasPrevious(): boolean 
    {
	result = nextIndex > 0;
    }
    
    
    fun previous(): Object
    {
    	checkForComodification();
	if (!hasNext())
	{
		action THROW_NEW('java.util.NoSuchElementException', []);
	}
	if(next == null)
	{
		next = action LIST_GET(self.parent.storage, self.parent.size - 1);
	}
	else
	{
		next = action LIST_GET(self.parent.storage, nextIndex - 1);
	}
	lastReturned = next;
	nextIndex--;
	result = lastReturned;
    }
    
    
    fun nextIndex(): int 
    {
            result = nextIndex;
    }
    
    
    fun previousIndex(): int 
    {
            result = nextIndex - 1;
    }
    
    
    fun remove(): void
    {
    	checkForComodification();
	if (lastReturned == null)
	{
		action THROW_NEW('java.lang.IllegalStateException', []);
	}
	
	var lastNext = action LIST_GET(self.parent.storage, nextIndex + 1);
	
	var index = self.parent.indexof(lastReturned);
	action LIST_REMOVE(self.parent.storage, index);
	
	if(next == lastReturned)
	{
		next = lastNext;
	}
	else
	{
		nextIndex--;
	}
	
	lastReturned = null;
	expectedModCount++;
    }
    
    
    fun set(e: Object): void
    {
    	if (lastReturned == null)
	{
		action THROW_NEW('java.lang.IllegalStateException', []);
	}
	checkForComodification();
	var index = self.parent.indexof(lastReturned);
	action LIST_SET(storage, index, e);
    }
   
   
    fun add(e: Object): void
    {
    	checkForComodification();
	lastReturned = null;
	if(next == null)
	{
		self.parent.linkAny(self.parent-size - 1, e);
	}
	else
	{
		//We need to insert before next
		var index = self.parent.indexof(next) - 1;
		self.parent.linkAny(, e);
	}
	nextIndex++;
        expectedModCount++;
    }
    
    
    fun forEachRemaining (action: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }
    
    
    
    sub checkForComodification(): void 
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


	fun next(): Object
	{
		result = itr.previous();
	}
	
	
	fun hasNext(): boolean
    	{
        	result = itr.hasPrevious();
   	}
	
	
	fun remove(): void
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
	var BATCH_UNIT: int = 1 << 10,
	var MAX_BATCH: int = 1 << 25,
	var list: LinkedList,
	est: int,
	expectedModCount: int,
	batch: int
	)
{


	//constructors
	
	constructor LLSpliterator(list: LinkedList, est: int, expectedModCount: int): void
	{
		
	}
	
	//sub's
	
	sub getEst(): int
	{
	
	}
	
	//methods
	
	fun estimateSize(): long
	{
	
	}
	
	fun trySplit(): Spliterator
	{
	
	}
	
	fun forEachRemaining(action: Consumer): void
	{
	
	}
	
	fun tryAdvance(action: Consumer): boolean
	{
	
	}
	
	fun characteristics(): int
	{
	
	}
	
}
