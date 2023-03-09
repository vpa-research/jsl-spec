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
		//problem:
		//we don't know how to avoid cycle i this method
		//addAll(c);
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
		result = action LIST_REMOVE(storage, index);
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
		result = action LIST_FIND(storage,o) >= 0;
	}


	fun size (): int{
		result = size;
	}


	fun add (e: Object): boolean {
		linkAny(size-1, e);
		result = true;
	}

	
	
	fun remove (o: Object): boolean {
		result = action LIST_REMOVE(storage, o);
		*Можно ли писать result НЕ в самом конце ? *
		if(result == true)
		{
			*Существует ли такой -= оператор в LibSL ?*
			size--;
			modCount++;	
		}
	}

}

