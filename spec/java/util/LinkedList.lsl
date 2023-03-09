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
	fun unlinkAny(index: int): Object {
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
	fun linkAny (index: int, e: Object): void {
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
		action LIST_CLEAR(storage);
		size = 0;
		modCount++;
	}

	
	@Private
	fun checkElementIndex (index: int): void {
		//Работает ли в LibSL такой оператор "!" НЕ
		if (!isElementIndex(index)) 
		{
			//Работает ли такая конкатенация строк и можно ли внутри ифа  объявить локальную переменную
			var message: string =  "Index: "+index+", Size: "+size;
			action THROW_NEW('java.util._IndexOutOfBoundsException', [message]);
		}
	}
	
	
	@Private
	fun isElementIndex(index: int): boolean {
       	 	return index >= 0 && index < size;
    	}
	
	
	@Private
	fun isPositionIndex(index: int): boolean {
        	return index >= 0 && index <= size;
    	}
	
	
	@Private
	private void checkPositionIndex(int index) {
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

