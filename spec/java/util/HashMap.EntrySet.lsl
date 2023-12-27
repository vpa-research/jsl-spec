libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java#L1005";

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
import java/util/Map;


// automata

automaton HashMap_EntrySetAutomaton
(
    var storageRef: map<Object, Map_Entry<Object, Object>>,
    var parent: HashMap
)
: HashMap_EntrySet
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
        toArray (HashMap_EntrySet),
        toArray (HashMap_EntrySet, IntFunction),
        toArray (HashMap_EntrySet, array<Object>),
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


    proc _mapToEntryArray (): array<Map_Entry<Object, Object>>
    {
        val storageSize: int = action MAP_SIZE(this.storageRef);
        result = action ARRAY_NEW("java.util.Map.Entry", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            mapToEntryArray_loop(i, result, unseen)
        );
    }


    @Phantom proc mapToEntryArray_loop (i: int, result: array<Map_Entry<Object, Object>>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        result[i] = action MAP_GET(this.storageRef, curKey);
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


    @Phantom proc _catch_proc_equals (result: boolean): void
    {
        result = false;
    }


    // constructors

    @private constructor *.`<init>` (@target self: HashMap_EntrySet, _this: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // static methods

    // methods

    // within java.util.AbstractCollection
    fun *.add (@target self: HashMap_EntrySet, e: Object): boolean
    {
        if (true)
            _throwUOE();
    }


    // within java.util.AbstractCollection
    fun *.addAll (@target self: HashMap_EntrySet, c: Collection): boolean
    {
        if (true)
            _throwUOE();
    }


    @final fun *.clear (@target self: HashMap_EntrySet): void
    {
        HashMapAutomaton(this.parent).modCount += 1;

        val newStorage: map<Object, Map_Entry<Object, Object>> = action MAP_NEW();
        this.storageRef = newStorage;
        HashMapAutomaton(this.parent).storage = newStorage;
    }


    @final fun *.contains (@target self: HashMap_EntrySet, o: Object): boolean
    {
        result = false;
        if (o is Map_Entry)
        {
            val entryParam: Map_Entry<Object, Object> = o as Map_Entry<Object, Object>;
            val key: Object = action CALL_METHOD(entryParam, "getKey", []);
            val value: Object = action CALL_METHOD(entryParam, "getValue", []);
            if (action MAP_HAS_KEY(this.storageRef, key) == false)
            {
                result = false;
            }
            else
            {
                var entryStorage: Map_Entry<Object, Object> = action MAP_GET(this.storageRef, key);
                // #question: this is right realization ? Or better to make entries equals ?
                result = action OBJECT_EQUALS(value, action CALL_METHOD(entryStorage, "getValue", []));
            }
        }
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMap_EntrySet, c: Collection): boolean
    {
        result = true;
        val iter: Iterator<Map_Entry<Object, Object>> = action CALL_METHOD(c, "iterator", []) as Iterator<Map_Entry<Object, Object>>;

        action LOOP_WHILE(
            result && action CALL_METHOD(iter, "hasNext", []),
            containsAll_loop(result, iter)
        );
    }


    @Phantom proc containsAll_loop (result: boolean, iter: Iterator): void
    {
        val cEntry: Map_Entry<Object, Object> = action CALL_METHOD(iter, "next", []) as Map_Entry<Object, Object>;
        val cKey: Object = action CALL_METHOD(cEntry, "getKey", []);
        if (action MAP_HAS_KEY(this.storageRef, cKey) == false)
        {
            result = false;
        }
        else
        {
            val entry: Map_Entry<Object, Object> = action MAP_GET(this.storageRef, cKey);
            result = action OBJECT_EQUALS(cEntry, entry);
        }
    }


    // #question: this is right realization of this method ? (I'm comparing every pair of MAP_ENTRY)
    // within java.util.AbstractSet
    fun *.equals (@target self: HashMap_EntrySet, other: Object): boolean
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


    @final fun *.forEach (@target self: HashMap_EntrySet, userAction: Consumer): void
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
        val entry: Map_Entry<Object, Object> = action MAP_GET(this.storageRef, curKey);

        action CALL(userAction, [entry]);

        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractSet
    fun *.hashCode (@target self: HashMap_EntrySet): int
    {
        result = action OBJECT_HASH_CODE(this.storageRef);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_EntrySet): boolean
    {
        result = action MAP_SIZE(this.storageRef) == 0;
    }


    @final fun *.iterator (@target self: HashMap_EntrySet): Iterator
    {
        result = new HashMap_EntryIteratorAutomaton(state = Initialized,
            parent = this.parent,
            unseen = action MAP_CLONE(this.storageRef),
            expectedModCount = HashMapAutomaton(this.parent).modCount
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_EntrySet): Stream
    {
        // #note: temporary decision (we don't support multithreading yet)
        val items: array<Object> = _mapToEntryArray();
        result = new StreamAutomaton(state = Initialized,
            storage = items,
            length = action ARRAY_SIZE(items),
            closeHandlers = action LIST_NEW()
        );
    }


    @final fun *.remove (@target self: HashMap_EntrySet, o: Object): boolean
    {
        result = false;
        if (o is Map_Entry)
        {
            val entryParam: Map_Entry = o as Map_Entry;
            val key: Object = action CALL_METHOD(entryParam, "getKey", []);
            val value: Object = action CALL_METHOD(entryParam, "getValue", []);
            if (action MAP_HAS_KEY(this.storageRef, key))
            {
                val entryStorage: Map_Entry<Object, Object> = action MAP_GET(this.storageRef, key);
                val actualValue: Object = action CALL_METHOD(entryStorage, "getValue", []);
                if (action OBJECT_EQUALS(value, actualValue))
                {
                    action MAP_REMOVE(this.storageRef, key);
                    HashMapAutomaton(this.parent).modCount += 1;
                    result = true;
                }
            }
        }
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMap_EntrySet, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);
        val collectionSize: int = action CALL_METHOD(c, "size", []);

        if (startStorageSize > collectionSize)
        {
            val iter: Iterator<Map_Entry<Object, Object>> = action CALL_METHOD(c, "iterator", []) as Iterator<Map_Entry<Object, Object>>;
            action LOOP_WHILE(
                action CALL_METHOD(iter, "hasNext", []),
                removeAll_loop_regular(iter)
            );
        }
        else
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, startStorageSize, +1,
                removeAll_loop_optimized(unseen, c)
            );
        }

        val resultStorageSize: int = action MAP_SIZE(this.storageRef);
        result = startStorageSize != resultStorageSize;
    }


    @Phantom proc removeAll_loop_optimized (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(this.storageRef, curKey);
        if (action CALL_METHOD(c, "contains", [entry]))
        {
            action MAP_REMOVE(this.storageRef, curKey);
            HashMapAutomaton(this.parent).modCount += 1;
        }
        action MAP_REMOVE(unseen, curKey);
    }


    @Phantom proc removeAll_loop_regular (iter: Iterator): void
    {
        val o: Map_Entry<Object, Object> = action CALL_METHOD(iter, "next", []) as Map_Entry<Object, Object>;
        val oKey: Object = action CALL_METHOD(o, "getKey", []);
        if (action MAP_HAS_KEY(this.storageRef, oKey))
        {
            if (action OBJECT_EQUALS(o, action MAP_GET(this.storageRef, oKey)))
            {
                action MAP_REMOVE(this.storageRef, oKey);
                HashMapAutomaton(this.parent).modCount += 1;
            }
        }
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_EntrySet, filter: Predicate): boolean
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
        result = startStorageSize != resultStorageSize;
    }


    @Phantom proc removeIf_loop (unseen: map<Object, Map_Entry<Object, Object>>, filter: Predicate): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        if (action CALL(filter, [entry]))
        {
            action MAP_REMOVE(this.storageRef, curKey);
            HashMapAutomaton(this.parent).modCount += 1;
        }
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_EntrySet, c: Collection): boolean
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
        result = startStorageSize != resultStorageSize;
    }


    @Phantom proc retainAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        if (action CALL_METHOD(c, "contains", [entry]) == false)
        {
            action MAP_REMOVE(this.storageRef, curKey);
            HashMapAutomaton(this.parent).modCount += 1;
        }
    }


    @final fun *.size (@target self: HashMap_EntrySet): int
    {
        result = action MAP_SIZE(this.storageRef);
    }


    @final fun *.spliterator (@target self: HashMap_EntrySet): Spliterator
    {
        result = new HashMap_EntrySpliteratorAutomaton(state = Initialized,
            parent = this.parent,
            entryStorage = _mapToEntryArray()
        );
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMap_EntrySet): Stream
    {
        val items: array<Object> = _mapToEntryArray();
        result = new StreamAutomaton(state = Initialized,
            storage = items,
            length = action ARRAY_SIZE(items),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_EntrySet): array<Object>
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
        result[i] = action MAP_GET(unseen, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMap_EntrySet, generator: IntFunction): array<Object>
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
    fun *.toArray (@target self: HashMap_EntrySet, a: array<Object>): array<Object>
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
    fun *.toString (@target self: HashMap_EntrySet): String
    {
        val storageSize: int = action MAP_SIZE(this.storageRef);
        val arrayEntries: array<Object> = action ARRAY_NEW("java.lang.Object", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            toString_loop(i, unseen, arrayEntries)
        );

        result = action OBJECT_TO_STRING(arrayEntries);
    }


    @Phantom proc toString_loop (i: int, unseen: map<Object, Map_Entry<Object, Object>>, arrayEntries: array<Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        arrayEntries[i] = entry;
        action MAP_REMOVE(unseen, curKey);
    }

}