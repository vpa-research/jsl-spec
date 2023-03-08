libsl '1.1.0';

library 'std:collections' language 'Java' version '11' url '-';

import 'java-common.lsl';
import 'list-actions.lsl';



@Alias('java.util.Set')
typealias Set = Object;    // #problem

@Alias('java.util.Map')
typealias Map = Object;    // #problem

@Alias('java.util.function.Function')
typealias Function = Object;    // #problem

@Alias('java.util.function.BiFunction')
typealias BiFunction = Object;    // #problem

@Alias('java.util.function.BiConsumer')
typealias BiConsumer = Object;    // #problem


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

    // #problem
    sub updateModifications(): void
    // #problem
    assigns self.modCounter;
    ensures self.modCounter' > self.modCounter;
    {
        // #problem
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
    requires !loadFactor.isNaN;  // #problem
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
            // #problem
            //for e in other.entrySet():
            //   m.put(e.getKey(), e.getValue());
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
        // #problem
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


    fun compute (key: Object, remappingFunction: BiFunction): Object
    requires remappingFunction != null;
    // side effects should be inferred from calls to other methods
    {
        val oldValue = self.get(key);
        
        val mc = modCounter;
        val newValue = action CALL(remappingFunction, [key, oldValue]);
        self.checkForModifications(mc);

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


    fun computeIfAbsent (key: Object, mappingFunction: Function): Object
    requires mappingFunction != null;
    // side effects should be inferred from calls to other methods
    {
        val oldValue = self.get(key);
        if (oldValue != null)
        {
            result = oldValue;
        }
        else
        {
            val mc = modCounter;
            val newValue = action CALL(mappingFunction, [key]);
            self.checkForModifications(mc);

            if (newValue != null)
            {
                self.put(key, newValue);
            }

            result = newValue;
        }
    }


    fun computeIfPresent (key: Object, remappingFunction: BiFunction): Object
    requires remappingFunction != null;
    // side effects should be inferred from calls to other methods
    {
        val oldValue = self.get(key);
        if (oldValue != null)
        {
            val mc = modCounter;
            val newValue = action CALL(remappingFunction, [key, oldValue]);
            self.checkForModifications(mc);

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
        else
        {
            result = null;
        }
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
    // side effects should be inferred from calls to other methods
    {
        val oldValue = self.get(key);
        if (oldValue == null)
        {
            self.put(key, value);
        }

        result = oldValue;
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
    // side effects should be inferred from calls to other methods
    {
        result = false;

        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
            val oldValue = action LIST_GET(values, idx);
            
            // #problem
            val isEqualValues = Objects.equals(value, oldValue);
            if (isEqualValues)
            {
                self.remove(m, key);
            
                result = true;
            }
        }
    }


    fun replace (key: Object, newValue: Object): Object
    // side effects should be inferred from calls to other methods
    {
        val oldValue = self.get(key);
        if (oldValue != null)
        {
            self.put(key, newValue);
        }

        result = oldValue;
    }


    fun replace (key: Object, oldValue: Object, newValue: Object): boolean
    assigns self.values;
    {
        result = false;

        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
            val value = action LIST_GET(values, idx);
            // #problem
            if (value == oldValue || (value != null && value.equals(oldValue)))
            {
                action LIST_SET(values, idx, newValue);

                self.updateModifications();

                result = true;
            }
        }
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
        val cKeys   = action LIST_DUP(keys);
        val cValues = action LIST_DUP(values);

        result = new HashMap(
            state=self.state, keys=cKeys, values=cValues, length=self.length);
    }


    fun values (): Collection   // #problem
    {
        // TODO: object instance caching

        result = new HashMap_Values(state=Initialized);
    }


    fun keySet (): Set
    {
        // TODO: object instance caching

        result = new HashMap_KeySet(state=Initialized);
    }


    fun merge (key: Object, value: Object, remappingFunction: BiFunction): Object
    requires value != null;
    requires remappingFunction != null;
    // side effects should be inferred from calls to other methods
    {
        val oldValue = self.get(key);
        if (oldValue != null)
        {
            val mc = modCounter;
            val newValue = action CALL(remappingFunction, [oldValue, value]);
            self.checkForModifications(mc);

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
        else
        {
            self.put(key, value);

            result = value;
        }
    }


    fun entrySet (): Set
    {
        result = new HashMap_EntrySet(state=Initialized);
    }


    // problematic methods

    fun toString (): string
    {
        // result = action OBJECT_TO_STRING(self);
        // #problem
        action NOT_IMPLEMENTED();
    }

    fun hashCode (): int
    {
        // result = action OBJECT_HASH_CODE(self);
        // #problem
        action NOT_IMPLEMENTED();
    }

    fun forEach (consumer: BiConsumer): void
    requires mapper != null;
    {
        // #problem
        action NOT_IMPLEMENTED();
    }

    fun putAll (other: Map): void
    requires other != null;
    {
        // #problem
        action NOT_IMPLEMENTED();
    }

    fun replaceAll (mapper: BiFunction): void
    requires mapper != null;
    {
        // #problem
        action NOT_IMPLEMENTED();
    }

    fun equals (other: Object): boolean
    {
        // #problem
        action NOT_IMPLEMENTED();
    }

    @Private
    @Throws(['IOException', 'ClassNotFoundException'])
    fun readObject(s: ObjectInputStream): void
    requires s != null;
    {
        val size = s.readInt();

        // #problem
        val buff = new int[size];
        // #problem
        s.readFully(buff);
        
        // #problem
        action FROM_BYTES(self, bytes);
    }
}




@PackagePrivate
@Extends('java.util.AbstractCollection')
automaton HashMap_Values: int
{
    initstate Initialized;
    
    shift Initialized -> self by [
        // read operations
        size,
        contains,
        
        iterator,
        spliterator,
        
        // write operations
        clear,
        forEach,
    ];


    // methods

    fun size(): int
    {
        result = self.parent.length;
    }


    fun contains(o: Object): boolean
    {
        result = self.parent.containsValue(o);
    }


    fun iterator(): Iterator
    {
        result = new HashMap_ValueIterator(
            state=Initialized, parent=self.parent, expectedModCount=self.parent.modCounter);
    }


    fun spliterator(): Spliterator
    {
        result = new HashMap_ValueSpliterator(state=Initialized,
            // #problem
            parent=self.parent);
    }


    fun clear(): void
    {
        self.parent.clear();
    }


    fun forEach(consumer: Consumer): void
    {
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
        // #problem
        result = self.parent.length;
    }


    fun clear(): void
    // #problem
    assigns self.parent;
    {
        // #problem
        result = self.parent.clear();
    }


    fun iterator(): Iterator
    {
        result = new HashMap_KeyIterator(
            state=Initialized, parent=self.parent, expectedModCount=self.parent.modCounter);
    }


    fun contains(o: Object): boolean
    {
        result = self.parent.containsKey(o);
    }


    fun remove(key: Object): boolean
    assigns self.parent;
    {
        val oldValue = self.parent.remove(key);
        result = oldValue != null;
    }
}




@PackagePrivate
@Implements('java.util.Iterator')
automaton HashMap_KeyIterator: int
(
    var index: int;
    var expectedModCount: int;
    var nextWasCalled: boolean;
)
{
    initstate Initialized;
    
    shift Initialized -> self by [
        // read operations
        hasNext,
        
        // write operations
        next,
        remove,
    ];


    // methods

    fun hasNext(): boolean
    {
        result = index < self.parent.length;
    }


    fun next(): Object
    {
        self.parent.checkForModifications(expectedModCount);

        val atValidPosition = self.hasNext();
        if (!atValidPosition)
        {
            action THROW_NEW('java.util.NoSuchElementException');
        }

        result = action LIST_GET(self.parent.keys, index);

        index += 1;
        nextWasCalled = true;
    }


    fun remove(): void
    {
        val atValidPosition = self.hasNext();
        if (!atValidPosition || !nextWasCalled)
        {
            action THROW_NEW('java.lang.IllegalStateException');
        }
        nextWasCalled = false;

        self.parent.checkForModifications(expectedModCount);

        val key = action LIST_GET(self.parent.keys, index);
        self.parent.remove(key);

        expectedModCount = self.parent.modCounter;
    }
}




// TODO
// HashMap_ValueIterator
// HashMap_ValueSpliterator
// HashMap_EntrySet
