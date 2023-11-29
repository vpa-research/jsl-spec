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
    var storage: map<Object, Object>
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
        val lengthBeforeAdd: int = action MAP_SIZE(this.storage);
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _addAllElements_loop(iter)
        );

        if (lengthBeforeAdd != action MAP_SIZE(this.storage))
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

        if (action MAP_HAS_KEY(this.storage, key) == false)
            action MAP_SET(this.storage, key, SOMETHING);
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

        if (loadFactor <= 0 || loadFactor != loadFactor /* NaN */)
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
            action MAP_SET(this.storage, obj, SOMETHING);
            result = true;
        }

        this.modCount += 1;
    }


    fun *.clear (@target self: LinkedHashSet): void
    {
        this.storage = action MAP_NEW();
        this.modCount +=1;
    }


    fun *.clone (@target self: LinkedHashSet): Object
    {
        result = new LinkedHashSetAutomaton(state = Initialized,
            storage = action MAP_CLONE(this.storage)
        );
    }


    fun *.contains (@target self: LinkedHashSet, obj: Object): boolean
    {
        if (action MAP_SIZE(this.storage) == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storage, obj);
    }


    fun *.isEmpty (@target self: LinkedHashSet): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
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
        if (action MAP_HAS_KEY(this.storage, obj))
        {
            action MAP_REMOVE(this.storage, obj);
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
        result = action MAP_SIZE(this.storage);
    }


    fun *.spliterator (@target self: LinkedHashSet): Spliterator
    {
        val keysStorageArray: array<Object> = action ARRAY_NEW("java.lang.Object", action MAP_SIZE(this.storage));
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, action MAP_SIZE(this.storage), +1,
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
            if (other has LinkedHashSetAutomaton)
            {
                val expectedModCount: int = this.modCount;
                val otherExpectedModCount: int = LinkedHashSetAutomaton(other).modCount;

                val otherStorage: map<Object, Object> = LinkedHashSetAutomaton(other).storage;

                if (action MAP_SIZE(this.storage) == action MAP_SIZE(otherStorage))
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
        val lengthBeforeRemoving: int = action MAP_SIZE(this.storage);
        var i: int = 0;

        if (action MAP_SIZE(this.storage) > otherSize)
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
                i < action MAP_SIZE(this.storage),
                _removeAllElements_loop_indirect(i, c, unseenKeys)
            );
        }

        _checkForComodification(expectedModCount);
        this.modCount += 1;
        // If length changed, it means that at least one element was deleted
        result = lengthBeforeRemoving != action MAP_SIZE(this.storage);
    }


    @Phantom proc removeAllElements_loop_direct (iter: Iterator): void
    {
        val key: Object = action CALL_METHOD(iter, "next", []);

        if (action MAP_HAS_KEY(this.storage, key))
            action MAP_REMOVE(this.storage, key);
    }


    @Phantom proc _removeAllElements_loop_indirect (i: int, c: Collection, unseenKeys: map<Object, Object>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseenKeys);
        action MAP_REMOVE(unseenKeys, key);

        if (action CALL_METHOD(c, "contains", [key]))
            action MAP_REMOVE(this.storage, key);

        i += 1;
    }


    fun *.toArray (@target self: LinkedHashSet): array<Object>
    {
        val len: int = action MAP_SIZE(this.storage);
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
        val len: int = action MAP_SIZE(this.storage);
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;

        if (aLen < len)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;

        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, unseenKeys, result)
        );

        if (aLen > len)
            result[len] = null;

        _checkForComodification(expectedModCount);
    }


    fun *.toArray (@target self: LinkedHashSet, generator: IntFunction): array<Object>
    {
        if (generator == null)
            _throwNPE();

        val len: int = action MAP_SIZE(this.storage);
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

        val lengthBeforeAdd: int = action MAP_SIZE(this.storage);
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _retainAllElements_loop(iter)
        );

        if (lengthBeforeAdd != action MAP_SIZE(this.storage))
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

        if (action MAP_HAS_KEY(this.storage, key) == false)
            action MAP_REMOVE(this.storage, key);
    }


    fun *.removeIf (@target self: LinkedHashSet, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        val lengthBeforeAdd: int = action MAP_SIZE(this.storage);
        val expectedModCount: int = this.modCount;
        var i: int = 0;
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);

        action LOOP_WHILE(
            i < lengthBeforeAdd,
            _removeIf_loop(i, unseenKeys, filter)
        );

        _checkForComodification(expectedModCount);
        if (lengthBeforeAdd != action MAP_SIZE(this.storage))
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

        if(action CALL(filter, [key]))
            action MAP_REMOVE(this.storage, key);

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
            i < action MAP_SIZE(this.storage),
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