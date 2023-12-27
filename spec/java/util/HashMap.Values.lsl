///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/util/Collection;
import java/util/Map;
import java/util/Set;
import java/util/function/BiConsumer;
import java/util/function/BiFunction;
import java/util/function/Function;
import java/util/HashMap;


// automata

automaton HashMap_ValuesAutomaton
(
    var storageRef: map<Object, Map_Entry<Object, Object>>,
    var parent: HashMap
)
: HashMap_Values
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
        forEach,
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
        toArray (HashMap_Values),
        toArray (HashMap_Values, IntFunction),
        toArray (HashMap_Values, array<Object>),
        toString,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _throwUOE (): void
    {
        action THROW_NEW("java.lang.UnsupportedOperationException", []);
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _mapToValuesArray (): array<Object>
    {
        val storageSize: int = action MAP_SIZE(this.storageRef);
        result = action ARRAY_NEW("java.lang.Object", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            map_to_values_array_loop(i, result, unseen)
        );
    }


    @Phantom proc map_to_values_array_loop (i: int, result: array<Object>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        result[i] = AbstractMap_SimpleEntryAutomaton(entry).value;
        action MAP_REMOVE(unseen, curKey);
    }


    // constructors

    @private constructor *.`<init>` (@target self: HashMap_Values, _this: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // static methods

    // methods

    // within java.util.AbstractCollection
    fun *.add (@target self: HashMap_Values, e: Object): boolean
    {
        if (true) // <- fooling Java compiler to not give "unreachable statement" error
            _throwUOE();
    }


    // within java.util.AbstractCollection
    fun *.addAll (@target self: HashMap_Values, c: Collection): boolean
    {
        if (true) // <- fooling Java compiler to not give "unreachable statement" error
            _throwUOE();
    }


    @final fun *.clear (@target self: HashMap_Values): void
    {
        HashMapAutomaton(this.parent).modCount += 1;

        val newStorage: map<Object, Map_Entry<Object, Object>> = action MAP_NEW();
        HashMapAutomaton(this.parent).storage = newStorage;
        this.storageRef = newStorage;
    }


    @final fun *.contains (@target self: HashMap_Values, value: Object): boolean
    {
        result = false;
        val storageSize: int = action MAP_SIZE(this.storageRef);
        if (storageSize != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            var i: int = 0;
            action LOOP_WHILE(
                result != true,
                contains_loop(result, unseen, value)
            );
        }
    }


    @Phantom proc contains_loop (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (action OBJECT_EQUALS(curValue, value))
            result = true;
        else
            action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMap_Values, c: Collection): boolean
    {
        result = true;

        val thisSize: int = action MAP_SIZE(this.storageRef);
        if (thisSize != 0 && c != self)
        {
            action ASSUME(thisSize > 0);

            // #todo: add optimized version based on automata checks (hint: HAS operator)

            val otherSize: int = action CALL_METHOD(c, "size", []);
            if (otherSize > 0)
            {
                // #todo: add optimization based on size of THIS and the OTHER containers (process less elements)

                var i: int = 0;

                // collect values from THIS collection for easier iteration
                val thisValues: array<Object> = action ARRAY_NEW("java.lang.Object", thisSize);
                val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
                action LOOP_FOR(
                    i, 0, thisSize, +1,
                    containsAll_collector(i, unseen, thisValues)
                );

                // inspect values from the OTHER collection
                val iter: Iterator<Object> = action CALL_METHOD(c, "iterator", []);
                action LOOP_WHILE(
                    result && action CALL_METHOD(iter, "hasNext", []),
                    containsAll_inspector(iter, thisValues, thisSize, i, result)
                );
            }
        }
    }

    @Phantom proc containsAll_collector (i: int, unseen: map<Object, Map_Entry<Object, Object>>, thisValues: array<Object>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, key);

        thisValues[i] = AbstractMap_SimpleEntryAutomaton(entry).value;

        action MAP_REMOVE(unseen, key);
    }

    @Phantom proc containsAll_inspector (iter: Iterator<Object>, thisValues: array<Object>, thisSize: int, i: int, result: boolean): void
    {
        val value: Object = action CALL_METHOD(iter, "next", []);

        i = 0;
        action LOOP_WHILE(
            result && i != thisSize,
            containsAll_inspector_loop(i, value, thisValues, result)
        );
    }

    @Phantom proc containsAll_inspector_loop (i: int, value: Object, thisValues: array<Object>, result: boolean): void
    {
        result = action OBJECT_EQUALS(thisValues[i], value);
    }


    @Phantom proc _containsAll_loop (result: boolean, iter: Iterator, storageSize: int): void
    {
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        val item: Object = action CALL_METHOD(iter, "next", []);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _containsAll_inside_loop(result, unseen, item)
        );
    }


    @Phantom proc _containsAll_inside_loop (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, item: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (!action OBJECT_EQUALS(curValue, item))
        {
            result = false;
            action LOOP_BREAK();
        }
        action MAP_REMOVE(unseen, curKey);
    }


    @final fun *.forEach (@target self: HashMap_Values, userAction: Consumer): void
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
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        action CALL(userAction, [curValue]);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_Values): boolean
    {
        result = action MAP_SIZE(this.storageRef) == 0;
    }


    @final fun *.iterator (@target self: HashMap_Values): Iterator
    {
        result = new HashMap_ValueIteratorAutomaton(state = Initialized,
            parent = this.parent,
            unseen = action MAP_CLONE(this.storageRef),
            expectedModCount = HashMapAutomaton(this.parent).modCount
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_Values): Stream
    {
        // #note: temporary decision (we don't support multithreading yet)
        val items: array<Object> = _mapToValuesArray();
        result = new StreamAutomaton(state = Initialized,
            storage = items,
            length = action ARRAY_SIZE(items),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.remove (@target self: HashMap_Values, value: Object): boolean
    {
        result = false;
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var thisSize: int = action MAP_SIZE(this.storageRef);
        var i: int = 0;

        if (value == null)
        {
            action LOOP_WHILE(
                result != true && thisSize != 0,
                remove_loop_null(result, unseen, thisSize)
            );
        }
        else
        {
            action LOOP_WHILE(
                result != true && thisSize != 0,
                remove_loop_value(result, unseen, value, thisSize)
            );
        }
    }


    @Phantom proc remove_loop_null (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, thisSize: int): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (curValue == null)
        {
            action MAP_REMOVE(this.storageRef, curKey);
            result = true;
        }
        action MAP_REMOVE(unseen, curKey);
        thisSize -= 1;
    }


    @Phantom proc remove_loop_value (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, value: Object, thisSize: int): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (action OBJECT_EQUALS(value, curValue))
        {
            action MAP_REMOVE(this.storageRef, curKey);
            result = true;
        }
        action MAP_REMOVE(unseen, curKey);
        thisSize -= 1;
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMap_Values, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);
        val cSize: int = action CALL_METHOD(c, "size", []);

        if (startStorageSize != 0 && cSize != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, startStorageSize, +1,
                removeAll_loop(unseen, c)
            );

            val resultStorageSize: int = action MAP_SIZE(this.storageRef);
            result = startStorageSize != resultStorageSize;
        }
    }


    @Phantom proc removeAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (action CALL_METHOD(c, "contains", [curValue]))
        {
            action MAP_REMOVE(this.storageRef, curKey);
            HashMapAutomaton(this.parent).modCount += 1;
        }
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_Values, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);

        if (startStorageSize != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, startStorageSize, +1,
                removeIf_loop(unseen, filter)
            );

            val resultStorageSize: int = action MAP_SIZE(this.storageRef);
            result = startStorageSize != resultStorageSize;
        }
    }


    @Phantom proc removeIf_loop (unseen: map<Object, Map_Entry<Object, Object>>, filter: Predicate): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (action CALL(filter, [curValue]))
        {
            action MAP_REMOVE(this.storageRef, curKey);
            HashMapAutomaton(this.parent).modCount += 1;
        }
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_Values, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);
        val cSize: int = action CALL_METHOD(c, "size", []);

        if (startStorageSize != 0 && cSize != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, startStorageSize, +1,
                retainAll_loop(unseen, c)
            );

            val resultStorageSize: int = action MAP_SIZE(this.storageRef);
            result = startStorageSize != resultStorageSize;
        }
    }


    @Phantom proc retainAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (!action CALL_METHOD(c, "contains", [curValue]))
            action MAP_REMOVE(this.storageRef, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    @final fun *.size (@target self: HashMap_Values): int
    {
        result = action MAP_SIZE(this.storageRef);
    }


    @final fun *.spliterator (@target self: HashMap_Values): Spliterator
    {
        result = new HashMap_ValueSpliteratorAutomaton(state=Initialized,
            valuesStorage = _mapToValuesArray(),
            parent = this.parent
        );
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMap_Values): Stream
    {
        val items: array<Object> = _mapToValuesArray();
        result = new StreamAutomaton(state = Initialized,
            storage = items,
            length = action ARRAY_SIZE(items),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_Values): array<Object>
    {
        val len: int = action MAP_SIZE(this.storageRef);
        result = action ARRAY_NEW("java.lang.Object", len);
        if (len != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, len, +1,
                toArray_loop(i, result, unseen)
            );
        }
    }


    @Phantom proc toArray_loop (i: int, result: array<Object>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        result[i] = AbstractMap_SimpleEntryAutomaton(entry).value;
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMap_Values, generator: IntFunction): array<Object>
    {
        // acting just like the JDK: trigger NPE and class cast exceptions on invalid generator return value
        val a: array<Object> = action CALL_METHOD(generator, "apply", [0]) as array<Object>;
        val aLen: int = action ARRAY_SIZE(a);

        val len: int = action MAP_SIZE(this.storageRef);
        result = action ARRAY_NEW("java.lang.Object", len);
        if (len != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, len, +1,
                toArray_loop(i, result, unseen)
            );
        }
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_Values, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = action MAP_SIZE(this.storageRef);

        if (aLen < len)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;
        if (len != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);

            var i: int = 0;
            action LOOP_FOR(
                i, 0, len, +1,
                toArray_loop(i, result, unseen)
            );

            if (aLen > len)
                result[len] = null;
        }
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: HashMap_Values): String
    {
        val storageSize: int = action MAP_SIZE(this.storageRef);
        if (storageSize != 0)
        {
            val arrayValues: array<Object> = action ARRAY_NEW("java.lang.Object", storageSize);
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, storageSize, +1,
                toString_loop(i, unseen, arrayValues)
            );

            result = action OBJECT_TO_STRING(arrayValues);
        }
        else
        {
            result = "[]";
        }
    }


    @Phantom proc toString_loop (i: int, unseen: map<Object, Map_Entry<Object, Object>>, arrayValues: array<Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        arrayValues[i] = AbstractMap_SimpleEntryAutomaton(entry).value;
        action MAP_REMOVE(unseen, curKey);
    }

}
