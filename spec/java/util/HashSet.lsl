libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/util/_interfaces.lsl";

import "list-actions.lsl";


// local semantic types

@TypeMapping(typeVariable=true)
typealias E = Object;


// automata

@Parameterized("E")
@extends("java.util.AbstractSet<E>")
@implements(["java.util.Set<E>", "java.lang.Cloneable", "java.io.Serializable"])
@public automaton HashSet: int
(
    var hashMap: map<E, Object> = null;
    @transient var length: int = 0;
    @transient var modCounter: int = 0;

    @static @final var serialVersionUID: long = -5024744406713321676;
    @static @final var mockedValue: Object = Object;
)
{
    // states and shifts

    initstate Initialized;
    state Initialized;

    shift Allocated -> Initialized by [
            // constructors
            HashSet (HashSet),
            HashSet (HashSet, Collection),
            HashSet(HashSet, int, float),
            HashSet(HashSet, int, float, boolean)
    ];

    shift Initialized -> this by [
            // read operations
            contains,
            isEmpty,
            size,

            clone,

            iterator,
            spliterator,

            // write operations
            add,
            clear,
            remove
    ]


    // constructors

    constructor HashSet (@target @Parameterized(["E"]) self: HashSet)
    {
        assigns hashMap;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length == 0;
        ensures this.modCounter == 0;

        hashMap = action MAP_NEW();

        this.length = 0;
        this.modCounter = 0;
    }


    constructor HashSet (@target @Parameterized(["E"]) self: HashSet, @Parameterized("? extends E") c: Collection)
    {
        requires c != null;
        assigns hashMap;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length >= 0;
        ensures this.modCounter == 0;

        val size: int = c.size();

        hashMap = action MAP_NEW();

        CALL_METHOD(hashMap, "addAll", [c])

        this.length = size;
        this.modCounter = 0;
    }


    constructor HashSet (@target @Parameterized(["E"]) self: HashSet, initialCapacity: int)
    {
        requires initialCapacity >= 0;
        assigns hashMap;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length == 0;
        ensures this.modCounter == 0;

        if (initialCapacity < 0)
        {
            val initCapStr: String = action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal initial capacity: " + initCapStr]);
        }

        hashMap = action MAP_NEW();

        this.length = 0;
        this.modCounter = 0;
    }


    constructor HashSet (@target @Parameterized(["E"]) self: HashSet, initialCapacity: int, loadFactor: float)
    {
        requires initialCapacity >= 0;
        requires loadFactor > 0;
        requires !loadFactor.isNaN;  // #problem
        assigns hashMap;
        assigns this.length;
        assigns this.modCounter;
        ensures this.length == 0;
        ensures this.modCounter == 0;

        if (initialCapacity < 0)
        {
            val initCapStr: String = action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal initial capacity: " + initCapStr]);
        }

        if (loadFactor <= 0 || loadFactor.isNaN) // #problem
        {
            val loadFactorStr: String = action OBJECT_TO_STRING(loadFactor);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal load factor: " + loadFactorStr]);
        }

        hashMap = action MAP_NEW();

        this.length = 0;
        this.modCounter = 0;
    }


    constructor HashSet (@target @Parameterized(["E"]) self: HashSet, initialCapacity: int, loadFactor: float, dummy: boolean)
    {
        // Problem; We don't have LinkedHashMap automaton at this moment !
        action TODO();
    }


    // utilities

    proc _updateModifications(): void
    {
        assigns this.modCounter;
        ensures this.modCounter' > this.modCounter;

        this.modCounter += 1;
    }

    proc _clearMappings (): void
    {
        assigns this.hashMap;
        assigns this.length;
        ensures this.length == 0;

        this.length = 0;
        this.hashMap = action MAP_NEW();

        this._updateModifications();
    }

    // static methods

    // methods

    fun add (obj: E): boolean
    {
        assigns this.values;
        ensures this.length' >= this.length;

        val hasKey: boolean = action MAP_HAS_KEY(this.hashMap, obj);

        if (hasKey)
        {
            result = false;
        }
        else
        {
            this.length = this.length + 1;

            action MAP_SET(this.hashMap, obj, mockedValue);

            result = true;
        }

        this._updateModifications();
    }


    fun clear (): void
    {
        this._clearMappings();
    }


    fun clone (): Object
    {
        val clonedHashMap: map<Object> = action MAP_NEW();

        action MAP_UNITE_WITH(clonedHashMap, hashMap);
        result = clonedHashMap;
    }


    fun contains (obj: Object): boolean
    {
        if (this.length == 0)
        {
            result = false;
        }
        else
        {
            result = action MAP_HAS_KEY(this.hashMap, obj);
        }
    }


    fun isEmpty (): boolean
    {
        result = this.length == 0;
    }


    @ParameterizedResult("E")
    fun iterator (): Iterator
    {
        // Problem - 1) how import KeyIterator automaton ? 2) We must change realization of this, because it uses not "map" now.
        result = new KeyIterator(state=Initialized,
        this.hasMap,
        expectedModCount=this.modCount)
    }


    fun remove (obj: Object): boolean
    {
        assigns this.hashMap;
        assigns this.length;
        ensures this.length' <= this.length;

        val hasKey: boolean = action MAP_HAS_KEY(this.hashMap, obj);
        if (hasKey)
        {
            action MAP_REMOVE(this.hashMap, obj);
            this.length -= 1;
            this._updateModifications();
            result = true;
        }
        else
        {
            result = false;
        }
    }


    fun size (): int
    {
        result = this.length;
    }


    @ParameterizedResult("E")
    fun spliterator (): Spliterator
    {
        // Problem - 1) how import KeySpliterator automaton ? 2) We must change realization of this, because it uses not "map" now.
        result = new KeySpliterator(state=Initialized,
            this.hasMap,
            origin = 0,
            fence = -1,
            est = 0
            expectedModCount = 0)
    }

}