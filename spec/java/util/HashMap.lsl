libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

// imports

import "list-actions.lsl";

import "java-common.lsl";
import "java/util/interfaces.lsl"
import "java/util/function/interfaces.lsl"


@TypeMapping("java.util.ObjectInputStream")
typealias ObjectInputStream = Object;  // #problem


// automata

@Public
@Extends("java.util.AbstractMap")
@WrapperMeta(
    src="java.util.HashMap",
    dst="ru.spbpu.libsl.overrides.collections.HashMap",
    forceMatchInterfaces=true,
)
automaton HashMap: int
(
    var keys: list<Object> = null;
    var values: list<Object> = null;
    var length: int = 0;
    @Transient var modCounter: int = 0;

    @Private @Static @Final serialVersionUID: long = 362498820763181265;
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

    proc _initLists(): void
    {
        assigns self.keys;
        assigns self.values;
        ensures self.keys != null;
        ensures self.values != null;

        keys = new list(); // #problem: can we use LIST_RESIZE to also allocate this object?
        values = new list();
    }


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
        val idx = action LIST_FIND(keys, key, 0, length, +1);
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

        val idx = action LIST_FIND(keys, key, 0, length, +1);
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
        ensures self.length' < self.length;

        result = action LIST_GET(values, index);

        action LIST_REMOVE(keys, index);
        action LIST_REMOVE(values, index);

        length -= 1;
        self._updateModifications();
    }


    proc _removeMapping (key: Object): Object
    {
        // side effects should be inferred from calls to other subroutines
        ensures self.length' <= self.length;

        val idx = action LIST_FIND(keys, key, 0, length, +1);
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

        self._initLists();

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

        self._initLists();

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

        self._initLists();

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
        ensures self.length >= 0;
        ensures self.modCounter == 0;

        self._initLists();
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


    proc _clearMappings (): void
    {
        assigns self.keys;
        assigns self.values;
        assigns self.length;
        ensures self.length == 0;

        length = 0;
        action LIST_RESIZE(keys, 0);
        action LIST_RESIZE(values, 0);

        self._updateModifications();
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
            val idx = action LIST_FIND(keys, key, 0, length, +1);
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
            val idx = action LIST_FIND(values, value, 0, length, +1);
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

        val idx = action LIST_FIND(keys, key, 0, length, +1);
        if (idx >= 0)
        {
            val oldValue = action LIST_GET(values, idx);

            val isEqualValues = Objects.equals(value, oldValue);  // #problem
            if (isEqualValues)
            {
                self._removeMapping(idx);

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

        val idx = action LIST_FIND(keys, key, 0, length, +1);
        if (idx >= 0)
        {
            val value = action LIST_GET(values, idx);
            // #problem
            if (value == oldValue || (value != null && Objects.equals(value, oldValue)))
            {
                action LIST_SET(values, idx, newValue);

                self._updateModifications();

                result = true;
            }
        }
    }


    fun clear (): void
    {
        self._clearMappings();
    }


    fun clone (): Object
    {
        val cKeys   = action LIST_COPY(keys, 0, length);
        val cValues = action LIST_COPY(values, 0, length);

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
        result = new HashMap_EntrySet(state=Initialized); // parent will be implicitly set to self
    }


    // problematic methods

//    fun toString (): string
//    {
//        // result = action OBJECT_TO_STRING(self);
//        // #problem
//        action NOT_IMPLEMENTED();
//    }

//    fun hashCode (): int
//    {
//        // result = action OBJECT_HASH_CODE(self);
//        // #problem
//        action NOT_IMPLEMENTED();
//    }

//    fun equals (other: Object): boolean
//    {
//        // #problem
//        action NOT_IMPLEMENTED();
//    }

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

    @Private
    @Throws(["IOException", "ClassNotFoundException"])
    fun readObject(s: ObjectInputStream): void
    {
        requires s != null;

        action NOT_IMPLEMENTED();

//        val size = s.readInt();

//        // #problem
//        val buff = new int[size];
//        // #problem
//        s.readFully(buff);

//        // #problem
//        action FROM_BYTES(self, bytes);
    }
}




@From("HashMap")
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
//        spliterator,

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
            result = action LIST_FIND(self.parent.values, value, 0, self.parent.length, +1);
        }
    }


    fun iterator(): Iterator
    {
        result = new HashMap_ValueIterator(
            state=Initialized, parent=self.parent, expectedModCount=self.parent.modCounter);
    }


// #todo
//    fun spliterator(): Spliterator
//    {
//        result = new HashMap_ValueSpliterator(state=Initialized, parent=self.parent);
//    }


    fun clear(): void
    {
        assigns self.parent;

        self.parent._clearMappings();
    }


    fun forEach(consumer: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }
}




@From("HashMap")
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
//        spliterator,

        // write operations
        clear,
        remove,
    ];


    // methods

    fun size (): int
    {
        result = self.parent.length;
    }


    fun clear (): void
    {
        assigns self.parent;

        result = self.parent._clearMappings();
    }


    fun iterator (): Iterator
    {
        result = new HashMap_KeyIterator(
            state=Initialized, parent=self.parent, expectedModCount=self.parent.modCounter);
    }


// #todo
//    fun spliterator (): Spliterator
//    {
//        result = new HashMap_KeySpliterator(state=Initialized, parent=self.parent);
//    }


    fun contains (key: Object): boolean
    {
        if (self.parent.length == 0)
        {
            result = false;
        }
        else
        {
            result = action LIST_FIND(self.parent.keys, key, 0, self.parent.length, +1);
        }
    }


    fun remove (key: Object): boolean
    {
        assigns self.parent;

        val oldValue = self.parent._removeMapping(key);
        result = oldValue != null;
    }
}




@From("HashMap")
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

    fun hasNext (): boolean
    {
        result = index < self.parent.length;
    }


    fun next (): Object
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


    fun remove (): void
    {
        val atValidPosition = index < self.parent.length;
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




@From("HashMap")
@PackagePrivate
@Implements(["java.util.Iterator"])
automaton HashMap_ValueIterator: int
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

    fun hasNext (): boolean
    {
        result = index < self.parent.length;
    }


    fun next (): Object
    {
        self.parent._checkForModifications(expectedModCount);

        val atValidPosition = index < self.parent.length;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        result = action LIST_GET(self.parent.values, index);

        index += 1;
        nextWasCalled = true;
    }


    fun remove (): void
    {
        val atValidPosition = index < self.parent.length;
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




@From("HashMap")
@PackagePrivate
@Implements(["java.util.Map.Entry"])
automaton HashMap_Entry: int
(
    var index: int;
)
{
    initstate Initialized;

    shift Initialized -> self by [
        // read operations

        getKey,
        getValue,

        equals,
        toString,
        hashCode,

        // write operations

        setValue,
    ];


    // methods

    fun getKey (): Object
    {
        // TODO: key caching

        // we do not have references to arbitrary types, so 'action' it is
        result = action LIST_GET(self.parent.keys, index);
    }


    fun getValue (): Object
    {
        result = action LIST_GET(self.parent.values, index);
    }


    fun setValue (newValue: Object): Object
    {
        result = action LIST_GET(self.parent.values, index);

        action LIST_SET(self.parent.values, index, newValue);
    }


    fun equals (other: Object): Object
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            // #problem
            // instanceof

            // #problem
            // val key = action CALL_INTERFACE(other, "getKey():java.lang.Object", []);

            action NOT_IMPLEMENTED();
        }
    }


    fun toString (): string
    {
        val key   = action LIST_GET(self.parent.keys, index);
        val value = action LIST_GET(self.parent.values, index);

        val sKey   = action OBJECT_TO_STRING(key);
        val sValue = action OBJECT_TO_STRING(value);

        result = sKey + "=" + sValue;
    }


    fun hashCode (): int
    {
        val key   = action LIST_GET(self.parent.keys, index);
        val value = action LIST_GET(self.parent.values, index);

        val hKey   = action OBJECT_HASH_CODE(key);
        val hValue = action OBJECT_HASH_CODE(value);

        result = hKey ^ hValue;
    }

}




@From("HashMap")
@PackagePrivate
@Extends("java.util.AbstractSet")
automaton HashMap_EntrySet: int
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
        remove,
    ];


    // methods

    fun size (): int
    {
        result = self.parent.length;
    }


    fun clear (): void
    {
        assigns self.parent;

        result = self.parent._clearMappings();
    }


    fun iterator (): Iterator
    {
        result = new HashMap_EntryIterator(
            state=Initialized, parent=self.parent, expectedModCount=self.parent.modCounter);
    }


    fun spliterator (): Spliterator
    {
        result = new HashMap_EntrySpliterator(state=Initialized, parent=self.parent);
    }


    fun contains (e: Object): boolean
    {
        if (self.parent.length == 0)
        {
            result = false;
        }
        else
        {
            // #problem
            // instanceof

            // #problem
            // val key = action CALL_INTERFACE(other, "getKey():java.lang.Object", []);

            action NOT_IMPLEMENTED();
        }
    }


    fun remove (e: Object): boolean
    {
        assigns self.parent;

        // #problem
        // val key = action CALL_INTERFACE(e, "getKey():java.lang.Object", []);

        val oldValue = self.parent._removeMapping(key);
        result = oldValue != null;
    }
}




// TODO
// HashMap_EntryIterator
// HashMap_ValueSpliterator
// HashMap_KeySpliterator
// HashMap_EntrySpliterator
