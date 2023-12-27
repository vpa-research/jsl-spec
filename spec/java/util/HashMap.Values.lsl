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
            _mapToValuesArray_loop(i, result, unseen)
        );
    }


    @Phantom proc _mapToValuesArray_loop (i: int, result: array<Object>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        result[i] = action CALL_METHOD(entry, "getValue", []);
        action MAP_REMOVE(unseen, curKey);
    }


    // constructors

    @private constructor *.`<init>` (@target self: HashMap_Values, _this: HashMap)
    {
        // #note: default constructor without any body, like in the original class
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
        this.storageRef = action MAP_NEW();
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
                _containsValue_loop(result, unseen, value)
            );
        }
    }


    @Phantom proc _containsValue_loop (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action OBJECT_EQUALS(curValue, value))
            result = true;
        else
            action MAP_REMOVE(unseen, curKey);
    }


    // #note: double loop... Can we avoid this ? too comprehensive realization...
    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMap_Values, c: Collection): boolean
    {
        result = true;
        val storageSize: int = action MAP_SIZE(this.storageRef);
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []) && result == true,
            _containsAll_loop(result, iter, storageSize)
        );
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
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
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
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
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
        // #question: this is right realization ?
        result = new HashMap_ValueIteratorAutomaton(state = Initialized,
            parent = this.parent,
            unseen = action MAP_CLONE(this.storageRef)
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_Values): Stream
    {
        // #note: temporary decision (we don't support multithreading now)
        // #question: this is right realization ? Or it can be wrong to give such array like an argument to StreamAutomaton ?
        result = new StreamAutomaton(state = Initialized,
            storage = _mapToValuesArray(),
            length = action MAP_SIZE(this.storageRef),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.remove (@target self: HashMap_Values, value: Object): boolean
    {
        result = false;
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;

        if (value == null)
        {
            action LOOP_WHILE(
                result != true,
                _removeNull_loop(result, unseen, value)
            );
        }
        else
        {
            action LOOP_WHILE(
                result != true,
                _removeValue_loop(result, unseen, value)
            );
        }
    }


    @Phantom proc _removeNull_loop (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (curValue == null)
        {
            action MAP_REMOVE(this.storageRef, curKey);
            result = true;
        }
        action MAP_REMOVE(unseen, curKey);
    }


    @Phantom proc _removeValue_loop (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action OBJECT_EQUALS(value, curValue))
        {
            action MAP_REMOVE(this.storageRef, curKey);
            result = true;
        }
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMap_Values, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeAll_loop(unseen, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storageRef);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action CALL_METHOD(c, "contains", [curValue]))
            action MAP_REMOVE(this.storageRef, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_Values, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeIf_loop(unseen, filter)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storageRef);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeIf_loop (unseen: map<Object, Map_Entry<Object, Object>>, filter: Predicate): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action CALL(filter, [curValue]))
            action MAP_REMOVE(this.storageRef, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_Values, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storageRef);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _retainAll_loop(unseen, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storageRef);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _retainAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (!action CALL_METHOD(c, "contains", [curValue]))
            action MAP_REMOVE(this.storageRef, curKey);
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
        // #question: this is right realization ? Or it can be wrong to give such array like an argument to StreamAutomaton ?
        result = new StreamAutomaton(state = Initialized,
            storage = _mapToValuesArray(),
            length = action MAP_SIZE(this.storageRef),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_Values): array<Object>
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
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        result[i] = curValue;
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
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, unseen)
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_Values, a: array<Object>): array<Object>
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

        // #question: this is correct ?
        if (aLen > len)
            result[len] = null;
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: HashMap_Values): String
    {
        val storageSize: int = action MAP_SIZE(this.storageRef);
        val arrayValues: array<Object> = action ARRAY_NEW("java.lang.Object", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storageRef);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _toString_loop(i, unseen, arrayValues)
        );

        result = action OBJECT_TO_STRING(arrayValues);
    }


    @Phantom proc _toString_loop (i: int, unseen: map<Object, Map_Entry<Object, Object>>, arrayValues: array<Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        arrayValues[i] = curValue;
        action MAP_REMOVE(unseen, curKey);
    }

}
