libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$EntrySet.java";

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

automaton HashMap_EntrySetAutomaton
(
)
: HashMap_EntrySet
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMap_EntrySet,
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

    // constructors

    @private constructor *.HashMap_EntrySet (@target self: HashMap_EntrySet, _this: HashMap)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.util.AbstractCollection
    fun *.add (@target self: HashMap_EntrySet, e: Object): boolean
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.addAll (@target self: HashMap_EntrySet, c: Collection): boolean
    {
        action TODO();
    }


    @final fun *.clear (@target self: HashMap_EntrySet): void
    {
        action TODO();
    }


    @final fun *.contains (@target self: HashMap_EntrySet, o: Object): boolean
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMap_EntrySet, c: Collection): boolean
    {
        action TODO();
    }


    // within java.util.AbstractSet
    fun *.equals (@target self: HashMap_EntrySet, o: Object): boolean
    {
        action TODO();
    }


    @final fun *.forEach (@target self: HashMap_EntrySet, _action: Consumer): void
    {
        action TODO();
    }


    // within java.util.AbstractSet
    fun *.hashCode (@target self: HashMap_EntrySet): int
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_EntrySet): boolean
    {
        action TODO();
    }


    @final fun *.iterator (@target self: HashMap_EntrySet): Iterator
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_EntrySet): Stream
    {
        action TODO();
    }


    @final fun *.remove (@target self: HashMap_EntrySet, o: Object): boolean
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMap_EntrySet, c: Collection): boolean
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_EntrySet, filter: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_EntrySet, c: Collection): boolean
    {
        action TODO();
    }


    @final fun *.size (@target self: HashMap_EntrySet): int
    {
        action TODO();
    }


    @final fun *.spliterator (@target self: HashMap_EntrySet): Spliterator
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMap_EntrySet): Stream
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_EntrySet): array<Object>
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMap_EntrySet, generator: IntFunction): array<Object>
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_EntrySet, a: array<Object>): array<Object>
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: HashMap_EntrySet): String
    {
        action TODO();
    }

}