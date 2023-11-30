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

automaton HashMapAutomaton
(
    var storage: map<Object, Object> = null,
    @transient var length: int = 0
)
: HashMap
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMap (HashMap),
        HashMap (HashMap, Map),
        HashMap (HashMap, int),
        HashMap (HashMap, int, float),
    ];

    shift Initialized -> self by [
        // instance methods
        clear,
        clone,
        compute,
        computeIfAbsent,
        computeIfPresent,
        containsKey,
        containsValue,
        entrySet,
        equals,
        forEach,
        get,
        getOrDefault,
        hashCode,
        isEmpty,
        keySet,
        merge,
        put,
        putAll,
        putIfAbsent,
        remove (HashMap, Object),
        remove (HashMap, Object, Object),
        replace (HashMap, Object, Object),
        replace (HashMap, Object, Object, Object),
        replaceAll,
        size,
        toString,
        values,
    ];

    // internal variables

    @transient var modCount: int = 0;


    // utilities

    @AutoInline @Phantom proc _throwIAE (): void
    {
        action THROW_NEW("java.lang.IllegalArgumentException", []);
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _addAllElements (m: Map): void
    {
        val entrySet: Set = action CALL_METHOD(m, "entrySet", []);
        val iter: Iterator = action CALL_METHOD(entrySet, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _addAllElements_loop(iter)
        );
    }


    @Phantom proc _addAllElements_loop (iter: Iterator): void
    {
        val entry: Map_Entry = action CALL_METHOD(iter, "next", []) as Map_Entry;
        val key: Object = action CALL_METHOD(entry, "getKey", []);
        val value: Object = action CALL_METHOD(entry, "getValue", []);
        // #note: maybe it will be needed checking "val hasKey: boolean = action MAP_HAS_KEY(this.storage, key);"
        action MAP_SET(this.storage, key, value);
        this.length += 1;
        this.modCount += 1;
    }


    @KeepVisible proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    proc _getMappingOrDefault (key: Object, defaultValue: Object): Object
    {
        if (action MAP_HAS_KEY(this.storage, key))
            result = action MAP_GET(this.storage, key);
        else
            result = defaultValue;
    }


    // constructors

    constructor *.HashMap (@target self: HashMap)
    {
        this.storage = action MAP_NEW();
    }


    constructor *.HashMap (@target self: HashMap, m: Map)
    {
        this.storage = action MAP_NEW();
        _addAllElements(m);
    }


    constructor *.HashMap (@target self: HashMap, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            //val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            _throwIAE();
        }

        this.storage = action MAP_NEW();
    }


    constructor *.HashMap (@target self: HashMap, initialCapacity: int, loadFactor: float)
    {
        if (initialCapacity < 0)
        {
            //val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            _throwIAE();
        }
        if (loadFactor <= 0 || loadFactor != loadFactor)
        {
            // val loadFactorStr: String = "Illegal load factor: " + action OBJECT_TO_STRING(loadFactor);
            _throwIAE();
        }
        this.storage = action MAP_NEW();
    }


    // static methods

    // methods

    fun *.clear (@target self: HashMap): void
    {
        this.modCount += 1;
        this.length = 0;
        this.storage = action MAP_NEW();
    }


    fun *.clone (@target self: HashMap): Object
    {
        val storageCopy: map<Object, Object> = action MAP_CLONE(this.storage);
        result = new HashMapAutomaton(state = Initialized,
            storage = storageCopy,
            length = this.length
        );
    }


    fun *.compute (@target self: HashMap, key: Object, remappingFunction: BiFunction): Object
    {
        if (remappingFunction == null)
            _throwNPE();

        val oldValue: Object = action MAP_GET(this.storage, key);
        val expectedModCount: int = this.modCount;

        val newValue: Object = action CALL(remappingFunction, [key, oldValue]);
        _checkForComodification(expectedModCount);

        if (newValue == null)
            action MAP_REMOVE(this.storage, key);
        else
            action MAP_SET(this.storage, key, newValue);

        result = newValue;
    }


    fun *.computeIfAbsent (@target self: HashMap, key: Object, mappingFunction: Function): Object
    {
        if (mappingFunction == null)
            _throwNPE();

        val oldValue: Object = action MAP_GET(this.storage, key);
        if (oldValue != null)
        {
            result = oldValue;
        }
        else
        {
            val expectedModCount: int = this.modCount;
            val newValue: Object = action CALL(mappingFunction, [key]);
            _checkForComodification(expectedModCount);
            if (newValue != null)
                action MAP_SET(this.storage, key, newValue);
            result = newValue;
        }

    }


    fun *.computeIfPresent (@target self: HashMap, key: Object, remappingFunction: BiFunction): Object
    {
        if (remappingFunction == null)
            _throwNPE();

        val oldValue: Object = action MAP_GET(this.storage, key);
        if (oldValue == null)
        {
            result = oldValue;
        }
        else
        {
            val expectedModCount: int = this.modCount;
            val newValue: Object = action CALL(remappingFunction, [key, oldValue]);
            _checkForComodification(expectedModCount);
            if (newValue == null)
                action MAP_REMOVE(this.storage, key);
            else
                action MAP_SET(this.storage, key, newValue);
            result = newValue;
        }
    }


    fun *.containsKey (@target self: HashMap, key: Object): boolean
    {
        if (this.length == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storage, key);
    }


    fun *.containsValue (@target self: HashMap, value: Object): boolean
    {
        result = false;
        if (this.length != 0)
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


    fun *.entrySet (@target self: HashMap): Set
    {
        action TODO();
    }


    // within java.util.AbstractMap
    fun *.equals (@target self: HashMap, other: Object): boolean
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
                val expectedModCount: int = this.modCount;
                val otherExpectedModCount: int = HashMapAutomaton(other).modCount;

                val otherStorage: map<Object, Object> = HashSetAutomaton(other).storage;
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


    fun *.forEach (@target self: HashMap, _action: BiConsumer): void
    {
        action TODO();
    }


    fun *.get (@target self: HashMap, key: Object): Object
    {
        action TODO();
    }


    fun *.getOrDefault (@target self: HashMap, key: Object, defaultValue: Object): Object
    {
        action TODO();
    }


    // within java.util.AbstractMap
    fun *.hashCode (@target self: HashMap): int
    {
        // #question: Can we make such realization ? Or we need such realization: "result = hKey ^ hValue;" ?
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.isEmpty (@target self: HashMap): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    fun *.keySet (@target self: HashMap): Set
    {
        action TODO();
    }


    fun *.merge (@target self: HashMap, key: Object, value: Object, remappingFunction: BiFunction): Object
    {
        action TODO();
    }


    fun *.put (@target self: HashMap, key: Object, value: Object): Object
    {
        if (action MAP_HAS_KEY(this.storage, key))
            result = action MAP_GET(this.storage, key);
        else
            result = null;
        action MAP_SET(this.storage, key, value);
        this.modCount += 1;
    }


    fun *.putAll (@target self: HashMap, m: Map): void
    {
        if (m == null)
            _throwNPE();

        val mSize: int = action CALL_METHOD(m, "size", []);
        if (mSize != 0)
            _addAllElements(m);
    }


    fun *.putIfAbsent (@target self: HashMap, key: Object, value: Object): Object
    {
        result = _getMappingOrDefault(key, null);
        if (result == null)
        {
            action MAP_SET(this.storage, key, value);
            this.modCount += 1;
        }
    }


    fun *.remove (@target self: HashMap, key: Object): Object
    {
        action TODO();
    }


    fun *.remove (@target self: HashMap, key: Object, value: Object): boolean
    {
        action TODO();
    }


    fun *.replace (@target self: HashMap, key: Object, value: Object): Object
    {
        action TODO();
    }


    fun *.replace (@target self: HashMap, key: Object, oldValue: Object, newValue: Object): boolean
    {
        action TODO();
    }


    fun *.replaceAll (@target self: HashMap, function: BiFunction): void
    {
        action TODO();
    }


    fun *.size (@target self: HashMap): int
    {
        result = action MAP_SIZE(this.storage);
    }


    // within java.util.AbstractMap
    fun *.toString (@target self: HashMap): String
    {
        // #question: Can we make such realization ? Or we need such realization: "key + "=" + value" ?
        result = action OBJECT_TO_STRING(this.storage);
    }


    fun *.values (@target self: HashMap): Collection
    {
        action TODO();
    }

}