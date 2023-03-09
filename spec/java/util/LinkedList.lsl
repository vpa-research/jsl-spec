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
    	action LIST_RESIZE(storage, 0);
	//problem:
	//we don't know how to avoid cycle i this method
	//addAll(c);
    }
    
    

}

