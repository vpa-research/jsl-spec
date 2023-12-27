libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java#L909";

// imports

import java/lang/Object;
import java/lang/String;
import java/util/AbstractSet;
import java/util/Collection;
import java/util/HashMap;
import java/util/Iterator;
import java/util/Spliterator;
import java/util/function/Consumer;
import java/util/function/IntFunction;
import java/util/function/Predicate;
import java/util/stream/Stream;


// automata

automaton HashMap_KeySetAutomaton
(
    var storageRef: map<Object, Map_Entry<Object, Object>>,
    var parent: HashMap
)
: HashMap_KeySet
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,
    ];

    shift Initialized -> self by [
        // instance methods
        add,
        addAll,
        clear,
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
        toArray (HashMap_KeySet),
        toArray (HashMap_KeySet, IntFunction),
        toArray (HashMap_KeySet, array<Object>),
        toString,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwUOE (): void
    {
        action THROW_NEW("java.lang.UnsupportedOperationException", []);
    }


    proc _mapToKeysArray (): array<Object>
    {
        val storageSize: int = action MAP_SIZE(this.storageRef);
        result = action ARRAY_NEW("java.lang.Object", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            mapToKeysArray_loop(i, result, unseen)
        );
    }


    @Phantom proc mapToKeysArray_loop (i: int, result: array<Object>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        result[i] = curKey;
        action MAP_REMOVE(unseen, curKey);
    }


    @Phantom proc _equals (result: boolean, c: Collection): void
    {
        result = true;
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            result && action CALL_METHOD(iter, "hasNext", []),
            containsAll_loop(result, iter)
        );
    }


    @Phantom proc containsAll_loop (result: boolean, iter: Iterator): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        result = action MAP_HAS_KEY(this.storageRef, item);
    }


    @Phantom proc _catch_proc_equals (result: boolean): void
    {
        result = false;
    }


    // constructors

    @private constructor *.`<init>` (@target self: HashMap_KeySet, _this: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // static methods

    // methods

    // within java.util.AbstractCollection
    fun *.add (@target self: HashMap_KeySet, e: Object): boolean
    {
        if (true)
            _throwUOE();
    }


    // within java.util.AbstractCollection
    fun *.addAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        if ( true)
            _throwUOE();
    }


    @final fun *.clear (@target self: HashMap_KeySet): void
    {
        HashMapAutomaton(this.parent).modCount += 1;

        val newStorage: map<Object, Map_Entry<Object, Object>> = action MAP_NEW();
        this.storageRef = newStorage;
        HashMapAutomaton(this.parent).storage = newStorage;
    }


    @final fun *.contains (@target self: HashMap_KeySet, key: Object): boolean
    {
        if (action MAP_SIZE(this.storageRef) == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storageRef, key);
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        result = true;
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []) && result == true,
            containsAll_loop(result, iter)
        );
    }


    // within java.util.AbstractSet
    fun *.equals (@target self: HashMap_KeySet, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            if (other is Set)
            {
                val c: Collection = other as Collection;
                val cLength: int = action CALL_METHOD(c, "size", []);
                val thisLength: int = action MAP_SIZE(this.storageRef);

                if (thisLength == cLength)
                {
                    action TRY_CATCH(
                        _equals(result, c),
                        [
                            ["java.lang.ClassCastException", _catch_proc_equals(result)],
                            ["java.lang.NullPointerException", _catch_proc_equals(result)],
                        ]
                    );
                }
                else
                {
                    result = false;
                }
            }
            else
            {
                result = false;
            }
        }
    }


    @final fun *.forEach (@target self: HashMap_KeySet, userAction: Consumer): void
    {
        if (userAction == null)
            _throwNPE();

        val storageSize: int = action MAP_SIZE(this.storageRef);
        if (storageSize > 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            val expectedModCount: int = HashMapAutomaton(this.parent).modCount;
            var i: int = 0;
            action LOOP_FOR(
                i, 0, storageSize, +1,
                forEach_loop(unseen, userAction)
            );
            HashMapAutomaton(this.parent)._checkForComodification(expectedModCount);
        }
    }


    @Phantom proc forEach_loop (unseen: map<Object, Map_Entry<Object, Object>>, userAction: Consumer): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        action CALL(userAction, [curKey]);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractSet
    fun *.hashCode (@target self: HashMap_KeySet): int
    {
        result = action OBJECT_HASH_CODE(this.storageRef);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_KeySet): boolean
    {
        result = action MAP_SIZE(this.storageRef) == 0;
    }


    @final fun *.iterator (@target self: HashMap_KeySet): Iterator
    {
        result = new HashMap_KeyIteratorAutomaton(state = Initialized,
            parent = this.parent,
            unseen = action MAP_CLONE(this.storageRef),
            expectedModCount = HashMapAutomaton(this.parent).modCount
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_KeySet): Stream
    {
        // #note: temporary decision (we don't support multithreading yet)
        val items: array<Object> = _mapToKeysArray();
        result = new StreamAutomaton(state = Initialized,
            storage = _mapToKeysArray(),
            length = action ARRAY_SIZE(items),
            closeHandlers = action LIST_NEW()
        );
    }


    @final fun *.remove (@target self: HashMap_KeySet, key: Object): boolean
    {
        result = false;
        if (action MAP_HAS_KEY(this.storageRef, key))
        {
            action MAP_REMOVE(this.storageRef, key);
            HashMapAutomaton(this.parent).modCount += 1;
            result = true;
        }
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);
        val collectionSize: int = action CALL_METHOD(c, "size", []);

        if (startStorageSize > collectionSize)
        {
            val iter: Iterator = action CALL_METHOD(c, "iterator", []);
            action LOOP_WHILE(
                action CALL_METHOD(iter, "hasNext", []),
                removeAll_loop_less(iter)
            );
        }
        else
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, startStorageSize, +1,
                removeAll_loop_greater(unseen, c)
            );
        }

        val resultStorageSize: int = action MAP_SIZE(this.storageRef);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc removeAll_loop_greater (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        if (action CALL_METHOD(c, "contains", [curKey]))
            action MAP_REMOVE(this.storageRef, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    @Phantom proc removeAll_loop_less (iter: Iterator): void
    {
        val oKey: Object = action CALL_METHOD(iter, "next", []);
        if (action MAP_HAS_KEY(this.storageRef, oKey))
        {
            action MAP_REMOVE(this.storageRef, oKey);
        }
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_KeySet, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            removeIf_loop(unseen, filter)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storageRef);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc removeIf_loop (unseen: map<Object, Map_Entry<Object, Object>>, filter: Predicate): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        if (action CALL(filter, [curKey]))
            action MAP_REMOVE(this.storageRef, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            retainAll_loop(unseen, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storageRef);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc retainAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        if (!action CALL_METHOD(c, "contains", [curKey]))
            action MAP_REMOVE(this.storageRef, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    @final fun *.size (@target self: HashMap_KeySet): int
    {
        result = action MAP_SIZE(this.storageRef);
    }


    @final fun *.spliterator (@target self: HashMap_KeySet): Spliterator
    {
        result = new HashMap_KeySpliteratorAutomaton(state=Initialized,
            keysStorage = _mapToKeysArray(),
            parent = this.parent
        );
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMap_KeySet): Stream
    {
        // WARNING: no concurrent modification checks during stream object's lifetime
        val items: array<Object> = _mapToKeysArray();
        result = new StreamAutomaton(state = Initialized,
            storage = items,
            length = action ARRAY_SIZE(items),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_KeySet): array<Object>
    {
        val len: int = action MAP_SIZE(this.storageRef);
        result = action ARRAY_NEW("java.lang.Object", len);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, unseen)
        );
    }


    @Phantom proc toArray_loop (i: int, result: array<Object>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        result[i] = curKey;
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMap_KeySet, generator: IntFunction): array<Object>
    {
        // acting just like the JDK: trigger NPE and class cast exceptions on invalid generator return value
        val a: array<Object> = action CALL_METHOD(generator, "apply", [0]) as array<Object>;
        val aLen: int = action ARRAY_SIZE(a);

        val len: int = action MAP_SIZE(this.storageRef);
        result = action ARRAY_NEW("java.lang.Object", len);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, unseen)
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_KeySet, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = action MAP_SIZE(this.storageRef);

        if (aLen < len)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, unseen)
        );

        if (aLen > len)
            result[len] = null;
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: HashMap_KeySet): String
    {
        val storageSize: int = action MAP_SIZE(this.storageRef);
        val arrayKeys: array<Object> = action ARRAY_NEW("java.lang.Object", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            toString_loop(i, unseen, arrayKeys)
        );

        result = action OBJECT_TO_STRING(arrayKeys);
    }


    @Phantom proc toString_loop (i: int, unseen: map<Object, Map_Entry<Object, Object>>, arrayKeys: array<Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        arrayKeys[i] = curKey;
        action MAP_REMOVE(unseen, curKey);
    }

}