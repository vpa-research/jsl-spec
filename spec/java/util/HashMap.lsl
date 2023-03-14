libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

// imports

import "list-actions.lsl";

import "java-common.lsl";
import "java/util/interfaces.lsl"
import "java/util/function/interfaces.lsl"


// automata

@Public
@Extends("java.util.AbstractMap")
@WrapperMeta(
    src="java.util.HashMap",
    dst="org.utbot.engine.overrides.collections.UtHashMap",
    matchInterfaces=true,
)
automaton HashMap: int
(
    var keys: list<Object> = new list();
    var values: list<Object> = new list();  // #problem
    var length: int = 0;
    @Transient var modCounter: int = 0;
)
{
    initstate Allocated;
    state Initialized;

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

    proc _updateModifications(): void
    {
        assigns self.modCounter;
        ensures self.modCounter' > self.modCounter;

        self.modCounter += 1;
    }


    proc _checkForModifications(lastMods: int): void
    {
        if (modCounter != lastMods)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    proc _getMappingOrDefault (key: Object, defaultValue: Object): Object
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


    proc _setMapping (key: Object, value: Object): Object
    {
        assigns self.keys;
        assigns self.values;
        ensures self.length' >= self.length;

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
        
        self._updateModifications();
    }


    proc _removeMapping (index: int): Object
    {
        requires index >= 0 && index < self.length;
        assigns self.keys;
        assigns self.values;
        ensures self.length' <= self.length;

        result = action LIST_GET(values, index);
        
        action LIST_REMOVE(keys, index);
        action LIST_REMOVE(values, index);
        
        length -= 1;
        self._updateModifications();
    }


    proc _removeMapping (key: Object): Object
    {
        // side effects should be inferred from calls to other subroutines

        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
            result = self._removeMapping(idx);
        }
        else
        {
            result = null;
        }
    }


    // constructors

    constructor HashMap ()
    {
        assigns self.keys;
        assigns self.values;
        assigns self.length;
        assigns self.modCounter;
        ensures self.length == 0;
        ensures self.modCounter == 0;

        length = 0;
        modCounter = 0;
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);
    }


    constructor HashMap (initialCapacity: int)
    {
        requires initialCapacity >= 0;
        assigns self.keys;
        assigns self.values;
        assigns self.length;
        assigns self.modCounter;
        ensures self.length == 0;
        ensures self.modCounter == 0;

        length = 0;
        modCounter = 0;
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);
    }


    constructor HashMap (initialCapacity: int, loadFactor: float)
    {
        requires initialCapacity >= 0;
        requires loadFactor > 0;
        requires !loadFactor.isNaN;  // #problem
        assigns self.keys;
        assigns self.values;
        assigns self.length;
        assigns self.modCounter;
        ensures self.length == 0;
        ensures self.modCounter == 0;

        length = 0;
        modCounter = 0;
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);
    }


    constructor HashMap (other: Map)
    {
        requires other != null;
        assigns self.keys;
        assigns self.values;
        assigns self.length;
        assigns self.modCounter;
        ensures self.modCounter == 0;

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
        result = self._getMappingOrDefault(key, null);
    }


    fun getOrDefault (key: Object, defaultValue: Object): Object
    {
        result = self._getMappingOrDefault(key, defaultValue);
    }


    fun compute (key: Object, remappingFunction: BiFunction): Object
    {
        requires remappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        val oldValue = self._getMappingOrDefault(key, null);

        val mc = modCounter;
        val newValue = action CALL(remappingFunction, [key, oldValue]);
        self._checkForModifications(mc);

        if (newValue == null)
        {
            self._removeMapping(key);
        }
        else
        {
            self._setMapping(key, newValue);
        }

        result = newValue;
    }


    fun computeIfAbsent (key: Object, mappingFunction: Function): Object
    {
        requires mappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        val oldValue = self._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            result = oldValue;
        }
        else
        {
            val mc = modCounter;
            val newValue = action CALL(mappingFunction, [key]);
            self._checkForModifications(mc);

            if (newValue != null)
            {
                self._setMapping(key, newValue);
            }

            result = newValue;
        }
    }


    fun computeIfPresent (key: Object, remappingFunction: BiFunction): Object
    {
        requires remappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        val oldValue = self._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            val mc = modCounter;
            val newValue = action CALL(remappingFunction, [key, oldValue]);
            self._checkForModifications(mc);

            if (newValue == null)
            {
                self._removeMapping(key);
            }
            else
            {
                self._setMapping(key, newValue);
            }

            result = newValue;
        }
        else
        {
            result = null;
        }
    }


    fun put (key: Object, value: Object): Object
    {
        // side effects should be inferred from calls to other subroutines

        result = self._setMapping(key, value);
    }


    fun putIfAbsent (key: Object, value: Object): Object
    {
        // side effects should be inferred from calls to other subroutines

        val oldValue = self._getMappingOrDefault(key, null);
        if (oldValue == null)
        {
            self._setMapping(key, value);
        }

        result = oldValue;
    }


    fun remove (key: Object): Object
    {
        result = self._removeMapping(key);
    }


    fun remove (key: Object, value: Object): boolean
    {
        // side effects should be inferred from calls to other subroutines

        result = false;

        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
            val oldValue = action LIST_GET(values, idx);
            
            val isEqualValues = Objects.equals(value, oldValue);  // #problem
            if (isEqualValues)
            {
                self._removeMapping(m, key);
            
                result = true;
            }
        }
    }


    fun replace (key: Object, newValue: Object): Object
    {
        // side effects should be inferred from calls to other subroutines

        val oldValue = self._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            self._setMapping(key, newValue);
        }

        result = oldValue;
    }


    fun replace (key: Object, oldValue: Object, newValue: Object): boolean
    {
        assigns self.values;

        result = false;

        val idx = action LIST_FIND(keys, key);
        if (idx >= 0)
        {
            val value = action LIST_GET(values, idx);
            // #problem
            if (value == oldValue || (value != null && value.equals(oldValue)))
            {
                action LIST_SET(values, idx, newValue);

                self._updateModifications();

                result = true;
            }
        }
    }


    fun clear (): void
    {
        assigns self.keys;
        assigns self.values;
        assigns self.length;
        ensures self.length == 0;

        length = 0;
        self._updateModifications();
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


    fun values (): Collection
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
    {
        requires value != null;
        requires remappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        val oldValue = self._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            val mc = modCounter;
            val newValue = action CALL(remappingFunction, [oldValue, value]);
            self._checkForModifications(mc);

            if (newValue == null)
            {
                self._removeMapping(key);
            }
            else
            {
                self._setMapping(key, newValue);
            }

            result = newValue;
        }
        else
        {
            self._setMapping(key, value);

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
    {
        requires mapper != null;

        // #problem
        action NOT_IMPLEMENTED();
    }

    fun putAll (other: Map): void
    {
        requires other != null;

        // #problem
        action NOT_IMPLEMENTED();
    }

    fun replaceAll (mapper: BiFunction): void
    {
        requires mapper != null;

        // #problem
        action NOT_IMPLEMENTED();
    }

    fun equals (other: Object): boolean
    {
        // #problem
        action NOT_IMPLEMENTED();
    }

    @Private
    @Throws(["IOException", "ClassNotFoundException"])
    fun readObject(s: ObjectInputStream): void
    {
        requires s != null;

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
@Extends("java.util.AbstractCollection")
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


    fun contains(value: Object): boolean
    {
        if (self.parent.length == 0)
        {
            result = false;
        }
        else
        {
            result = action LIST_FIND(self.parent.values, value);
        }
    }


    fun iterator(): Iterator
    {
        result = new HashMap_ValueIterator(
            state=Initialized, parent=self.parent, expectedModCount=self.parent.modCounter);
    }


    fun spliterator(): Spliterator
    {
        result = new HashMap_ValueSpliterator(state=Initialized, parent=self.parent);
    }


    fun clear(): void
    {
        // #todo
        self.parent.clear();
    }


    fun forEach(consumer: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }
}




@PackagePrivate
@Extends("java.util.AbstractSet")
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
        result = self.parent.length;
    }


    fun clear(): void
    {
        assigns self.parent;

        // #todo
        result = self.parent.clear();
    }


    fun iterator(): Iterator
    {
        result = new HashMap_KeyIterator(
            state=Initialized, parent=self.parent, expectedModCount=self.parent.modCounter);
    }


    fun contains(key: Object): boolean
    {
        if (self.parent.length == 0)
        {
            result = false;
        }
        else
        {
            result = action LIST_FIND(self.parent.keys, key);
        }
    }


    fun remove(key: Object): boolean
    {
        assigns self.parent;

        val oldValue = self.parent._removeMapping(key);
        result = oldValue != null;
    }
}




@PackagePrivate
@Implements(["java.util.Iterator"])
automaton HashMap_KeyIterator: int
(
    var index: int = 0;
    var expectedModCount: int;
    var nextWasCalled: boolean = false;
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
        self.parent._checkForModifications(expectedModCount);

        val atValidPosition = index < self.parent.length;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
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
            action THROW_NEW("java.lang.IllegalStateException", []);
        }
        nextWasCalled = false;

        self.parent._checkForModifications(expectedModCount);

        self.parent._removeMapping(index);

        expectedModCount = self.parent.modCounter;
    }
}




// TODO
// HashMap_ValueIterator
// HashMap_ValueSpliterator
// HashMap_EntrySet
