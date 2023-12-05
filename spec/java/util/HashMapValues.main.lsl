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

automaton HashMapValuesAutomaton
(
    var parent: HashMap,
    var storage: map<Object, Object> = null
)
: HashMapValues
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMapValues,
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
        toArray (HashMapValues),
        toArray (HashMapValues, IntFunction),
        toArray (HashMapValues, array<Object>),
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
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _mapToValuesArray_loop(i, result, storageCopy)
        );
    }


    @Phantom proc _mapToValuesArray_loop (i: int, result: array<Object>, storageCopy: map<Object, Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        result[i] = action MAP_GET(storageCopy, curKey);
        action MAP_REMOVE(storageCopy, curKey);
    }


    // constructors

    @private constructor *.HashMapValues (@target self: HashMapValues, _this: HashMap)
    {
        // #note: default constructor without any body, like in the original class
    }


    // static methods

    // methods

    // within java.util.AbstractCollection
    fun *.add (@target self: HashMapValues, e: Object): boolean
    {
        _throwUOE();
    }


    // within java.util.AbstractCollection
    fun *.addAll (@target self: HashMapValues, c: Collection): boolean
    {
        _throwUOE();
    }


    @final fun *.clear (@target self: HashMapValues): void
    {
        HashMapAutomaton(this.parent).modCount += 1;
        this.storage = action MAP_NEW();
    }


    @final fun *.contains (@target self: HashMapValues, value: Object): boolean
    {
        result = false;
        val storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize != 0)
        {
            val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
            var i: int = 0;
            action LOOP_WHILE(
                result != true,
                _containsValue_loop(result, storageCopy, value)
            );
        }
    }


    @Phantom proc _containsValue_loop (result: boolean, storageCopy: map<Object, Object>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        if (action OBJECT_EQUALS(curValue, value))
            result = true;
        else
            action MAP_REMOVE(storageCopy, curKey);
    }


    // #note: double loop... Can we avoid this ? too comprehensive realization...
    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMapValues, c: Collection): boolean
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
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        val item: Object = action CALL_METHOD(iter, "next", []);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _containsAll_inside_loop(result, storageCopy, item)
        );
    }


    @Phantom proc _containsAll_inside_loop (result: boolean, storageCopy: map<Object, Object>, item: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        if (!action OBJECT_EQUALS(curValue, item))
        {
            result = false;
            action LOOP_BREAK();
        }
        action MAP_REMOVE(storageCopy, curKey);
    }


    @final fun *.forEach (@target self: HashMapValues, _action: Consumer): void
    {
        if (_action == null)
            _throwNPE();

        val storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize > 0)
        {
            val storageClone: map<Object, Object> = action MAP_CLONE(this.storage);
            val expectedModCount: int = HashMapAutomaton(this.parent).modCount;
            var i: int = 0;
            action LOOP_FOR(
                i, 0, storageSize, +1,
                forEach_loop(storageClone, _action)
            );
            HashMapAutomaton(this.parent)._checkForComodification(expectedModCount);
        }
    }


    @Phantom proc forEach_loop (storageClone: map<Object, Object>, _action: Consumer): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageClone);
        val curValue: Object = action MAP_GET(storageClone, curKey);
        action CALL(_action, [curValue]);
        action MAP_REMOVE(storageClone, curKey);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMapValues): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    @final fun *.iterator (@target self: HashMapValues): Iterator
    {
        // #question: this is right realization ?
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        result = new HashMapValueIteratorAutomaton(state = Initialized,
            parent = this.parent,
            storageCopy = storageCopy
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMapValues): Stream
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.remove (@target self: HashMapValues, value: Object): boolean
    {
        result = false;
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
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


    @Phantom proc _removeNull_loop (result: boolean, storageCopy: map<Object, Object>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        if (curValue == null)
        {
            action MAP_REMOVE(this.storage, curKey);
            result = true;
        }
        action MAP_REMOVE(storageCopy, curKey);
    }


    @Phantom proc _removeValue_loop (result: boolean, storageCopy: map<Object, Object>, value: Object): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        if (action OBJECT_EQUALS(value, curValue))
        {
            action MAP_REMOVE(this.storage, curKey);
            result = true;
        }
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMapValues, c: Collection): boolean
    {
        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeAll_loop(storageCopy, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeAll_loop (storageCopy: map<Object, Object>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        if (action CALL_METHOD(c, "contains", [curValue]))
            action MAP_REMOVE(this.storage, curKey);
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMapValues, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeIf_loop(storageCopy, filter)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeIf_loop (storageCopy: map<Object, Object>, filter: Predicate): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        if (action CALL(filter, [curValue]))
            action MAP_REMOVE(this.storage, curKey);
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMapValues, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _retainAll_loop(storageCopy, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _retainAll_loop (storageCopy: map<Object, Object>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        if (!action CALL_METHOD(c, "contains", [curValue]))
                action MAP_REMOVE(this.storage, curKey);
    }


    @final fun *.size (@target self: HashMapValues): int
    {
        result = action MAP_SIZE(this.storage);
    }


    @final fun *.spliterator (@target self: HashMapValues): Spliterator
    {
        val valuesArray: array<Object, Object> = _mapToValuesArray();
        result = new HashMapValueSpliteratorAutomaton(state=Initialized,
            valuesStorage = valuesArray,
            index = 0,
            fence = -1,
            est = 0,
            expectedModCount = HashMapAutomaton(this.parent).modCount,
            parent = this.parent
        );
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMapValues): Stream
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMapValues): array<Object>
    {
        val len: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", len);
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, storageCopy)
        );
    }


    @Phantom proc toArray_loop (i: int, result: array<Object>, storageCopy: map<Object, Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        result[i] = curValue;
        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMapValues, generator: IntFunction): array<Object>
    {
        // acting just like the JDK: trigger NPE and class cast exceptions on invalid generator return value
        val a: array<Object> = action CALL_METHOD(generator, "apply", [0]) as array<Object>;
        val aLen: int = action ARRAY_SIZE(a);

        val len: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", len);
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, storageCopy)
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMapValues, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = action MAP_SIZE(this.storage);

        if (aLen < len)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);

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
    fun *.toString (@target self: HashMapValues): String
    {
        val storageSize: int = action MAP_SIZE(this.storage);
        val arrayValues: array<Object> = action ARRAY_NEW("java.lang.Object", storageSize);
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _toString_loop(i, storageCopy, arrayValues)
        );

        result = action OBJECT_TO_STRING(arrayValues);
    }


    @Phantom proc _toString_loop (i: int, storageCopy: map<Object, Object>, arrayValues: array<Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val curValue: Object = action MAP_GET(storageCopy, curKey);
        arrayValues[i] = curValue;
        action MAP_REMOVE(storageCopy, curKey);
    }

}
