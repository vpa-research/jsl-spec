libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedHashSet.java";

// imports

import java/lang/Object;
import java/util/LinkedHashSet;
import java/util/function/IntFunction;
import java/util/function/Consumer;
import java/util/function/Predicate;
import java/util/Collection;
import java/util/Iterator;
import java/util/Spliterator;

// automata

automaton LinkedHashSetAutomaton
(
    var storage: map<Object, Object> = null,
    @transient var length: int = 0
)
: LinkedHashSet
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        LinkedHashSet (LinkedHashSet),
        LinkedHashSet (LinkedHashSet, Collection),
        LinkedHashSet (LinkedHashSet, int),
        LinkedHashSet (LinkedHashSet, int, float),
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
        toArray(LinkedHashSet),
        toArray(LinkedHashSet, array<Object>),
        toArray(LinkedHashSet, IntFunction),
        toString,

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

    // internal variables

    @transient var modCount: int = 0;

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
            action MAP_SET(this.storage, key, SOMETHING);
            this.length += 1;
        }
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // constructors

    constructor *.LinkedHashSet (@target self: LinkedHashSet)
    {
        this.storage = action MAP_NEW();
    }


    constructor *.LinkedHashSet (@target self: LinkedHashSet, c: Collection)
    {
        this.storage = action MAP_NEW();
        _addAllElements(c);
    }


    constructor *.LinkedHashSet (@target self: LinkedHashSet, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            //val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }

        this.storage = action MAP_NEW();
    }


    constructor *.LinkedHashSet (@target self: LinkedHashSet, initialCapacity: int, loadFactor: float)
    {
        if (initialCapacity < 0)
        {
            // val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }

        if (loadFactor <= 0 || action DEBUG_DO("Float.isNaN(loadFactor)"))
        {
            // val loadFactorStr: String = "Illegal load factor: " + action OBJECT_TO_STRING(loadFactor);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }

        this.storage = action MAP_NEW();
    }


    // methods

    fun *.add (@target self: LinkedHashSet, obj: Object): boolean
    {
        val hasKey: boolean = action MAP_HAS_KEY(this.storage, obj);

        if (hasKey)
        {
            result = false;
        }
        else
        {
            this.length += 1;

            action MAP_SET(this.storage, obj, SOMETHING);

            result = true;
        }

        this.modCount += 1;
    }


    fun *.clear (@target self: LinkedHashSet): void
    {
        this.length = 0;
        this.storage = action MAP_NEW();

        this.modCount +=1;
    }


    fun *.clone (@target self: LinkedHashSet): Object
    {
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);

        result = new LinkedHashSetAutomaton(state = Initialized,
            storage = storageCopy,
            length = this.length
        );
    }


    fun *.contains (@target self: LinkedHashSet, obj: Object): boolean
    {
        if (this.length == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storage, obj);
    }


    fun *.isEmpty (@target self: LinkedHashSet): boolean
    {
        result = this.length == 0;
    }


    fun *.iterator (@target self: LinkedHashSet): Iterator
    {
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
        result = new LinkedHashSet_KeyIteratorAutomaton(state = Initialized,
            expectedModCount = this.modCount,
            unseenKeys = unseenKeys,
            parent = self
        );
    }


    fun *.remove (@target self: LinkedHashSet, obj: Object): boolean
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


    fun *.size (@target self: LinkedHashSet): int
    {
        result = this.length;
    }


    fun *.spliterator (@target self: LinkedHashSet): Spliterator
    {
        val keysStorageArray: array<Object> = action ARRAY_NEW("java.lang.Object", this.length);
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            fromMapToArray_loop(i, keysStorageArray, unseenKeys)
        );

        result = new LinkedHashSet_KeySpliteratorAutomaton(state = Initialized,
            keysStorage = keysStorageArray,
            index = 0,
            fence = -1,
            est = 0,
            expectedModCount = this.modCount,
            parent = self
        );
    }


    @Phantom proc fromMapToArray_loop (i: int, keysStorageArray: array<Object>, unseenKeys: map<Object, Object>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseenKeys);
        action MAP_REMOVE(unseenKeys, key);

        keysStorageArray[i] = key;
    }


    fun *.equals (@target self: LinkedHashSet, other: Object): boolean
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
                val otherExpectedModCount: int = LinkedHashSetAutomaton(other).modCount;

                val otherStorage: map<Object, Object> = LinkedHashSetAutomaton(other).storage;
                val otherLength: int = LinkedHashSetAutomaton(other).length;

                if (this.length == otherLength)
                    result = action OBJECT_EQUALS(this.storage, otherStorage);
                else
                    result = false;

                LinkedHashSetAutomaton(other)._checkForComodification(otherExpectedModCount);
                _checkForComodification(expectedModCount);
            }
            else
            {
                result = false;
            }
        }
    }


    fun *.hashCode (@target self: LinkedHashSet): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.removeAll (@target self: LinkedHashSet, c: Collection): boolean
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
            val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
            action LOOP_WHILE(
                i < this.length,
                _removeAllElements_loop_indirect(i, c, unseenKeys)
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


    @Phantom proc _removeAllElements_loop_indirect (i: int, c: Collection, unseenKeys: map<Object, Object>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseenKeys);
        action MAP_REMOVE(unseenKeys, key);

        val isCollectionContainsKey: boolean = action CALL_METHOD(c, "contains", [key]);

        if (isCollectionContainsKey)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }

        i += 1;
    }


    fun *.toArray (@target self: LinkedHashSet): array<Object>
    {
        val len: int = this.length;
        result = action ARRAY_NEW("java.lang.Object", len);
        val expectedModCount: int = this.modCount;
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;

        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, unseenKeys, result)
        );

        _checkForComodification(expectedModCount);
    }


    @Phantom proc toArray_loop(i: int, unseenKeys: map<Object, Object>, result: array<Object>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseenKeys);
        action MAP_REMOVE(unseenKeys, key);

        result[i] = key;
    }


    fun *.toArray (@target self: LinkedHashSet, a: array<Object>): array<Object>
    {
        val expectedModCount: int = this.modCount;
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = this.length;
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;

        if (aLen < len)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;

        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, unseenKeys, result)
        );

        if (aLen > this.length)
            result[this.length] = null;

        _checkForComodification(expectedModCount);
    }


    fun *.toArray (@target self: LinkedHashSet, generator: IntFunction): array<Object>
    {
        if (generator == null)
            _throwNPE();

        val len: int = this.length;
        result = action CALL(generator, [0]) as array<Object>;
        val expectedModCount: int = this.modCount;
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;

        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, unseenKeys, result)
        );

        _checkForComodification(expectedModCount);
    }


    fun *.containsAll (@target self: LinkedHashSet, c: Collection): boolean
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


    @Phantom proc _containsAllElements_loop (iter: Iterator, isContainsAll: boolean): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);
        val isKeyExist: boolean = action MAP_HAS_KEY(this.storage, key);

        if (!isKeyExist)
        {
            isContainsAll = false;
            action LOOP_BREAK();
        }
    }


    fun *.addAll (@target self: LinkedHashSet, c: Collection): boolean
    {
        result = _addAllElements(c);
    }


    fun *.retainAll (@target self: LinkedHashSet, c: Collection): boolean
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


    fun *.removeIf (@target self: LinkedHashSet, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        val lengthBeforeAdd: int = this.length;
        val expectedModCount: int = this.modCount;
        var i: int = 0;
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);

        action LOOP_WHILE(
            i < lengthBeforeAdd,
            _removeIf_loop(i, unseenKeys, filter)
        );

        _checkForComodification(expectedModCount);
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


    @Phantom proc _removeIf_loop (i: int, unseenKeys: map<Object, Object>, filter: Predicate): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseenKeys);
        action MAP_REMOVE(unseenKeys, key);

        var isDelete: boolean = action CALL(filter, [key]);

        if(isDelete)
        {
            action MAP_REMOVE(this.storage, key);
            this.length -= 1;
        }

        i += 1;
    }


    fun *.forEach (@target self: LinkedHashSet, userAction: Consumer): void
    {
        if (userAction == null)
            _throwNPE();

        var i: int = 0;
        val expectedModCount: int = this.modCount;
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);

        action LOOP_WHILE(
            i < this.length,
            forEach_loop(i, unseenKeys, userAction)
        );

        _checkForComodification(expectedModCount);
    }


    @Phantom proc forEach_loop (i: int, unseenKeys: map<Object, Object>, userAction: Consumer): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseenKeys);
        action MAP_REMOVE(unseenKeys, key);

        action CALL(userAction, [key]);

        i += 1;
    }


    // within java.util.Collection
    fun *.stream (@target self: LinkedHashSet): Stream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: LinkedHashSet): Stream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.Stream");
        action ASSUME(result != null);
    }


    // special: serialization

    @throws(["java.io.IOException"])
    @private fun *.writeObject (@target self: LinkedHashSet, s: ObjectOutputStream): void
    {
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun *.readObject (@target self: LinkedHashSet, s: ObjectInputStream): void
    {
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: LinkedHashSet): String
    {
        result = action OBJECT_TO_STRING(this.storage);
    }
}