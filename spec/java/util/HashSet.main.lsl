///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashSet.java";

// imports

import java/util/HashSet;


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
        stream,
        parallelStream,
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


    // utilities

    @KeepVisible proc _checkForComodification (expectedModCount: int): void
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

        if (lengthBeforeAdd != this.length)
        {
            this.modCount += 1;
            result = true;
        }
        else
        {
            result = false;
        }
    }


    @Phantom proc _addAllElements_loop(iter: Iterator): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);
        val hasKey: boolean = action MAP_HAS_KEY(this.storage, key);

        if (!hasKey)
        {
            action MAP_SET(this.storage, key, HASHSET_VALUE);
            this.length += 1;
        }
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _generateKey (visitedKeys: map<Object, Object>): Object
    {
        val key: Object = action SYMBOLIC("java.lang.Object");
        action ASSUME(key != null);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);
        action ASSUME(isKeyExist);

        val isKeyWasVisited: boolean = action MAP_HAS_KEY(visitedKeys, key);
        action ASSUME(!isKeyWasVisited);
        result = key;
    }


    // constructors

    constructor *.HashSet (@target self: HashSet)
    {
        this.storage = action MAP_NEW();

        this.length = 0;
        this.modCount = 0;
    }


    constructor *.HashSet (@target self: HashSet, c: Collection)
    {
        this.storage = action MAP_NEW();
        _addAllElements(c);
    }


    constructor *.HashSet (@target self: HashSet, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            //val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }

        this.storage = action MAP_NEW();

        this.length = 0;
        this.modCount = 0;
    }


    constructor *.HashSet (@target self: HashSet, initialCapacity: int, loadFactor: float)
    {
        if (initialCapacity < 0)
        {
            // val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }

        //if (loadFactor <= 0 || loadFactor.isNaN) // #problem
        if (loadFactor <= 0)
        {
            // val loadFactorStr: String = "Illegal load factor: " + action OBJECT_TO_STRING(loadFactor);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
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


    // methods

    fun *.add (@target self: HashSet, obj: Object): boolean
    {
        val hasKey: boolean = action MAP_HAS_KEY(this.storage, obj);

        if (hasKey)
        {
            result = false;
        }
        else
        {
            this.length += 1;

            action MAP_SET(this.storage, obj, HASHSET_VALUE);

            result = true;
        }

        this.modCount += 1;
    }


    fun *.clear (@target self: HashSet): void
    {
        this.length = 0;
        this.storage = action MAP_NEW();

        this.modCount += 1;
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
            parent = self
        );
    }


    fun *.remove (@target self: HashSet, obj: Object): boolean
    {
        val hasKey: boolean = action MAP_HAS_KEY(this.storage, obj);
        if (hasKey)
        {
            action MAP_REMOVE(this.storage, obj);
            this.length -= 1;
            this.modCount += 1;
            result = true;
        }
        else
        {
            result = false;
        }
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
            parent = self
        );
    }


    @Phantom proc fromMapToList_loop (i: int, keysStorageList: list<Object>, visitedKeys: map<Object, Object>): void
    {
        val key: Object = _generateKey(visitedKeys);

        action LIST_INSERT_AT(keysStorageList, i, key);
        action MAP_SET(visitedKeys, key, HASHSET_VALUE);

        i += 1;
    }


    fun *.equals (@target self: HashSet, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            val isSameType: boolean = action OBJECT_SAME_TYPE(self, other);
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

                HashSetAutomaton(other)._checkForComodification(otherExpectedModCount);
                _checkForComodification(expectedModCount);
            }
            else
            {
                result = false;
            }
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
        val lengthBeforeRemoving: int = this.length;
        var i: int = 0;

        if (this.length > otherSize)
        {
            action LOOP_WHILE(
                action CALL_METHOD(iter, "hasNext", []),
                removeAllElements_loop_direct(iter)
            );
        }
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


    @Phantom proc removeAllElements_loop_direct (iter: Iterator): void
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
        val key: Object = _generateKey(visitedKeys);

        val isCollectionContainsKey: boolean = action CALL_METHOD(c, "contains", [key]);

        if (isCollectionContainsKey)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }

        action MAP_SET(visitedKeys, key, HASHSET_VALUE);
        i += 1;
    }


    fun *.toArray (@target self: HashSet): array<Object>
    {
        val expectedModCount: int = this.modCount;
        val size: int = this.length;
        val visitedKeys: map<Object, Object> = action MAP_NEW();
        val resultArray: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);
        var i: int = 0;

        action LOOP_FOR(
            i, 0, size, +1,
            toArray_loop(i, visitedKeys, resultArray)
        );

        _checkForComodification(expectedModCount);
        result = resultArray;
    }


    @Phantom proc toArray_loop(i: int, visitedKeys: map<Object, Object>, resultArray: array<Object>): void
    {
        val key: Object = _generateKey(visitedKeys);

        resultArray[i] = key;

        action MAP_SET(visitedKeys, key, HASHSET_VALUE);
    }


    fun *.toArray (@target self: HashSet, a: array<Object>): array<Object>
    {
        val expectedModCount: int = this.modCount;
        val aLen: int = action ARRAY_SIZE(a);
        val size: int = this.length;
        val visitedKeys: map<Object, Object> = action MAP_NEW();
        var resultArray: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);
        var i: int = 0;

        if (aLen < size)
        {
            action LOOP_FOR(
                i, 0, size, +1,
                toArray_loop(i, visitedKeys, resultArray)
            );
        }
        else
        {
            resultArray = a;
            action LOOP_FOR(
                i, 0, size, +1,
                toArray_loop(i, visitedKeys, resultArray)
            );

            if (aLen > this.length)
                result[this.length] = null;
        }

        _checkForComodification(expectedModCount);
        result = resultArray;
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

        result = isContainsAll;
    }


    @Phantom proc _containsAllElements_loop(iter: Iterator, isContainsAll: boolean): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);

        if (!isKeyExist)
        {
            isContainsAll = false;
            action LOOP_BREAK();
        }
    }


    fun *.addAll (@target self: HashSet, c: Collection): boolean
    {
        result = _addAllElements(c);
    }


    fun *.retainAll (@target self: HashSet, c: Collection): boolean
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
        {
            result = false;
        }
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
        {
            result = false;
        }
    }


    @Phantom proc _removeIf_loop(i: int, visitedKeys: map<Object, Object>, filter: Predicate): void
    {
        val key: Object = _generateKey(visitedKeys);

        var isDelete: boolean = action CALL(filter, [key]);

        if(isDelete)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }

        i += 1;
        action MAP_SET(visitedKeys, key, HASHSET_VALUE);
    }


    fun *.forEach (@target self: HashSet, userAction: Consumer): void
    {
        if (userAction == null)
            _throwNPE();

        var i: int = 0;
        val visitedKeys: map<Object, Object> = action MAP_NEW();

        action LOOP_WHILE(
            i < this.length,
            forEach_loop(i, visitedKeys, userAction)
        );
    }


    @Phantom proc forEach_loop(i: int, visitedKeys: map<Object, Object>, userAction: Consumer): void
    {
        val key: Object = _generateKey(visitedKeys);

        action CALL(userAction, [key]);

        i += 1;
        action MAP_SET(visitedKeys, key, HASHSET_VALUE);
    }


    // within java.util.Collection
    fun *.stream (@target self: HashSet): Stream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashSet): Stream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    // special: serialization

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
}