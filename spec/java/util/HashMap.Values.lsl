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
    var storage: map<Object, Map_Entry<Object, Object>>,
    var parent: HashMap
)
: HashMap_Values
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMap_Values,
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
        val storageSize: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", storageSize);
        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _mapToValuesArray_loop(i, result, storageCopy)
        );
    }


    @Phantom proc _mapToValuesArray_loop (i: int, result: array<Object>, storageCopy: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        result[i] = action CALL_METHOD(entry, "getValue", []);
        action MAP_REMOVE(storageCopy, curKey);
    }


    // constructors

    @private constructor *.HashMap_Values (@target self: HashMap_Values, _this: HashMap)
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
        this.storage = action MAP_NEW();
    }


    @final fun *.contains (@target self: HashMap_Values, value: Object): boolean
    {
        result = false;
        val storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize != 0)
        {
            val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
            var i: int = 0;
            action LOOP_WHILE(
                result != true,
                _containsValue_loop(result, storageCopy, value)
            );
        }
    }


    @Phantom proc _containsValue_loop (result: boolean, storageCopy: map<Object, Map_Entry<Object, Object>>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action OBJECT_EQUALS(curValue, value))
            result = true;
        else
            action MAP_REMOVE(storageCopy, curKey);
    }


    // #note: double loop... Can we avoid this ? too comprehensive realization...
    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMap_Values, c: Collection): boolean
    {
        result = true;
        val storageSize: int = action MAP_SIZE(this.storage);
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []) && result == true,
            _containsAll_loop(result, iter, storageSize)
        );
    }


    @Phantom proc _containsAll_loop (result: boolean, iter: Iterator, storageSize: int): void
    {
        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        val item: Object = action CALL_METHOD(iter, "next", []);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _containsAll_inside_loop(result, storageCopy, item)
        );
    }


    @Phantom proc _containsAll_inside_loop (result: boolean, storageCopy: map<Object, Map_Entry<Object, Object>>, item: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (!action OBJECT_EQUALS(curValue, item))
        {
            result = false;
            action LOOP_BREAK();
        }
        action MAP_REMOVE(storageCopy, curKey);
    }


    @final fun *.forEach (@target self: HashMap_Values, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        val storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize > 0)
        {
            val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
            val expectedModCount: int = HashMapAutomaton(this.parent).modCount;
            var i: int = 0;
            action LOOP_FOR(
                i, 0, storageSize, +1,
                forEach_loop(storageCopy, _action)
            );
            HashMapAutomaton(this.parent)._checkForComodification(expectedModCount);
        }
    }


    @Phantom proc forEach_loop (storageCopy: map<Object, Map_Entry<Object, Object>>, _action: Consumer): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        action CALL(_action, [curValue]);
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_Values): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    @final fun *.iterator (@target self: HashMap_Values): Iterator
    {
        // #question: this is right realization ?
        result = new HashMap_ValueIteratorAutomaton(state = Initialized,
            parent = this.parent,
            storageCopy = action MAP_CLONE(this.storage)
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_Values): Stream
    {
        // #note: temporary decision (we don't support multithreading now)
        // #question: this is right realization ? Or it can be wrong to give such array like an argument to StreamAutomaton ?
        result = new StreamAutomaton(state = Initialized,
            storage = _mapToValuesArray(),
            length = action MAP_SIZE(this.storage),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.remove (@target self: HashMap_Values, value: Object): boolean
    {
        result = false;
        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;

        if (value == null)
        {
            action LOOP_WHILE(
                result != true,
                _removeNull_loop(result, storageCopy, value)
            );
        }
        else
        {
            action LOOP_WHILE(
                result != true,
                _removeValue_loop(result, storageCopy, value)
            );
        }
    }


    @Phantom proc _removeNull_loop (result: boolean, storageCopy: map<Object, Map_Entry<Object, Object>>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (curValue == null)
        {
            action MAP_REMOVE(this.storage, curKey);
            result = true;
        }
        action MAP_REMOVE(storageCopy, curKey);
    }


    @Phantom proc _removeValue_loop (result: boolean, storageCopy: map<Object, Map_Entry<Object, Object>>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action OBJECT_EQUALS(value, curValue))
        {
            action MAP_REMOVE(this.storage, curKey);
            result = true;
        }
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMap_Values, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeAll_loop(storageCopy, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeAll_loop (storageCopy: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action CALL_METHOD(c, "contains", [curValue]))
            action MAP_REMOVE(this.storage, curKey);
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_Values, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeIf_loop(storageCopy, filter)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeIf_loop (storageCopy: map<Object, Map_Entry<Object, Object>>, filter: Predicate): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (action CALL(filter, [curValue]))
            action MAP_REMOVE(this.storage, curKey);
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_Values, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _retainAll_loop(storageCopy, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _retainAll_loop (storageCopy: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        if (!action CALL_METHOD(c, "contains", [curValue]))
            action MAP_REMOVE(this.storage, curKey);
    }


    @final fun *.size (@target self: HashMap_Values): int
    {
        result = action MAP_SIZE(this.storage);
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
            length = action MAP_SIZE(this.storage),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_Values): array<Object>
    {
        val len: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", len);
        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, storageCopy)
        );
    }


    @Phantom proc toArray_loop (i: int, result: array<Object>, storageCopy: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        result[i] = curValue;
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMap_Values, generator: IntFunction): array<Object>
    {
        // acting just like the JDK: trigger NPE and class cast exceptions on invalid generator return value
        val a: array<Object> = action CALL_METHOD(generator, "apply", [0]) as array<Object>;
        val aLen: int = action ARRAY_SIZE(a);

        val len: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", len);
        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, storageCopy)
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_Values, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = action MAP_SIZE(this.storage);

        if (aLen < len)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;
        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, storageCopy)
        );

        // #question: this is correct ?
        if (aLen > len)
            result[len] = null;
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: HashMap_Values): String
    {
        val storageSize: int = action MAP_SIZE(this.storage);
        val arrayValues: array<Object> = action ARRAY_NEW("java.lang.Object", storageSize);
        val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _toString_loop(i, storageCopy, arrayValues)
        );

        result = action OBJECT_TO_STRING(arrayValues);
    }


    @Phantom proc _toString_loop (i: int, storageCopy: map<Object, Map_Entry<Object, Object>>, arrayValues: array<Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(storageCopy, curKey);
        val curValue: Object = action CALL_METHOD(entry, "getValue", []);
        arrayValues[i] = curValue;
        action MAP_REMOVE(storageCopy, curKey);
    }

}
