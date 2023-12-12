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

automaton HashMap_KeySetAutomaton
(
    var storage: map<Object, Map_Entry<Object, Object>>,
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


    proc _mapToKeysArray (): array<Object>
    {
        val storageSize: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _mapToKeysArray_loop(i, result, unseen)
        );
    }


    @Phantom proc _mapToKeysArray_loop (i: int, result: array<Object>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        result[i] = curKey;
        action MAP_REMOVE(unseen, curKey);
    }


    // constructors

    @private constructor *.HashMap_KeySet (@target self: HashMap_KeySet, _this: HashMap)
    {
        // #note: default constructor without any body, like in the original class
    }


    // static methods

    // methods

    // within java.util.AbstractCollection
    fun *.add (@target self: HashMap_KeySet, e: Object): boolean
    {
        if (true)
            _throwUOE();
    }


    // within java.util.AbstractCollection
    fun *.addAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        if ( true)
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
        result = true;
        val iter: Iterator = action CALL_METHOD(c, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []) && result == true,
            _containsAll_loop(result, iter)
        );
    }


    @Phantom proc _containsAll_loop (result: boolean, iter: Iterator): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        result = action MAP_HAS_KEY(this.storage, item);
    }


    // within java.util.AbstractSet
    fun *.equals (@target self: HashMap_KeySet, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            val isSameType: boolean = action OBJECT_SAME_TYPE(self, other);
            if (isSameType)
            {
                // #question: do wee need checking of modifications here ? Or not ? (As I can see - not)
                val otherStorage: map<Object, Map_Entry<Object, Object>> = HashMap_KeySetAutomaton(other).storage;
                val otherLength: int = action MAP_SIZE(otherStorage);
                val thisLength: int = action MAP_SIZE(this.storage);

                if (thisLength == otherLength)
                    result = action OBJECT_EQUALS(this.storage, otherStorage);
                else
                    result = false;
            }
            else
            {
                result = false;
            }
        }
    }


    @final fun *.forEach (@target self: HashMap_KeySet, userAction: Consumer): void
    {
        if (userAction == null)
            _throwNPE();

        val storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize > 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
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
        action CALL(userAction, [curKey]);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractSet
    fun *.hashCode (@target self: HashMap_KeySet): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    // within java.util.AbstractCollection
    fun *.isEmpty (@target self: HashMap_KeySet): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    @final fun *.iterator (@target self: HashMap_KeySet): Iterator
    {
        // #question: this is right realization ?
        result = new HashMap_KeyIteratorAutomaton(state = Initialized,
            parent = this.parent,
            unseen = action MAP_CLONE(this.storage)
        );
    }


    // within java.util.Collection
    fun *.parallelStream (@target self: HashMap_KeySet): Stream
    {
        // #note: temporary decision (we don't support multithreading now)
        // #question: this is right realization ? Or it can be wrong to give such array like an argument to StreamAutomaton ?
        result = new StreamAutomaton(state = Initialized,
            storage = _mapToKeysArray(),
            length = action MAP_SIZE(this.storage),
            closeHandlers = action LIST_NEW()
        );
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
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeAll_loop(unseen, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        if (action CALL_METHOD(c, "contains", [curKey]))
            action MAP_REMOVE(this.storage, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.Collection
    fun *.removeIf (@target self: HashMap_KeySet, filter: Predicate): boolean
    {
        if (filter == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _removeIf_loop(unseen, filter)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _removeIf_loop (unseen: map<Object, Map_Entry<Object, Object>>, filter: Predicate): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        if (action CALL(filter, [curKey]))
            action MAP_REMOVE(this.storage, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.AbstractCollection
    fun *.retainAll (@target self: HashMap_KeySet, c: Collection): boolean
    {
        if (c == null)
            _throwNPE();

        result = false;
        val startStorageSize: int = action MAP_SIZE(this.storage);

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, startStorageSize, +1,
            _retainAll_loop(unseen, c)
        );

        val resultStorageSize: int = action MAP_SIZE(this.storage);
        result = startStorageSize == resultStorageSize;
    }


    @Phantom proc _retainAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, c: Collection): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        if (!action CALL_METHOD(c, "contains", [curKey]))
            action MAP_REMOVE(this.storage, curKey);
        action MAP_REMOVE(unseen, curKey);
    }


    @final fun *.size (@target self: HashMap_KeySet): int
    {
        result = action MAP_SIZE(this.storage);
    }


    @final fun *.spliterator (@target self: HashMap_KeySet): Spliterator
    {
        // #question: This will be correct or not to create copy of references ? I suppose it can be incorrect for type Integer for example
        result = new HashMap_KeySpliteratorAutomaton(state=Initialized,
            keysStorage = _mapToKeysArray(),
            parent = this.parent
        );
    }


    // within java.util.Collection
    fun *.stream (@target self: HashMap_KeySet): Stream
    {
        // #question: this is right realization ? Or it can be wrong to give such array like an argument to StreamAutomaton ?
        result = new StreamAutomaton(state = Initialized,
            storage = _mapToKeysArray(),
            length = action MAP_SIZE(this.storage),
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_KeySet): array<Object>
    {
        val len: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", len);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, unseen)
        );
    }


    @Phantom proc toArray_loop (i: int, result: array<Object>, unseen: map<Object, Map_Entry<Object, Object>>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        result[i] = curKey;
        action MAP_REMOVE(unseen, curKey);
    }


    // within java.util.Collection
    fun *.toArray (@target self: HashMap_KeySet, generator: IntFunction): array<Object>
    {
        // acting just like the JDK: trigger NPE and class cast exceptions on invalid generator return value
        val a: array<Object> = action CALL_METHOD(generator, "apply", [0]) as array<Object>;
        val aLen: int = action ARRAY_SIZE(a);

        val len: int = action MAP_SIZE(this.storage);
        result = action ARRAY_NEW("java.lang.Object", len);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            toArray_loop(i, result, unseen)
        );
    }


    // within java.util.AbstractCollection
    fun *.toArray (@target self: HashMap_KeySet, a: array<Object>): array<Object>
    {
        val aLen: int = action ARRAY_SIZE(a);
        val len: int = action MAP_SIZE(this.storage);

        if (aLen < len)
            a = action ARRAY_NEW("java.lang.Object", len);

        result = a;
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);

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
    fun *.toString (@target self: HashMap_KeySet): String
    {
        val storageSize: int = action MAP_SIZE(this.storage);
        val arrayKeys: array<Object> = action ARRAY_NEW("java.lang.Object", storageSize);
        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        var i: int = 0;
        action LOOP_FOR(
            i, 0, storageSize, +1,
            _toString_loop(i, unseen, arrayKeys)
        );

        result = action OBJECT_TO_STRING(arrayKeys);
    }


    @Phantom proc _toString_loop (i: int, unseen: map<Object, Map_Entry<Object, Object>>, arrayKeys: array<Object>): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);
        arrayKeys[i] = curKey;
        action MAP_REMOVE(unseen, curKey);
    }

}