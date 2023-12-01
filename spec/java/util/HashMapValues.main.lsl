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
    fun *.remove (@target self: HashMapValues, o: Object): boolean
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMapValues, c: Collection): boolean
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMapValues, filter: Predicate): boolean
    {
        action TODO();
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
        action TODO();
    }

}
