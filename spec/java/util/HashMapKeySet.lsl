libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$KeySet.java";

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

automaton KeySetAutomaton
(
    var storage: map<Object, Object>,
    var parent: HashMap
)
: HashMap_KeySet
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMap_KeySet,
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


    // constructors

    @private constructor *.HashMap_KeySet (@target self: HashMap_KeySet, _this: HashMap)
    {
        action TODO();
    }


    // static methods

    // methods

    // within java.util.AbstractCollection
    fun *.add (@target self: HashMap_KeySet, e: Object): boolean
    {
        _throwUOE();
    }


    // within java.util.AbstractCollection
    fun *.addAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        _throwUOE();
    }


    @final fun *.clear (@target self: HashMap_KeySet): void
    {
        HashMapAutomaton(this.parent).modCount += 1;
        this.storage = action MAP_NEW();
    }


    @final fun *.contains (@target self: HashMap_KeySet, key: Object): boolean
    {
        if (action MAP_SIZE(this.storage) == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storage, key);
    }


    // within java.util.AbstractCollection
    fun *.containsAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        action TODO();
    }


    // within java.util.AbstractSet
    fun *.equals (@target self: HashMap_KeySet, o: Object): boolean
    {
        action TODO();
    }


    @final fun *.forEach (@target self: HashMap_KeySet, _action: Consumer): void
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
        action CALL(_action, [curKey]);
        action MAP_REMOVE(storageClone, curKey);
    }


    // within java.util.AbstractSet
    fun *.hashCode (@target self: HashMap_KeySet): int
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_KeySet): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    @final fun *.iterator (@target self: HashMap_KeySet): Iterator
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_KeySet): Stream
    {
        action TODO();
    }


    @final fun *.remove (@target self: HashMap_KeySet, key: Object): boolean
    {
        result = false;
        if (action MAP_HAS_KEY(this.storage, key))
        {
            action MAP_REMOVE(this.storage, key);
            HashMapAutomaton(this.parent).modCount += 1;
            result = true;
        }
    }


    // within java.util.AbstractCollection
    fun *.removeAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_KeySet, filter: Predicate): boolean
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        action TODO();
    }


    @final fun *.size (@target self: HashMap_KeySet): int
    {
        result = action MAP_SIZE(this.storage);
    }


    @final fun *.spliterator (@target self: HashMap_KeySet): Spliterator
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMap_KeySet): Stream
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_KeySet): array<Object>
    {
        action TODO();
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMap_KeySet, generator: IntFunction): array<Object>
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_KeySet, a: array<Object>): array<Object>
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.toString (@target self: HashMap_KeySet): String
    {
        action TODO();
    }

}