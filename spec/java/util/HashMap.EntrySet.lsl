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
import java/util/Map;


// automata

automaton HashMap_EntrySetAutomaton
(
    var storage: map<Object, Map_Entry<Object, Object>>,
    var parent: HashMap
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

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @AutoInline @Phantom proc _throwUOE (): void
    {
        action THROW_NEW("java.lang.UnsupportedOperationException", []);
    }


    // constructors

    @private constructor *.HashMap_EntrySet (@target self: HashMap_EntrySet, _this: HashMap)
    {
        // #note: default constructor without any body, like in the original class
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
        this.storage = action MAP_NEW();
    }


    @final fun *.contains (@target self: HashMap_EntrySet, o: Object): boolean
    {
        result = false;
        if (o is Map_Entry)
        {
            val entryParam: Map_Entry<Object, Object> = o as Map_Entry<Object, Object>;
            val key: Object = action CALL_METHOD(entryParam, "getKey", []);
            val value: Object = action CALL_METHOD(entryParam, "getValue", []);
            val hasKey: boolean = action MAP_HAS_KEY(this.storage, key);
            var entryStorage: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);
            // #question: this is right realization ? Or better to make entries equals ?
            val valuesEquals: boolean = action OBJECT_EQUALS(value, action CALL_METHOD(entryStorage, "getValue", []));
            result = hasKey && valuesEquals;
        }
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


    @final fun *.forEach (@target self: HashMap_EntrySet, userAction: Consumer): void
    {
        if (userAction == null)
            _throwNPE();

        val storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize > 0)
        {
            val storageCopy: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
            val expectedModCount: int = HashMapAutomaton(this.parent).modCount;
            var i: int = 0;
            action LOOP_FOR(
                i, 0, storageSize, +1,
                forEach_loop(storageCopy, userAction)
            );
            HashMapAutomaton(this.parent)._checkForComodification(expectedModCount);
        }
    }


    @Phantom proc forEach_loop (storageCopy: map<Object, Map_Entry<Object, Object>>, userAction: Consumer): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(storageCopy);
        val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, curKey);

        action CALL(userAction, [entry]);

        action MAP_REMOVE(storageCopy, curKey);
    }


    // within java.util.AbstractSet
    fun *.hashCode (@target self: HashMap_EntrySet): int
    {
        action TODO();
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_EntrySet): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
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
        result = false;
        if (o is Map_Entry)
        {
            val entryParam: Map_Entry = o as Map_Entry;
            val key: Object = action CALL_METHOD(entryParam, "getKey", []);
            val value: Object = action CALL_METHOD(entryParam, "getValue", []);
            if (action MAP_HAS_KEY(this.storage, key))
            {
                val entryStorage: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);
                val actualValue: Object = action CALL_METHOD(entryStorage, "getValue", []);
                if (action OBJECT_EQUALS(value, actualValue))
                {
                    action MAP_REMOVE(this.storage, key);
                    result = true;
                }
            }
        }
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
        result = action MAP_SIZE(this.storage);
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