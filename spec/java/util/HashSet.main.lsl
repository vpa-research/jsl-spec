///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashSet.java";

// imports

import java/lang/Object;
import java/util/function/IntFunction;
import java/util/function/Consumer;
import java/util/function/Predicate;
import java/util/Collection;
import java/util/Iterator;
import java/util/Spliterator;
import java/util/stream/Stream;

import java/util/HashSet;


// automata

automaton HashSetAutomaton
(
    var storage: map<Object, Object>
)
: HashSet
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (HashSet),
        `<init>` (HashSet, Collection),
        `<init>` (HashSet, int),
        `<init>` (HashSet, int, float),
        `<init>` (HashSet, int, float, boolean),
    ];

    shift Initialized -> self by [
        // instance methods
        add,
        addAll,
        clear,
        clone,
        contains,
        containsAll,
        equals,
        forEach,
        hashCode,
        isEmpty,
        iterator,
        parallelStream,
        remove,
        removeAll,
        removeIf,
        retainAll,
        size,
        spliterator,
        stream,
        toArray (HashSet),
        toArray (HashSet, IntFunction),
        toArray (HashSet, array<Object>),
        toString,
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


    proc _makeStream (parallel: boolean): Stream
    {
        val unseen: map<Object, Object> = action MAP_CLONE(this.storage);

        val count: int = action MAP_SIZE(unseen);
        val items: array<Object> = action ARRAY_NEW("java.lang.Object", count);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, count, +1,
            _makeStream_loop(i, items, unseen)
        );

        // #problem: unable to catch concurrent modifications during stream processing

        result = new StreamAutomaton(state = Initialized,
            storage = items,
            length = count,
            closeHandlers = action LIST_NEW(),
            isParallel = parallel,
        );
    }

    @Phantom proc _makeStream_loop (i: int, items: array<Object>, unseen: map<Object, Object>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseen);
        action MAP_REMOVE(unseen, key);

        items[i] = key;
    }


    // constructors

    constructor *.`<init>` (@target self: HashSet)
    {
        this.storage = action MAP_NEW();
    }


    constructor *.`<init>` (@target self: HashSet, c: Collection)
    {
        this.storage = action MAP_NEW();
        _addAllElements(c);
    }


    constructor *.`<init>` (@target self: HashSet, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            //val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }

        this.storage = action MAP_NEW();
    }


    constructor *.`<init>` (@target self: HashSet, initialCapacity: int, loadFactor: float)
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


    @private constructor *.`<init>` (@target self: HashSet, initialCapacity: int, loadFactor: float, dummy: boolean)
    {
        action ERROR("Private constructor call");
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
            action MAP_SET(this.storage, obj, SOMETHING);
            result = true;
        }

        this.modCount += 1;
    }


    fun *.clear (@target self: HashSet): void
    {
        this.storage = action MAP_NEW();
        this.modCount += 1;
    }


    fun *.clone (@target self: HashSet): Object
    {
        result = new HashSetAutomaton(state = Initialized,
            storage = action MAP_CLONE(this.storage)
        );
    }


    fun *.contains (@target self: HashSet, obj: Object): boolean
    {
        if (action MAP_SIZE(this.storage) == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storage, obj);
    }


    fun *.isEmpty (@target self: HashSet): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    fun *.iterator (@target self: HashSet): Iterator
    {
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
        result = new HashSet_KeyIteratorAutomaton(state = Initialized,
            expectedModCount = this.modCount,
            unseenKeys = unseenKeys,
            parent = self
        );
    }


    fun *.remove (@target self: HashSet, obj: Object): boolean
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


    fun *.size (@target self: HashSet): int
    {
        result = action MAP_SIZE(this.storage);
    }


    fun *.spliterator (@target self: HashSet): Spliterator
    {
        val keysStorageArray: array<Object> = action ARRAY_NEW("java.lang.Object", action MAP_SIZE(this.storage));
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, action MAP_SIZE(this.storage), +1,
            fromMapToArray_loop(i, keysStorageArray, unseenKeys)
        );


        result = new HashSet_KeySpliteratorAutomaton(state=Initialized,
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


    fun *.equals (@target self: HashSet, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            if (other has HashSetAutomaton)
            {
                val expectedModCount: int = this.modCount;
                val otherExpectedModCount: int = HashSetAutomaton(other).modCount;

                val otherStorage: map<Object, Object> = HashSetAutomaton(other).storage;

                if (action MAP_SIZE(this.storage) == action MAP_SIZE(otherStorage))
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
                i < lengthBeforeRemoving,
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


    fun *.toArray (@target self: HashSet): array<Object>
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


    fun *.toArray (@target self: HashSet, a: array<Object>): array<Object>
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


    fun *.toArray (@target self: HashSet, generator: IntFunction): array<Object>
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

        val lengthBeforeAdd: int = action MAP_SIZE(this.storage);
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;

        action LOOP_WHILE(
            i < lengthBeforeAdd,
            _retainAllElements_loop(i, c, unseenKeys)
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


    @Phantom proc _retainAllElements_loop(i: int, c: Collection, unseenKeys: map<Object, Object>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseenKeys);
        action MAP_REMOVE(unseenKeys, key);

        if (action CALL_METHOD(c, "contains", [key]) == false)
            action MAP_REMOVE(this.storage, key);

        i += 1;
    }


    fun *.removeIf (@target self: HashSet, filter: Predicate): boolean
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


    fun *.forEach (@target self: HashSet, userAction: Consumer): void
    {
        if (userAction == null)
            _throwNPE();

        var i: int = 0;
        val count: int = action MAP_SIZE(this.storage);
        val expectedModCount: int = this.modCount;
        val unseenKeys: map<Object, Object> = action MAP_CLONE(this.storage);

        action LOOP_WHILE(
            i < count,
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
    fun *.stream (@target self: HashSet): Stream
    {
        result = _makeStream(/* parallel = */ false);
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashSet): Stream
    {
        result = _makeStream(/* parallel = */ true);
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


    // within java.util.AbstractCollection
    fun *.toString (@target self: HashSet): String
    {
        val items: map<Object, Object> = this.storage;
        var count: int = action MAP_SIZE(items);

        if (count == 0)
        {
            result = "[]";
        }
        else
        {
            action ASSUME(count > 0);

            result = "[";

            val unseen: map<Object, Object> = action MAP_CLONE(items);
            action LOOP_WHILE(
                count != 0,
                toString_loop(unseen, count, result)
            );

            result += "]";
        }
    }

    @Phantom proc toString_loop (unseen: map<Object, Object>, count: int, result: String): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseen);
        action MAP_REMOVE(unseen, key);

        result += action OBJECT_TO_STRING(key);

        if (count > 1)
            result += ", ";
        count -= 1;
    }
}