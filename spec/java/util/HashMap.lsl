//#! pragma: non-synthesizable
libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

// imports

//import "list-actions.lsl";

//import "java-common.lsl";
//import "java/util/_interfaces.lsl";
//import "java/util/function/_interfaces.lsl";


//@TypeMapping("java.util.ObjectInputStream")
//typealias ObjectInputStream = Object;  // #problem


// automata

@public
@extends("java.util.AbstractMap")
/*@WrapperMeta(
    src="java.util.HashMap",
    dst="ru.spbpu.libsl.overrides.collections.HashMap",
    forceMatchInterfaces=true,
)*/
automaton HashMap // : int
(
    var keys: list<Object> = null;
    var values: list<Object> = null;
    @transient var length: int = 0;
    @transient var modCounter: int = 0;

    @private @static @final var serialVersionUID: long = 362498820763181265;
): int
{
    initstate Allocated;
    state Initialized;

    // constructors
    shift Allocated -> Initialized by (
        HashMap(),
        HashMap(int),
        HashMap(int, float),
        HashMap(Map)
    );

    shift Initialized -> this by [
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
        assigns this.keys;
        assigns this.values;
        ensures this.keys != null;
        ensures this.values != null;

        this.keys = action LIST_NEW(); // #problem: can we use LIST_RESIZE to also allocate this object?
        this.values = action LIST_NEW();
    }


    proc _updateModifications(): void
    {
        assigns this.modCounter;
        ensures this.modCounter' > this.modCounter;

        this.modCounter += 1;
    }


    proc _checkForModifications(lastMods: int): void
    {
        if (this.modCounter != lastMods)
        {
            action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    proc _getMappingOrDefault (key: Object, defaultValue: Object): Object
    {
        val idx: int = action LIST_FIND(this.keys, key, 0, this.length, +1);
        if (idx >= 0)
        {
            result = action LIST_GET(this.values, idx);
        }
        else
        {
            result = default;
        }
    }


    proc _setMapping (key: Object, value: Object): Object
    {
        assigns this.keys;
        assigns this.values;
        ensures this.length' >= this.length;

        val idx: int = action LIST_FIND(this.keys, key, 0, this.length, +1);
        if (idx >= 0)
        {
            result = action LIST_GET(this.values, idx);

            action LIST_SET(this.values, idx, value);
        }
        else
        {
            val newLength: int = this.length + 1;
            action LIST_RESIZE(this.keys, newLength);
            action LIST_RESIZE(this.values, newLength);

            val newIdx: int = this.length;
            action LIST_SET(this.keys, newIdx, key);
            action LIST_SET(this.values, newIdx, value);

            this.length = newLength;

            result = null;
        }

        this._updateModifications();
    }


    proc _removeMapping (index: int): Object
    {
        requires index >= 0 && index < this.length;
        assigns this.keys;
        assigns this.values;
        ensures this.length' < this.length;

        result = action LIST_GET(this.values, index);

        action LIST_REMOVE(this.keys, index);
        action LIST_REMOVE(this.values, index);

        this.length -= 1;
        this._updateModifications();
    }


    proc _removeMapping (key: Object): Object
    {
        // side effects should be inferred from calls to other subroutines
        ensures this.length' <= this.length;

        val idx: int = action LIST_FIND(this.keys, key, 0, this.length, +1);
        if (idx >= 0)
        {
            result = this._removeMapping(idx);
        }
        else
        {
            result = null;
        }
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // constructors

    constructor HashMap ()
    {
        assigns this.keys;
        assigns this.values;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length == 0;
        ensures this.modCounter == 0;

        this._initLists();

        this.length = 0;
        this.modCounter = 0;
    }


    constructor HashMap (initialCapacity: int)
    {
        requires initialCapacity >= 0;
        assigns this.keys;
        assigns this.values;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length == 0;
        ensures this.modCounter == 0;

        if (initialCapacity < 0)
        {
            val initCapStr: string = action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal initial capacity: " + initCapStr]);
        }

        this._initLists();

        this.length = 0;
        this.modCounter = 0;
    }


    constructor HashMap (initialCapacity: int, loadFactor: float)
    {
        requires initialCapacity >= 0;
        requires loadFactor > 0;
        requires !loadFactor.isNaN;  // #problem
        assigns this.keys;
        assigns this.values;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length == 0;
        ensures this.modCounter == 0;

        if (initialCapacity < 0)
        {
            val initCapStr: string = action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal initial capacity: " + initCapStr]);
        }

        if (loadFactor <= 0 || loadFactor.isNaN) // #problem
        {
            val loadFactorStr: string = action OBJECT_TO_STRING(loadFactor);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal load factor: " + loadFactorStr]);
        }

        this._initLists();

        this.length = 0;
        this.modCounter = 0;
    }


    constructor HashMap (other: Map)
    {
        requires other != null;
        assigns this.keys;
        assigns this.values;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length >= 0;
        ensures this.modCounter == 0;

        this._initLists();
        this.modCounter = 0;

        val otherSize: int = other.size();
        if (otherSize > 0)
        {
            // #problem
            // for e in other.entrySet():
            //   m.put(e.getKey(), e.getValue());
            action NOT_IMPLEMENTED();
        }
        else
        {
            this.length = 0;
            action LIST_RESIZE(this.keys, 0);
            action LIST_RESIZE(this.values, 0);
        }
    }


    proc _clearMappings (): void
    {
        assigns this.keys;
        assigns this.values;
        assigns this.length;
        ensures this.length == 0;

        this.length = 0;
        this.keys = action LIST_NEW();
        this.values = action LIST_NEW();

        this._updateModifications();
    }


    // methods

    fun containsKey (key: Object): boolean
    {
        if (this.length == 0)
        {
            result = false;
        }
        else
        {
            val idx: int = action LIST_FIND(this.keys, key, 0, this.length, +1);
            result = idx >= 0;
        }
    }


    fun containsValue (value: Object): boolean
    {
        if (this.length == 0)
        {
            result = false;
        }
        else
        {
            val idx: int = action LIST_FIND(this.values, value, 0, this.length, +1);
            result = idx >= 0;
        }
    }


    fun size (): int
    {
        result = this.length;
    }


    fun isEmpty (): boolean
    {
        result = this.length == 0;
    }


    fun get (key: Object): Object
    {
        result = this._getMappingOrDefault(key, null);
    }


    fun getOrDefault (key: Object, defaultValue: Object): Object
    {
        result = this._getMappingOrDefault(key, defaultValue);
    }


    fun compute (key: Object, remappingFunction: BiFunction): Object
    {
        requires remappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        if (remappingFunction == null)
        {
            this._throwNPE();
        }

        val oldValue: Object = this._getMappingOrDefault(key, null);

        val mc: int = this.modCounter;
        val newValue: Object = action CALL(remappingFunction, [key, oldValue]);
        this._checkForModifications(mc);

        if (newValue == null)
        {
            this._removeMapping(key);
        }
        else
        {
            this._setMapping(key, newValue);
        }

        result = newValue;
    }


    fun computeIfAbsent (key: Object, mappingFunction: Function): Object
    {
        requires mappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        if (mappingFunction == null)
        {
            this._throwNPE();
        }

        val oldValue: Object = this._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            result = oldValue;
        }
        else
        {
            val mc: int = this.modCounter;
            val newValue: Object = action CALL(mappingFunction, [key]);
            this._checkForModifications(mc);

            if (newValue != null)
            {
                this._setMapping(key, newValue);
            }

            result = newValue;
        }
    }


    fun computeIfPresent (key: Object, remappingFunction: BiFunction): Object
    {
        requires remappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        if (remappingFunction == null)
        {
            this._throwNPE();
        }

        val oldValue: Object = this._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            val mc: int = this.modCounter;
            val newValue: Object = action CALL(remappingFunction, [key, oldValue]);
            this._checkForModifications(mc);

            if (newValue == null)
            {
                this._removeMapping(key);
            }
            else
            {
                this._setMapping(key, newValue);
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

        result = this._setMapping(key, value);
    }


    fun putIfAbsent (key: Object, value: Object): Object
    {
        // side effects should be inferred from calls to other subroutines

        val oldValue: Object = this._getMappingOrDefault(key, null);
        if (oldValue == null)
        {
            this._setMapping(key, value);
        }

        result = oldValue;
    }


    fun remove (key: Object): Object
    {
        result = this._removeMapping(key);
    }


    fun remove (key: Object, value: Object): boolean
    {
        // side effects should be inferred from calls to other subroutines

        result = false;

        val idx: int = action LIST_FIND(this.keys, key, 0, this.length, +1);
        if (idx >= 0)
        {
            val oldValue: Object = action LIST_GET(this.values, idx);

            val isEqualValues: boolean = action OBJECT_EQUALS(value, oldValue);
            if (isEqualValues)
            {
                this._removeMapping(idx);

                result = true;
            }
        }
    }


    fun replace (key: Object, newValue: Object): Object
    {
        // side effects should be inferred from calls to other subroutines

        val oldValue: Object = this._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            val idx: int = action LIST_FIND(this.keys, key, 0, this.length, +1);
            action LIST_SET(this.values, idx, newValue);
        }

        result = oldValue;
    }


    fun replace (key: Object, oldValue: Object, newValue: Object): boolean
    {
        assigns this.values;

        result = false;

        val idx: int = action LIST_FIND(this.keys, key, 0, this.length, +1);
        if (idx >= 0)
        {
            val value: Object = action LIST_GET(this.values, idx);
            val providedValueEqToOld: boolean = action OBJECT_EQUALS(value, oldValue);
            if (providedValueEqToOld)
            {
                action LIST_SET(this.values, idx, newValue);

                result = true;
            }
        }
    }


    fun clear (): void
    {
        this._clearMappings();
    }


    fun clone (): Object
    {
        val cKeys: list<Object>   = action LIST_COPY(this.keys, 0, this.length);
        val cValues: list<Object> = action LIST_COPY(this.values, 0, this.length);

        result = new HashMap(
            state=this.state, keys=cKeys, values=cValues, length=this.length);
    }


    @CacheOnce
    fun values (): Collection
    {
        result = new HashMap_Values(state=Initialized);
    }


    @CacheOnce
    fun keySet (): Set
    {
        result = new HashMap_KeySet(state=Initialized);
    }


    fun merge (key: Object, value: Object, remappingFunction: BiFunction): Object
    {
        requires value != null;
        requires remappingFunction != null;
        // side effects should be inferred from calls to other subroutines

        if (value == null || remappingFunction == null)
        {
            this._throwNPE();
        }

        val oldValue: Object = this._getMappingOrDefault(key, null);
        if (oldValue != null)
        {
            val mc: int = this.modCounter;
            val newValue: Object = action CALL(remappingFunction, [oldValue, value]);
            this._checkForModifications(mc);

            if (newValue == null)
            {
                this._removeMapping(key);
            }
            else
            {
                this._setMapping(key, newValue);
            }

            result = newValue;
        }
        else
        {
            this._setMapping(key, value);

            result = value;
        }
    }


    @CacheOnce
    fun entrySet (): Set
    {
        result = new HashMap_EntrySet(state=Initialized); // parent will be implicitly set to this
    }


    // problematic methods

//    fun toString (): string
//    {
//        // result = action OBJECT_TO_STRING(this);
//        // #problem
//        action NOT_IMPLEMENTED();
//    }

//    fun hashCode (): int
//    {
//        // result = action OBJECT_HASH_CODE(this);
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

        if (consumer == null)
        {
            this._throwNPE();
        }

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

        if (mapper == null)
        {
            this._throwNPE();
        }

        // #problem
        action NOT_IMPLEMENTED();
    }

    @private
    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    fun readObject(s: ObjectInputStream): void
    {
        requires s != null;

        action NOT_IMPLEMENTED();

//        val size: int = s.readInt();

//        // #problem
//        val buff = new int[size];
//        // #problem
//        s.readFully(buff);

//        // #problem
//        action FROM_BYTES(this, bytes);
    }
}




@From("HashMap")
@packageprivate
@extends("java.util.AbstractCollection")
automaton HashMap_Values: int
{
    initstate Initialized;

    shift Initialized -> this by [
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
        result = this.parent.length;
    }


    fun contains(value: Object): boolean
    {
        if (this.parent.length == 0)
        {
            result = false;
        }
        else
        {
            val idx = action LIST_FIND(this.parent.values, value, 0, this.parent.length, +1);
            result = idx >= 0;
        }
    }


    fun iterator(): Iterator
    {
        result = new HashMap_ValueIterator(
            state=Initialized, parent=this.parent, expectedModCount=this.parent.modCounter);
    }


// #todo
//    fun spliterator(): Spliterator
//    {
//        result = new HashMap_ValueSpliterator(state=Initialized, parent=this.parent);
//    }


    fun clear(): void
    {
        assigns this.parent;

        this.parent._clearMappings();
    }


    fun forEach(consumer: Consumer): void
    {
        // #problem
        action NOT_IMPLEMENTED();
    }
}




@From("HashMap")
@packageprivate
@extends("java.util.AbstractSet")
automaton HashMap_KeySet: int
{
    initstate Initialized;

    shift Initialized -> this by [
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
        result = this.parent.length;
    }


    fun clear (): void
    {
        assigns this.parent;

        this.parent._clearMappings();
    }


    fun iterator (): Iterator
    {
        result = new HashMap_KeyIterator(
            state=Initialized, parent=this.parent, expectedModCount=this.parent.modCounter);
    }


// #todo
//    fun spliterator (): Spliterator
//    {
//        result = new HashMap_KeySpliterator(state=Initialized, parent=this.parent);
//    }


    fun contains (key: Object): boolean
    {
        if (this.parent.length == 0)
        {
            result = false;
        }
        else
        {
            val idx = action LIST_FIND(this.parent.keys, key, 0, this.parent.length, +1);
            result = idx >= 0;
        }
    }


    fun remove (key: Object): boolean
    {
        assigns this.parent;

        val oldValue = this.parent._removeMapping(key);
        result = oldValue != null;
    }
}




@From("HashMap")
@packageprivate
@implements(["java.util.Iterator"])
automaton HashMap_KeyIterator: int
(
    var index: int = 0;
    var expectedModCount: int;
    var nextWasCalled: boolean = false;
)
{
    initstate Initialized;

    shift Initialized -> this by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];


    // methods

    fun hasNext (): boolean
    {
        result = index < this.parent.length;
    }


    fun next (): Object
    {
        this.parent._checkForModifications(expectedModCount);

        val atValidPosition = index < this.parent.length;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        result = action LIST_GET(this.parent.keys, index);

        index += 1;
        nextWasCalled = true;
    }


    fun remove (): void
    {
        val atValidPosition = index < this.parent.length;
        if (!atValidPosition || !nextWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }
        nextWasCalled = false;

        this.parent._checkForModifications(expectedModCount);

        this.parent._removeMapping(index);

        expectedModCount = this.parent.modCounter;
    }
}




@From("HashMap")
@packageprivate
@implements(["java.util.Iterator"])
automaton HashMap_ValueIterator: int
(
    var index: int = 0;
    var expectedModCount: int;
    var nextWasCalled: boolean = false;
)
{
    initstate Initialized;

    shift Initialized -> this by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];


    // methods

    fun hasNext (): boolean
    {
        result = index < this.parent.length;
    }


    fun next (): Object
    {
        this.parent._checkForModifications(expectedModCount);

        val atValidPosition = index < this.parent.length;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        result = action LIST_GET(this.parent.values, index);

        index += 1;
        nextWasCalled = true;
    }


    fun remove (): void
    {
        val atValidPosition = index < this.parent.length;
        if (!atValidPosition || !nextWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }
        nextWasCalled = false;

        this.parent._checkForModifications(expectedModCount);

        this.parent._removeMapping(index);

        expectedModCount = this.parent.modCounter;
    }
}




@From("HashMap")
@packageprivate
@implements(["java.util.Map.Entry"])
automaton HashMap_Entry: int
(
    var index: int;
)
{
    initstate Initialized;

    shift Initialized -> this by [
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

    @CacheOnce
    fun getKey (): Object
    {
        // we do not have references to arbitrary types, so 'action' it is
        result = action LIST_GET(this.parent.keys, index);
    }


    fun getValue (): Object
    {
        result = action LIST_GET(this.parent.values, index);
    }


    fun setValue (newValue: Object): Object
    {
        result = action LIST_GET(this.parent.values, index);

        action LIST_SET(this.parent.values, index, newValue);
    }


    fun equals (other: Object): Object
    {
        if (other == this)
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
        val key   = action LIST_GET(this.parent.keys, index);
        val value = action LIST_GET(this.parent.values, index);

        val sKey   = action OBJECT_TO_STRING(key);
        val sValue = action OBJECT_TO_STRING(value);

        result = sKey + "=" + sValue;
    }


    fun hashCode (): int
    {
        val key   = action LIST_GET(this.parent.keys, index);
        val value = action LIST_GET(this.parent.values, index);

        val hKey   = action OBJECT_HASH_CODE(key);
        val hValue = action OBJECT_HASH_CODE(value);

        result = hKey ^ hValue;
    }

}




@From("HashMap")
@packageprivate
@extends("java.util.AbstractSet")
automaton HashMap_EntrySet: int
{
    initstate Initialized;

    shift Initialized -> this by [
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
        result = this.parent.length;
    }


    fun clear (): void
    {
        assigns this.parent;

        this.parent._clearMappings();
    }


    fun iterator (): Iterator
    {
        result = new HashMap_EntryIterator(
            state=Initialized, parent=this.parent, expectedModCount=this.parent.modCounter);
    }


    fun spliterator (): Spliterator
    {
        result = new HashMap_EntrySpliterator(state=Initialized, parent=this.parent);
    }


    fun contains (e: Object): boolean
    {
        if (this.parent.length == 0)
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
        assigns this.parent;

        // #problem
        // val key = action CALL_INTERFACE(e, "getKey():java.lang.Object", []);

        val oldValue = this.parent._removeMapping(key);
        result = oldValue != null;
    }
}




@From("HashMap")
@packageprivate
@implements(["java.util.Iterator"])
automaton HashMap_EntryIterator: int
(
    var index: int = 0;
    var expectedModCount: int;
    var nextWasCalled: boolean = false;
)
{
    initstate Initialized;

    shift Initialized -> this by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];


    // methods

    fun hasNext (): boolean
    {
        result = index < this.parent.length;
    }


    fun next (): Object
    {
        this.parent._checkForModifications(expectedModCount);

        val atValidPosition = index < this.parent.length;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        result = new HashMap_Entry(index=this.index);

        index += 1;
        nextWasCalled = true;
    }


    fun remove (): void
    {
        val atValidPosition = index < this.parent.length;
        if (!atValidPosition || !nextWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }
        nextWasCalled = false;

        this.parent._checkForModifications(expectedModCount);

        this.parent._removeMapping(index);

        expectedModCount = this.parent.modCounter;
    }
}





// TODO
// HashMap_ValueSpliterator
// HashMap_KeySpliterator
// HashMap_EntrySpliterator
