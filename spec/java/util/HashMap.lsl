libsl '1.1.0';

library 'std:collections' language 'Java' version '11' url '-';

import 'java-common.lsl';
import 'list-actions.lsl';



@Alias('java.util.Set')
typealias Set = Object;    @problem

@Alias('java.util.Map')
typealias Map = Object;    @problem

@Alias('java.util.function.Function')
typealias Function = Object;    @problem

@Alias('java.util.function.BiFunction')
typealias BiFunction = Object;    @problem

@Alias('java.util.function.BiConsumer')
typealias BiConsumer = Object;    @problem


@Public
@Extends('java.util.AbstractMap')
@WrapperMeta(
    src='java.util.HashMap',
    dst='org.utbot.engine.overrides.collections.UtHashMap',
    matchInterfaces=true,
)
automaton HashMap: int
(
    var keys: list<Object>;
    var values: list<Object>;
    var length: int;
    @Transient var modCounter: int;
)
{
    initstate Allocated;
    finishstate Initialized;
    
    // constructors
    shift Allocated -> Initialized by [
		HashMap(),
		HashMap(int),
		HashMap(int, float),
		HashMap(Map)
	];
    
    shift Initialized -> self by [
		// read operations
        get,
        getOrDefault,
        containsKey,
        containsValue,
        size,
        isEmpty,
        toString,
        hashCode,
        
        clone,
        keySet,
        
		// write operations
		put,
		putAll,
		clear,
		compute,
		computeIfAbsent,
		computeIfPresent,
    ];
    
    
    // utilities
    
    @problem
    sub updateModifications(): void
    @problem
    assigns self.modCounter;
    enshures self.modCounter' > self.modCounter;
    {
		@problem
		self.modCounter += 1;
    }
    
    
    sub checkForModifications(lastMods: int): void
    {
		if (modCounter != lastMods)
		{
			action THROW_NEW('java.util.ConcurrentModificationException', []);
		}
    }
    
    
    // constructors
    
    constructor HashMap (): void
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    assigns self.modCounter;
    ensures self.length = 0;
    ensures self.modCounter = 0;
    {
		length = 0;
		modCounter = 0;
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);
    }
    
    constructor HashMap (initialCapacity: int): void
    requires initialCapacity >= 0;
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    assigns self.modCounter;
    ensures self.length = 0;
    ensures self.modCounter = 0;
    {
		length = 0;
		modCounter = 0;
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);
    }
    
    constructor HashMap (initialCapacity: int, loadFactor: float): void
    requires initialCapacity >= 0;
    requires loadFactor > 0;
    requires !loadFactor.isNaN;  @problem
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    assigns self.modCounter;
    ensures self.length = 0;
    ensures self.modCounter = 0;
    {
		length = 0;
		modCounter = 0;
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);
    }
    
    constructor HashMap (other: Map): void
    requires other != null;
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    assigns self.modCounter;
    ensures self.modCounter = 0;
    {
		modCounter = 0;
    
		val otherSize = other.size();
        if (otherSize > 0)
        {
            //for e in other.entrySet():
            //    m.put(e.getKey(), e.getValue());
            @problem
            action NOT_IMPLEMENTED();
        }
        else
        {
			length = 0;
			action LIST_RESIZE(keys, 0);
			action LIST_RESIZE(values, 0);
        }
    }
    
    
    // methods
    
    fun containsKey (key: Object): boolean
    {
		if (length == 0)
		{
			result = false;
		}
		else
		{
			val idx = action LIST_FIND(keys, key);
			result = idx >= 0;
        }
    }


    fun containsValue (value: Object): boolean
    {
		if (length == 0)
		{
			result = false;
		}
		else
		{
			val idx = action LIST_FIND(values, value);
			result = idx >= 0;
		}
    }

    
    fun size (): int
    {
        result = length;
    }

    
    fun isEmpty (): boolean
    {
        result = length == 0;
    }


    fun get (key: Object): Object
    {
		@problem
        result = self.getOrDefault(key, null);
    }


    fun getOrDefault (key: Object, default: Object): Object
    {
        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
            result = action LIST_GET(values, idx);
        }
        else
        {
            result = default;
        }
    }


    fun compute (key: Object, mapper: BiFunction): Object
    requires mapper != null;
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    {
        val oldValue = self.get(key);
        
        val mc = modCounter;
        val newValue = action CALL(mapper, [key, oldValue]);
        checkModifications(mc);

        if (newValue == null)
        {
			self.remove(key);
        }
        else
        {
			self.put(key, newValue);
        }
        
        result = newValue;
    }


    fun computeIfAbsent (key: Object, mapper: Function): Object
    requires mapper != null;
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    {
        val idx = action LIST_FIND(keys, key);
        if (idx < 0)
        {
			val mc = modCounter;
            val newValue = action CALL(mapper, [key]);
			checkModifications(mc);
			
			self.put(key, newValue);
			
			result = newValue;
        }
        else
        {
			result = action LIST_GET(values, idx);
        }
    }
    
    
    fun computeIfPresent (key: Object, mapper: BiFunction): Object
    requires mapper != null;
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    {
		action TODO();
    }


    fun put (key: Object, value: Object): Object
    assigns self.keys;
    assigns self.values;
    ensures self.length' >= self.length;
    {
        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
			result = action LIST_GET(values, idx);
			
            action LIST_SET(values, idx, value);
        }
        else
        {
            val newLength = length + 1;
            action LIST_RESIZE(keys, newLength);
            action LIST_RESIZE(values, newLength);
            
            val newIdx = length;
            action LIST_SET(keys, newIdx, key);
            action LIST_SET(values, newIdx, value);
            
            length = newLength;
            
            result = null;
        }
        
        self.updateModifications();
    }
    
    
    fun putIfAbsent (key: Object, value: Object): Object
	assigns self.keys;
    assigns self.values;
    ensures self.length' >= self.length;
	{
		val oldValue = self.get(key);
		
		action TODO();
		
		self.updateModifications();
	}


    fun remove (key: Object): Object
    assigns self.keys;
    assigns self.values;
    ensures self.length' <= self.length;
    {
        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
			result = action LIST_GET(values, idx);
			
            action LIST_REMOVE(keys, idx);
            action LIST_REMOVE(values, idx);
			
			length -= 1;
			self.updateModifications();
        }
        else
        {
			result = null;
        }
    }


    fun remove (key: Object, value: Object): boolean
    assigns self.keys;
    assigns self.values;
    ensures self.length' <= self.length;
    {
        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
			val oldValue = action LIST_GET(values, idx);
			
			@problem
			val isEqualValues = Objects.equals(value, oldValue);
			if (isEqualValues)
			{
				self.remove(m, key);
			
				result = true;
			}
			else
			{
				result = false;
			}
        }
        else
        {
			result = false;
        }
    }
    
    
    fun replace (key: Object, newValue: Object): Object
    {
		action TODO();
    }
    
    
    fun replace (key: Object, oldValue: Object, newValue: Object): boolean
    {
		action TODO();
    }


    fun clear (): void
    assigns self.keys;
    assigns self.values;
    assigns self.length;
    ensures self.length == 0;
    {
        length = 0;
        self.updateModifications();
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);
    }


    fun clone (): Object
    {
        val cState  = state;
        val cKeys   = action LIST_DUP(keys);
        val cValues = action LIST_DUP(values);
        val cLength = length;
        
        result = new HashMap(
			state=cState, keys=cKeys, values=cValues, length=cLength);
    }

    
    fun values (): Collection
    {
		val newValues = action LIST_DUP(values);
    
		//result = new ArrayList(state=Initialized, values=newValues);
		action TODO();
    }
    
    
    fun keySet (): Set
    {
		val newKeys = action LIST_DUP(keys);
		
		result = new HashMap_KeySet(state=Initialized, values=newKeys);
    }
    
    
    fun merge (key: Object, value: Object, remapping: BiFunction): Object
    require value != null;
    require remapping != null;
    assigns self.values;
	{
		action TODO();
    }
    
    
    fun entrySet (): Set
    {
		action TODO();
    }
    
    
    // problematic methods
    
    fun toString (): string
    {
		@problem
        action NOT_IMPLEMENTED();
    }

    fun hashCode (): int
    {
		@problem
        action NOT_IMPLEMENTED();
    }
    
    fun forEach (consumer: BiConsumer): void
    requires mapper != null;
	{
		@problem
        action NOT_IMPLEMENTED();
    }
    
    fun putAll (other: Map): void
    requires other != null;
	{
		@problem
        action NOT_IMPLEMENTED();
    }
    
    fun replaceAll (mapper: BiFunction): void
    requires mapper != null;
	{
		@problem
        action NOT_IMPLEMENTED();
    }
    
    fun equals (other: Object): boolean
    {
		@problem
        action NOT_IMPLEMENTED();
    }
}




@PackagePrivate
@Extends('java.util.AbstractSet')
automaton HashMap_KeySet: int
{
	initstate Initialized;
	
	shift Initialized -> self by [
		// read operations
		size,
        contains,
		
        iterator,
		
		// write operations
		clear,
        remove,
	];


	// methods
	
    fun size(): int
	{
		@problem
		result = parent.length;
	}


    fun clear(): void
    @problem
	assigns self.parent;
	{
		@problem
		result = parent.clear();
	}


    fun iterator(): Iterator
	{
		@problem
		val iParent = parent;
	
		result = new HashMap_KeyIterator(
			state=Initialized, parent=iParent, index=0);
	}


    fun contains(o: Object): boolean
	{
		result = parent.containsKey(o);
	}


    fun remove(key: Object): boolean
	assigns self.parent;
	{
		val oldValue = parent.remove(key);
		result = oldValue != null;
	}
}


// TODO


@PackagePrivate
automaton HashMap_KeyIterator: int
(
	var index: int = 0;
)
{
	;
}

