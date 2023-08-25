///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "-";

// imports

import java.common;
import java/lang/_interfaces;
import java/io/_interfaces;
import java/util/_interfaces;
import java/util/function/_interfaces;
import java/util/HashMap;


// local semantic types
@GenerateMe
@extends("java.util.AbstractSet")
@implements("java.util.Set")
@implements("java.lang.Cloneable")
@implements("java.io.Serializable")
@public type HashSet
    is java.util.HashSet
    for Set
{
    //@static @final var serialVersionUID: long = -5024744406713321676;
}


@GenerateMe
// Problem: inner class extends
@extends("java.util.HashMap$HashMapSpliterator")
@implements("java.util.Spliterator")
@public @static @final type HashSet_KeySpliterator
    is java.util.HashSet_KeySpliterator
    for Spliterator
{
}


@GenerateMe
@implements("java.util.Iterator")
@public @final type HashSet_KeyIterator
    is java.util.HashSet_KeyIterator
    for Iterator
{
}


// === CONSTANTS ===

val HASHSET_KEYITERATOR_VALUE: Object = 0;


// automata

automaton HashSetAutomaton
(
    var storage: map<Object, Object> = null,
    @transient var length: int = 0,
    @transient var modCount: int = 0
)
: HashSet
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashSet(HashSet),
        HashSet(HashSet, Collection),
        HashSet(HashSet, int, float),
        HashSet(HashSet, int, float, boolean)
    ];

    shift Initialized -> self by [
        // read operations
        contains,
        containsAll,
        isEmpty,
        size,

        clone,
        equals,
        hashCode,

        iterator,
        spliterator,
        toArray(HashSet),
        toArray(HashSet, array<Object>),

        // write operations
        add,
        addAll,
        clear,
        remove,
        removeAll,
        retainAll,
        removeIf,
        forEach,
    ];


    // constructors

    constructor *.HashSet (@target self: HashSet)
    {
        assigns this.storage;
        assigns this.length;
        assigns this.modCount;
        ensures this.length == 0;
        ensures this.modCount == 0;

        this.storage = action MAP_NEW();

        this.length = 0;
        this.modCount = 0;
    }


    constructor *.HashSet (@target self: HashSet, c: Collection)
    {
        requires c != null;
        assigns this.storage;
        assigns this.length;
        assigns this.modCount;
        ensures this.length >= 0;
        ensures this.modCount >= 0;


        this.storage = action MAP_NEW();

        _addAllElements(c);
    }


    constructor *.HashSet (@target self: HashSet, initialCapacity: int)
    {
        requires initialCapacity >= 0;
        assigns this.storage;
        assigns this.length;
        assigns this.modCount;
        ensures this.length == 0;
        ensures this.modCount == 0;

        if (initialCapacity < 0)
        {
            val initCapStr: String = action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal initial capacity: " + initCapStr]);
        }

        this.storage = action MAP_NEW();

        this.length = 0;
        this.modCount = 0;
    }


    constructor *.HashSet (@target self: HashSet, initialCapacity: int, loadFactor: float)
    {
        requires initialCapacity >= 0;
        requires loadFactor > 0;
        //requires !loadFactor.isNaN;  // #problem
        assigns this.storage;
        assigns this.length;
        assigns this.modCount;
        ensures this.length == 0;
        ensures this.modCount == 0;

        if (initialCapacity < 0)
        {
            val initCapStr: String = action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal initial capacity: " + initCapStr]);
        }

        //if (loadFactor <= 0 || loadFactor.isNaN) // #problem
        if (loadFactor <= 0)
        {
            val loadFactorStr: String = action OBJECT_TO_STRING(loadFactor);
            action THROW_NEW(
                "java.lang.IllegalArgumentException",
                ["Illegal load factor: " + loadFactorStr]);
        }

        this.storage = action MAP_NEW();

        this.length = 0;
        this.modCount = 0;
    }


    constructor *.HashSet (@target self: HashSet, initialCapacity: int, loadFactor: float, dummy: boolean)
    {
        // Problem; We don't have LinkedHashMap automaton at this moment !
        action TODO();
    }


    // utilities

    proc _updateModifications(): void
    {
        assigns this.modCount;
        ensures this.modCount' > this.modCount;

        this.modCount += 1;
    }

    proc _clearMappings (): void
    {
        assigns this.storage;
        assigns this.length;
        ensures this.length == 0;

        this.length = 0;
        this.storage = action MAP_NEW();

        this._updateModifications();
    }


    proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    proc _addAllElements (c: Collection): boolean
    {
        val lengthBeforeAdd: int = this.length;
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _addAllElements_loop(iter)
        );

        if (lengthBeforeAdd < this.length)
        {
            this.modCount += 1;
            result = true;
        }
        else
            result = false;
    }


    @Phantom proc _addAllElements_loop(iter: Iterator): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);
        val hasKey: boolean = action MAP_HAS_KEY(this.storage, key);

        if (!hasKey)
        {
            action MAP_SET(this.storage, key, HASHSET_KEYITERATOR_VALUE);
            this.length += 1;
        }
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // methods

    fun *.add (@target self: HashSet, obj: Object): boolean
    {
        assigns this.values;
        ensures this.length' >= this.length;

        val hasKey: boolean = action MAP_HAS_KEY(this.storage, obj);

        if (hasKey)
            result = false;
        else
        {
            this.length = this.length + 1;

            action MAP_SET(this.storage, obj, HASHSET_KEYITERATOR_VALUE);

            result = true;
        }

        this._updateModifications();
    }


    fun *.clear (@target self: HashSet): void
    {
        this._clearMappings();
    }


    fun *.clone (@target self: HashSet): Object
    {
        val clonedStorage: map<Object, Object> = action MAP_NEW();

        action MAP_UNITE_WITH(clonedStorage, this.storage);
        result = clonedStorage;
    }


    fun *.contains (@target self: HashSet, obj: Object): boolean
    {
        if (this.length == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storage, obj);
    }


    fun *.isEmpty (@target self: HashSet): boolean
    {
        result = this.length == 0;
    }


    fun *.iterator (@target self: HashSet): Iterator
    {
        val visitedKeysMap: map<Object, Object> = action MAP_NEW();
        result = new HashSet_KeyIteratorAutomaton(state = Initialized,
            expectedModCount = this.modCount,
            visitedKeys = visitedKeysMap,
            // This is right ?
            parent = self
        );
    }


    fun *.remove (@target self: HashSet, obj: Object): boolean
    {
        assigns this.storage;
        assigns this.length;
        ensures this.length' <= this.length;

        val hasKey: boolean = action MAP_HAS_KEY(this.storage, obj);
        if (hasKey)
        {
            action MAP_REMOVE(this.storage, obj);
            this.length -= 1;
            this._updateModifications();
            result = true;
        }
        else
            result = false;
    }


    fun *.size (@target self: HashSet): int
    {
        result = this.length;
    }


    fun *.spliterator (@target self: HashSet): Spliterator
    {
        val keysStorageList: list<Object> = action LIST_NEW();
        val visitedKeys: map<Object, Object> = action MAP_NEW();
        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            fromMapToList_loop(i, keysStorageList, visitedKeys)
        );


        result = new HashSet_KeySpliteratorAutomaton(state=Initialized,
            keysStorage = keysStorageList,
            index = 0,
            fence = -1,
            est = 0,
            expectedModCount = this.modCount,
            parent = self);
    }


    @Phantom proc fromMapToList_loop (i: int, keysStorageList: list<Object>, visitedKeys: map<Object, Object>): void
    {
        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);
        action ASSUME(isKeyExist);

        val isKeyWasVisited: boolean = action MAP_HAS_KEY(visitedKeys, key);
        action ASSUME(!isKeyWasVisited);

        action LIST_INSERT_AT(keysStorageList, i, key);

        i += 1;
        action MAP_SET(visitedKeys, key, HASHSET_KEYITERATOR_VALUE);
    }


    @throws(["java.io.IOException"])
    @private fun *.writeObject (@target self: HashSet, s: ObjectOutputStream): void
    {
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun *.readObject (@target self: HashSet, s: ObjectInputStream): void
    {
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    fun *.equals (@target self: HashSet, other: Object): boolean
    {
        if (other == self)
            result = true;
        else
        {
            // Problem ! We don't have such action "OBJECT_SAME_TYPE";
            //val isSameType: boolean = action OBJECT_SAME_TYPE(self, other);
            val isSameType: boolean = true;
            if (isSameType)
            {
                val expectedModCount: int = this.modCount;
                val otherExpectedModCount: int = HashSetAutomaton(other).modCount;

                val otherStorage: map<Object, Object> = HashSetAutomaton(other).storage;
                val otherLength: int = HashSetAutomaton(other).length;

                if (this.length == otherLength)
                    result = action OBJECT_EQUALS(this.storage, otherStorage);
                else
                    result = false;

                action DEBUG_DO("other._checkForComodification(otherExpectedModCount)"); // #problem
                _checkForComodification(expectedModCount);
            }
            else
                result = false;
        }
    }


    fun *.hashCode (@target self: HashSet): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.removeAll (@target self: HashSet, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        val expectedModCount: int = this.modCount;

        val otherSize: int = action CALL_METHOD(c, "size", []);
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);
        var i: int = 0;
        val lengthBeforeRemoving: int = this.length;

        if (this.length > otherSize)
            action LOOP_WHILE(
                action CALL_METHOD(iter, "hasNext", []),
                _removeAllElements_loop_direct(iter)
            );
        else
        {
            val visitedKeys: map<Object, Object> = action MAP_NEW();
            action LOOP_WHILE(
                i < this.length,
                _removeAllElements_loop_indirect(i, c, visitedKeys)
            );
        }

        _checkForComodification(expectedModCount);
        this.modCount += 1;
        // If length changed, it means that at least one element was deleted
        result = lengthBeforeRemoving != this.length;
    }


    @Phantom proc _removeAllElements_loop_direct (iter: Iterator): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);

        if (isKeyExist)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }
    }


    @Phantom proc _removeAllElements_loop_indirect (i: int, c: Collection, visitedKeys: map<Object, Object>): void
    {
        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);
        action ASSUME(isKeyExist);

        val isKeyWasVisited: boolean = action MAP_HAS_KEY(visitedKeys, key);
        action ASSUME(!isKeyWasVisited);

        val isCollectionContainsKey: boolean = action CALL_METHOD(c, "contains", [key]);

        if (isCollectionContainsKey)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }

        action MAP_SET(visitedKeys, key, HASHSET_KEYITERATOR_VALUE);
        i += 1;
    }


    fun *.toArray(@target self: HashSet): array<Object>
    {
        val expectedModCount: int = this.modCount;
        val size: int = this.length;
        result = action SYMBOLIC_ARRAY("java.lang.Object", size);

        val visitedKeys: map<Object, Object> = action MAP_NEW();
        var i: int = 0;
        action LOOP_FOR(
            i, 0, size, +1,
            toArray_loop(i, visitedKeys) // result assignment is implicit
        );
        _checkForComodification(expectedModCount);
    }


    @Phantom proc toArray_loop(i: int, visitedKeys: map<Object, Object>): array<Object>
    {
        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);
        action ASSUME(isKeyExist);

        val isKeyWasVisited: boolean = action MAP_HAS_KEY(visitedKeys, key);
        action ASSUME(!isKeyWasVisited);

        result[i] = key;

        action MAP_SET(visitedKeys, key, HASHSET_KEYITERATOR_VALUE);
    }


    fun *.toArray (@target self: HashSet, a: array<Object>): array<Object>
    {
        val expectedModCount: int = this.modCount;
        val aLen: int = action ARRAY_SIZE(a);
        val size: int = this.length;
        var i: int = 0;
        val visitedKeys: map<Object, Object> = action MAP_NEW();

        if (aLen < size)
        {
            result = action SYMBOLIC_ARRAY("java.lang.Object", size);
            action LOOP_FOR(
                i, 0, size, +1,
                toArray_loop(i, visitedKeys) // result assignment is implicit
            );

        }
        else
        {
            result = a;
            action LOOP_FOR(
                i, 0, size, +1,
                toArray_loop(i, visitedKeys) // result assignment is implicit
            );

        }
        _checkForComodification(expectedModCount);
    }


    fun *.containsAll (@target self: HashSet, c: Collection): boolean
    {
        val otherSize: int = action CALL_METHOD(c, "size", []);
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);
        var isContainsAll: boolean = true;

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _containsAllElements_loop(iter, isContainsAll)
        );
        // This is right ? Can we understand that boolean value was changed in cycle ?
        result = isContainsAll;
    }


    @Phantom proc _containsAllElements_loop(iter: Iterator, isContainsAll: boolean): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);

        if (!isKeyExist)
        {
            isContainsAll = false;
        }
    }


    fun *.addAll (@target self: HashSet, c: Collection): boolean
    {
        result = _addAllElements(c);
    }


    fun *.retainAll(@target self: HashSet, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        val lengthBeforeAdd: int = this.length;
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _retainAllElements_loop(iter)
        );


        if (lengthBeforeAdd != this.length)
        {
            this.modCount += 1;
            result = true;
        }
        else
            result = false;
    }


    @Phantom proc _retainAllElements_loop(iter: Iterator): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);
        val hasKey: boolean = action MAP_HAS_KEY(this.storage, key);

        if (!hasKey)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }
    }


    fun *.removeIf (@target self: HashSet, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        val lengthBeforeAdd: int = this.length;
        var i: int = 0;
        val visitedKeys: map<Object, Object> = action MAP_NEW();


        action LOOP_WHILE(
            i < lengthBeforeAdd,
            _removeIf_loop(i, visitedKeys, filter)
        );

        if (lengthBeforeAdd != this.length)
        {
            this.modCount += 1;
            result = true;
        }
        else
            result = false;
    }


    @Phantom proc _removeIf_loop(i: int, visitedKeys: map<Object, Object>, filter: Predicate): void
    {
        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);
        action ASSUME(isKeyExist);

        val isKeyWasVisited: boolean = action MAP_HAS_KEY(visitedKeys, key);
        action ASSUME(!isKeyWasVisited);

        var isDelete: boolean = action CALL_METHOD(filter, "test", [key]);

        if(isDelete)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }

        i += 1;
        action MAP_SET(visitedKeys, key, HASHSET_KEYITERATOR_VALUE);
    }


    fun *.forEach (@target self: HashSet, userAction: Consumer): void
    {
        if (userAction == null)
            _throwNPE();

        var i: int = 0;
        val visitedKeys: map<Object, Object> = action MAP_NEW();


        action LOOP_WHILE(
            i < this.length,
            _forEach_loop(i, visitedKeys, userAction)
        );
    }


    @Phantom proc _forEach_loop(i: int, visitedKeys: map<Object, Object>, userAction: Consumer): void
    {
        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);
        action ASSUME(isKeyExist);

        val isKeyWasVisited: boolean = action MAP_HAS_KEY(visitedKeys, key);
        action ASSUME(!isKeyWasVisited);

        action CALL_METHOD(userAction, "accept", [key]);

        i += 1;
        action MAP_SET(visitedKeys, key, HASHSET_KEYITERATOR_VALUE);
    }
}


automaton HashSet_KeyIteratorAutomaton
(
    var expectedModCount: int,
    var visitedKeys: map<Object, Object>,
    var parent: HashSet
)
: HashSet_KeyIterator
{

    var index: int = 0;
    var currentKey: Object = 0;
    var nextWasCalled: boolean = false;

    // states and shifts

    initstate Allocated;
    state Initialized;

     shift Allocated -> Initialized by [
            // constructors
            // Problem: here mustn't be "HashMap"; What must be here ? What we must to do with constructor ?
            HashSet_KeyIterator,
     ];

    shift Initialized -> self by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];

    // constructors

    @private constructor *.HashSet_KeyIterator (@target self: HashSet_KeyIterator, source: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // utilities

    proc _checkForComodification (): void
    {
        val modCount: int = HashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }

    // methods

    fun *.hasNext (@target self: HashSet_KeyIterator): boolean
    {
        action ASSUME(this.parent != null);
        val length: int = HashSetAutomaton(this.parent).length;
        result = this.index < length;
    }


    @final fun *.next (@target self: HashSet_KeyIterator): Object
    {
        action ASSUME(this.parent != null);
        _checkForComodification();

        val length: int = HashSetAutomaton(this.parent).length;
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition)
            action THROW_NEW("java.util.NoSuchElementException", []);

        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        action ASSUME(key != this.currentKey);
        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        val sourceStorageHasKey: bool = action MAP_HAS_KEY(parentStorage, key);
        action ASSUME(sourceStorageHasKey);
        val destStorageHasKey: bool = action MAP_HAS_KEY(this.visitedKeys, key);
        action ASSUME(!destStorageHasKey);

        this.currentKey = key;
        result = key;

        action MAP_SET(this.visitedKeys, this.currentKey, HASHSET_KEYITERATOR_VALUE);
        this.index += 1;
        this.nextWasCalled = true;
    }


    fun *.remove (@target self: HashSet_KeyIterator): void
    {
        action ASSUME(this.parent != null);
        val length: int = HashSetAutomaton(this.parent).length;
        val atValidPosition: boolean = this.index < length;
        if (!atValidPosition || !this.nextWasCalled)
            action THROW_NEW("java.lang.IllegalStateException", []);

        this.nextWasCalled = false;

        _checkForComodification();

        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        action MAP_REMOVE(parentStorage, this.currentKey);

        this.expectedModCount = HashSetAutomaton(this.parent).modCount;
    }


    fun *.forEachRemaining (@target self: HashSet_KeyIterator, userAction: Consumer): void
    {
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        val length: int = HashSetAutomaton(this.parent).length;
        var i: int = this.index;

        action LOOP_WHILE(
            i < length,
            forEachRemaining_loop(userAction, i)
        );

        this.index = i;
        this.nextWasCalled = true;
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int): void
    {
        _checkForComodification();

        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        action ASSUME(key != this.currentKey);
        val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
        val sourceStorageHasKey: bool = action MAP_HAS_KEY(parentStorage, key);
        action ASSUME(sourceStorageHasKey);
        val destStorageHasKey: bool = action MAP_HAS_KEY(this.visitedKeys, key);
        action ASSUME(!destStorageHasKey);

        this.currentKey = key;
        action MAP_SET(this.visitedKeys, this.currentKey, HASHSET_KEYITERATOR_VALUE);

        action CALL(userAction, [key]);
        i += 1;
    }

}


automaton HashSet_KeySpliteratorAutomaton
(
    var keysStorage: list<Object>,
    var index: int,
    var fence: int,
    var est: int,
    var expectedModCount: int,
    var parent: HashSet
)
: HashSet_KeySpliterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashSet_KeySpliterator
    ];

    shift Initialized -> self by [
        // read operations
        characteristics,
        trySplit,
        estimateSize,

        // write operations
        forEachRemaining,
        tryAdvance,
    ];


    // constructors

    constructor *.HashSet_KeySpliterator (@target self: HashSet_KeySpliterator, source: HashMap, origin: int, fence: int, est: int, expectedModCount: int)
    {
        this.index = origin;
        this.fence = fence;
        this.est = est;
        this.expectedModCount = expectedModCount;
    }


    // utilities

    proc _getFence(): int
    {
        action ASSUME(this.parent != null);

        var hi: int = this.fence;
        if (hi < 0)
        {
            val parentStorage: map<Object, Object> = HashSetAutomaton(this.parent).storage;
            this.est = HashSetAutomaton(this.parent).length;
            this.expectedModCount = HashSetAutomaton(this.parent).modCount;
            this.fence = this.est;
            // That's right ?
            // Original code: "hi = fence = (tab == null) ? 0 : tab.length;"
            hi = this.fence;
        }
        result = hi;
    }


    @AutoInline
    proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _checkForComodification (): void
    {
        val modCount: int = HashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // methods

    fun *.estimateSize (@target self: HashSet_KeySpliterator): long
    {
        _getFence();
        result = this.est as long;
    }


    fun *.characteristics (@target self: HashSet_KeySpliterator): int
    {
        action ASSUME(this.parent != null);

        var mask: int = 0;
        val length: int = HashSetAutomaton(this.parent).length;
        if (this.fence < 0 || this.est == length)
            mask = 64;

        result = mask | 1;
    }


    fun *.forEachRemaining (@target self: HashSet_KeySpliterator, userAction: Consumer): void
    {
        action ASSUME(this.parent != null);

        if(userAction == null)
            _throwNPE();

        var hi: int = this.fence;
        var mc: int = this.expectedModCount;
        var i: int = this.index;
        val length: int = HashSetAutomaton(this.parent).length;

        if(hi < 0)
        {
            this.expectedModCount = HashSetAutomaton(this.parent).modCount;
            mc = this.expectedModCount;
            // problem
            // How correctly write such string "hi = fence = (tab == null) ? 0 : tab.length;"
            // As I see this condition "tab == null" we mustn't check, because we don't have "map.table" field;
            this.fence = length;
            hi = this.fence;
        }

        // Original condition: "if (tab != null && tab.length >= hi && (i = index) >= 0 && (i < (index = hi) || current != null))"
        // This is correct this condition translation ?
        this.index = hi;
        if (length > 0 && length >= hi && i >= 0 && i < this.index)
        {
            // I must think about this:
            action LOOP_WHILE(i < hi, forEachRemaining_loop(userAction, i));

            val modCount: int = HashSetAutomaton(this.parent).modCount;
            if (modCount != mc)
                action THROW_NEW("java.util.ConcurrentModificationException", []);
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int): boolean
    {
        val key: Object = action LIST_GET(this.keysStorage, this.index);
        action CALL(userAction, [key]);
        i += 1;
    }


    fun *.tryAdvance (@target self: HashSet_KeySpliterator, userAction: Consumer): boolean
    {
        action ASSUME(this.parent != null);

        if(userAction == null)
            _throwNPE();

        var hi: int = _getFence();
        val length: int = HashSetAutomaton(this.parent).length;

        // this is correct condition ? It is enough ?
        if(length >= hi && this.index >= 0)
        {
            val key: Object = action LIST_GET(this.keysStorage, this.index);
            action CALL(userAction, [key]);

            this.index += 1;
            _checkForComodification();
            result = true;
        }

        result = false;
    }


    fun *.trySplit (@target self: HashSet_KeySpliterator): HashSet_KeySpliterator
    {
        action ASSUME(this.parent != null);

        val hi: int = _getFence();
        val lo: int = this.index;

        var mid: int = (hi + lo) >>> 1;

        if (lo >= mid)
            result = null;
        else
        {
            this.est = this.est >>> 1;

            this.index = mid;

            result = new HashSet_KeySpliteratorAutomaton(state = Initialized,
                keysStorage = this.keysStorage,
                index = lo,
                fence = mid,
                est = this.est,
                expectedModCount = this.expectedModCount,
                parent = this.parent
            );
        }
    }

}