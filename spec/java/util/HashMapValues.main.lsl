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


// automata

automaton HashMapValuesAutomaton
(
    var storage: map<Object, Object> = null,
    @transient var length: int = 0
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


    // constructors

    @private constructor *.HashMapValues (@target self: HashMapValues, _this: HashMap)
    {
        action TODO();
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
        action TODO();
    }


    @final fun *.contains (@target self: HashMapValues, o: Object): boolean
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMapValues, c: Collection): boolean
    {
        action TODO();
    }


    @final fun *.forEach (@target self: HashMapValues, _action: Consumer): void
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMapValues): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    @final fun *.iterator (@target self: HashMapValues): Iterator
    {
        action TODO();
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
        action TODO();
    }


    @final fun *.size (@target self: HashMapValues): int
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    @final fun *.spliterator (@target self: HashMapValues): Spliterator
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMapValues): Stream
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMapValues): array<Object>
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMapValues, generator: IntFunction): array<Object>
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMapValues, a: array<Object>): array<Object>
    {
        action TODO();
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
