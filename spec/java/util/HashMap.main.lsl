//#! pragma: target=java
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

automaton HashMapAutomaton
(
    var storage: map<Object, Map_Entry<Object, Object>>
)
: HashMap
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (HashMap),
        `<init>` (HashMap, Map),
        `<init>` (HashMap, int),
        `<init>` (HashMap, int, float),
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


    @AutoInline @Phantom proc _addAllElements (m: Map): void
    {
        val entrySet: Set<Map_Entry<Object, Object>> = action CALL_METHOD(m, "entrySet", []) as Set<Map_Entry<Object, Object>>;
        val iter: Iterator<Map_Entry<Object, Object>> = action CALL_METHOD(entrySet, "iterator", []);

        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            _addAllElements_loop(iter)
        );
    }

    @Phantom proc _addAllElements_loop (iter: Iterator<Map_Entry<Object, Object>>): void
    {
        val oEntry: Map_Entry<Object, Object> = action CALL_METHOD(iter, "next", []);
        val key: Object = action CALL_METHOD(oEntry, "getKey", []);
        val value: Object = action CALL_METHOD(oEntry, "getValue", []);

        var entry: Map_Entry<Object, Object> = null;
        if (action MAP_HAS_KEY(this.storage, key))
        {
            entry = action MAP_GET(this.storage, key);
            AbstractMap_SimpleEntryAutomaton(entry).value = value;
        }
        else
        {
            entry = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
                key = key,
                value = value
            );
            action MAP_SET(this.storage, key, entry);
        }

        this.modCount += 1;
    }


    @KeepVisible proc _checkForComodification (expectedModCount: int): void
    {
        if (this.modCount != expectedModCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    @AutoInline @Phantom proc _getMappingOrDefault (key: Object, defaultValue: Object): Object
    {
        if (action MAP_HAS_KEY(this.storage, key))
        {
            val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);
            result = AbstractMap_SimpleEntryAutomaton(entry).value;
        }
        else
        {
            result = defaultValue;
        }
    }


    // constructors

    constructor *.`<init>` (@target self: HashMap)
    {
        this.storage = action MAP_NEW();
    }


    constructor *.`<init>` (@target self: HashMap, m: Map)
    {
        this.storage = action MAP_NEW();

        _addAllElements(m); // inlined!
    }


    constructor *.`<init>` (@target self: HashMap, initialCapacity: int)
    {
        if (initialCapacity < 0)
        {
            //val initCapStr: String = "Illegal initial capacity: " + action OBJECT_TO_STRING(initialCapacity);
            _throwIAE();
        }

        this.storage = action MAP_NEW();
    }


    constructor *.`<init>` (@target self: HashMap, initialCapacity: int, loadFactor: float)
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
        this.storage = action MAP_NEW();
    }


    fun *.clone (@target self: HashMap): Object
    {
        val otherStorage: map<Object, Map_Entry<Object, Object>> = action MAP_NEW();

        result = new HashMapAutomaton(state = Initialized,
            storage = otherStorage,
        );

        val size: int = action MAP_SIZE(this.storage);
        if (size != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);

            var c: int = 0;
            action LOOP_FOR(
                c, size, 0, -1,
                clone_loop(unseen, otherStorage)
            );
        }
    }

    @Phantom proc clone_loop (unseen: map<Object, Map_Entry<Object, Object>>, otherStorage: map<Object, Map_Entry<Object, Object>>): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseen);

        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, key);
        val value: Object = AbstractMap_SimpleEntryAutomaton(entry).value;

        val otherEntry: Map_Entry<Object, Object> = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
            key = key,
            value = value,
        );
        action MAP_SET(otherStorage, key, otherEntry);

        action MAP_REMOVE(unseen, key);
    }


    fun *.compute (@target self: HashMap, key: Object, remappingFunction: BiFunction): Object
    {
        if (remappingFunction == null)
            _throwNPE();

        var oldValue: Object = null;
        var entry: Map_Entry<Object, Object> = null;

        if (action MAP_HAS_KEY(this.storage, key))
        {
            entry = action MAP_GET(this.storage, key);
            oldValue = AbstractMap_SimpleEntryAutomaton(entry).value;
        }

        val expectedModCount: int = this.modCount;

        val newValue: Object = action CALL(remappingFunction, [key, oldValue]);
        _checkForComodification(expectedModCount);

        if (newValue == null)
        {
            action MAP_REMOVE(this.storage, key);
        }
        else
        {
            if (entry != null)
            {
                AbstractMap_SimpleEntryAutomaton(entry).value = newValue;
            }
            else
            {
                entry = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
                    key = key,
                    value = newValue
                );
                action MAP_SET(this.storage, key, entry);
            }
        }

        result = newValue;
    }


    fun *.computeIfAbsent (@target self: HashMap, key: Object, mappingFunction: Function): Object
    {
        if (mappingFunction == null)
            _throwNPE();

        var oldValue: Object = null;
        var entry: Map_Entry<Object, Object> = null;

        if (action MAP_HAS_KEY(this.storage, key))
        {
            entry = action MAP_GET(this.storage, key);
            oldValue = AbstractMap_SimpleEntryAutomaton(entry).value;
        }

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
            {
                if (entry != null)
                {
                    AbstractMap_SimpleEntryAutomaton(entry).value = newValue;
                }
                else
                {
                    entry = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
                        key = key,
                        value = newValue
                    );
                    action MAP_SET(this.storage, key, entry);
                }
            }
            result = newValue;
        }

    }


    fun *.computeIfPresent (@target self: HashMap, key: Object, remappingFunction: BiFunction): Object
    {
        if (remappingFunction == null)
            _throwNPE();

        var oldValue: Object = null;
        var entry: Map_Entry<Object, Object> = null;

        if (action MAP_HAS_KEY(this.storage, key))
        {
            entry = action MAP_GET(this.storage, key);
            oldValue = AbstractMap_SimpleEntryAutomaton(entry).value;
        }

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
            {
                action MAP_REMOVE(this.storage, key);
            }
            else
            {
                if (entry != null)
                {
                    AbstractMap_SimpleEntryAutomaton(entry).value = newValue;
                }
                else
                {
                    entry = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
                        key = key,
                        value = newValue
                    );
                    action MAP_SET(this.storage, key, entry);
                }
            }
            result = newValue;
        }
    }


    fun *.containsKey (@target self: HashMap, key: Object): boolean
    {
        if (action MAP_SIZE(this.storage) == 0)
            result = false;
        else
            result = action MAP_HAS_KEY(this.storage, key);
    }


    fun *.containsValue (@target self: HashMap, value: Object): boolean
    {
        result = false;
        var storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize != 0)
        {
            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
            action LOOP_WHILE(
                result != true && storageSize != 0,
                contains_loop(result, unseen, value, storageSize)
            );
        }
    }


    @Phantom proc contains_loop (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, value: Object, storageSize: int): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);

        val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (action OBJECT_EQUALS(curValue, value))
            result = true;

        action MAP_REMOVE(unseen, curKey);
        storageSize -= 1;
    }


    fun *.entrySet (@target self: HashMap): Set
    {
        result = new HashMap_EntrySetAutomaton(state = Initialized,
            storageRef = this.storage,
            parent = self
        );
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
            result = false;

            if (other is Map)
            {
                val m: Map<Object, Object> = other as Map<Object, Object>;
                var thisLength: int = action MAP_SIZE(this.storage);

                if (thisLength == action CALL_METHOD(m, "size", []))
                {
                    action TRY_CATCH(
                        equals_try(result, m, thisLength),
                        [
                            ["java.lang.ClassCastException",   equals_catch(result)],
                            ["java.lang.NullPointerException", equals_catch(result)],
                        ]
                    );
                }
            }
        }
    }

    @Phantom proc equals_try (result: boolean, m: Map<Object, Object>, thisLength: int): void
    {
        result = true;

        val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
        action LOOP_WHILE(
            result && thisLength != 0,
            equals_try_loop(result, unseen, m, thisLength)
        );
    }

    @Phantom proc equals_try_loop (result: boolean, unseen: map<Object, Map_Entry<Object, Object>>, m: Map<Object, Object>, thisLength: int): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseen);

        val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);
        val value: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
        if (value == null)
        {
            if (action CALL_METHOD(m, "get", [key]) != null)
                result = false;
            else if (action CALL_METHOD(m, "containsKey", [key]) == false)
                result = false;
        }
        else
        {
            result = action OBJECT_EQUALS(value, action CALL_METHOD(m, "get", [key]));
        }

        action MAP_REMOVE(unseen, key);
        thisLength -= 1;
    }

    @Phantom proc equals_catch (result: boolean): void
    {
        result = false;
    }


    fun *.forEach (@target self: HashMap, userAction: BiConsumer): void
    {
        if (userAction == null)
            _throwNPE();

        val storageSize: int = action MAP_SIZE(this.storage);
        if (storageSize > 0)
        {
            val expectedModCount: int = this.modCount;

            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, storageSize, +1,
                forEach_loop(unseen, userAction)
            );

            _checkForComodification(expectedModCount);
        }
    }


    @Phantom proc forEach_loop (unseen: map<Object, Map_Entry<Object, Object>>, userAction: BiConsumer): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(unseen);

        val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, curKey);
        val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;

        action CALL(userAction, [curKey, curValue]);

        action MAP_REMOVE(unseen, curKey);
    }


    fun *.get (@target self: HashMap, key: Object): Object
    {
        val defaultValue: Object = null;
        _getMappingOrDefault(key, defaultValue); // auto-inlined!
    }


    fun *.getOrDefault (@target self: HashMap, key: Object, defaultValue: Object): Object
    {
        _getMappingOrDefault(key, defaultValue); // auto-inlined!
    }


    // within java.util.AbstractMap
    fun *.hashCode (@target self: HashMap): int
    {
        result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.isEmpty (@target self: HashMap): boolean
    {
        result = action MAP_SIZE(this.storage) == 0;
    }


    fun *.keySet (@target self: HashMap): Set
    {
        result = new HashMap_KeySetAutomaton(state = Initialized,
            storageRef = this.storage,
            parent = self
        );
    }


    fun *.merge (@target self: HashMap, key: Object, value: Object, remappingFunction: BiFunction): Object
    {
        if (value == null)
            _throwNPE();
        if (remappingFunction == null)
            _throwNPE();

        var entry: Map_Entry<Object, Object> = null;
        if (action MAP_HAS_KEY(this.storage, key))
        {
            entry = action MAP_GET(this.storage, key);

            val oldValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
            if (oldValue == null)
            {
                result = value;
            }
            else
            {
                val expectedModCount: int = this.modCount;
                result = action CALL(remappingFunction, [oldValue, value]);
                _checkForComodification(expectedModCount);
            }

            if (result == null)
                action MAP_REMOVE(this.storage, key);
            else
                AbstractMap_SimpleEntryAutomaton(entry).value = result;
        }
        else
        {
            entry = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
                key = key,
                value = value
            );
            action MAP_SET(this.storage, key, entry);
            this.modCount += 1;

            result = value;
        }
    }


    fun *.put (@target self: HashMap, key: Object, value: Object): Object
    {
        result = null;

        var entry: Map_Entry<Object, Object> = null;
        if (action MAP_HAS_KEY(this.storage, key))
        {
            entry = action MAP_GET(this.storage, key);

            result = AbstractMap_SimpleEntryAutomaton(entry).value;

            AbstractMap_SimpleEntryAutomaton(entry).value = value;
        }
        else
        {
            entry = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
                key = key,
                value = value
            );
            action MAP_SET(this.storage, key, entry);
        }

        this.modCount += 1;
    }


    fun *.putAll (@target self: HashMap, m: Map): void
    {
        if (m == null)
            _throwNPE();

        _addAllElements(m); // inlined!
    }


    fun *.putIfAbsent (@target self: HashMap, key: Object, value: Object): Object
    {
        var entry: Map_Entry<Object, Object> = null;

        if (action MAP_HAS_KEY(this.storage, key))
        {
            entry = action MAP_GET(this.storage, key);
            result = AbstractMap_SimpleEntryAutomaton(entry).value;
        }
        else
        {
            result = null;
            entry = new AbstractMap_SimpleEntryAutomaton(state = Initialized,
                key = key,
                value = value
            );
            action MAP_SET(this.storage, key, entry);
            this.modCount += 1;
        }
    }


    fun *.remove (@target self: HashMap, key: Object): Object
    {
        if (action MAP_HAS_KEY(this.storage, key))
        {
            val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);

            result = AbstractMap_SimpleEntryAutomaton(entry).value;

            action MAP_REMOVE(this.storage, key);
            this.modCount += 1;
        }
        else
        {
            result = null;
        }
    }


    fun *.remove (@target self: HashMap, key: Object, value: Object): boolean
    {
        if (action MAP_HAS_KEY(this.storage, key))
        {
            val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);

            val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
            if (action OBJECT_EQUALS(curValue, value))
            {
                action MAP_REMOVE(this.storage, key);
                this.modCount += 1;
                result = true;
            }
        }
        else
        {
            result = false;
        }
    }


    fun *.replace (@target self: HashMap, key: Object, value: Object): Object
    {
        if (action MAP_HAS_KEY(this.storage, key))
        {
            val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);

            result = AbstractMap_SimpleEntryAutomaton(entry).value;
            AbstractMap_SimpleEntryAutomaton(entry).value = value;
        }
        else
        {
            result = null;
        }
    }


    fun *.replace (@target self: HashMap, key: Object, oldValue: Object, newValue: Object): boolean
    {
        result = false;

        if (action MAP_HAS_KEY(this.storage, key))
        {
            val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);

            val curValue: Object = AbstractMap_SimpleEntryAutomaton(entry).value;
            if (action OBJECT_EQUALS(curValue, oldValue))
            {
                AbstractMap_SimpleEntryAutomaton(entry).value = newValue;
                result = true;
            }
        }
    }


    fun *.replaceAll (@target self: HashMap, function: BiFunction): void
    {
        if (function == null)
            _throwNPE();

        val size: int = action MAP_SIZE(this.storage);
        if (size > 0)
        {
            val expectedModCount: int = this.modCount;

            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
            var i: int = 0;
            action LOOP_FOR(
                i, 0, size, +1,
                replaceAll_loop(unseen, function)
            );

            _checkForComodification(expectedModCount);
        }
    }


    @Phantom proc replaceAll_loop (unseen: map<Object, Map_Entry<Object, Object>>, function: BiFunction): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseen);

        val entry: Map_Entry<Object, Object> = action MAP_GET(this.storage, key);
        AbstractMap_SimpleEntryAutomaton(entry).value = action CALL(function, [
            key,
            AbstractMap_SimpleEntryAutomaton(entry).value
        ]);

        action MAP_REMOVE(unseen, key);
    }


    fun *.size (@target self: HashMap): int
    {
        result = action MAP_SIZE(this.storage);
    }


    // within java.util.AbstractMap
    fun *.toString (@target self: HashMap): String
    {
        var count: int = action MAP_SIZE(this.storage);
        if (count == 0)
        {
            result = "{}";
        }
        else
        {
            result = "{";

            val unseen: map<Object, Map_Entry<Object, Object>> = action MAP_CLONE(this.storage);
            count = action MAP_SIZE(unseen); // make semantic link
            action ASSUME(count > 0);

            action LOOP_WHILE(
                count != 0,
                toString_loop(unseen, count, result)
            );

            result += "}";
        }
    }

    @Phantom proc toString_loop (unseen: map<Object, Map_Entry<Object, Object>>, count: int, result: String): void
    {
        val key: Object = action MAP_GET_ANY_KEY(unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(unseen, key);
        action MAP_REMOVE(unseen, key);

        result += action OBJECT_TO_STRING(entry);

        count -= 1;
        if (count != 0)
            result += ", ";
    }


    fun *.values (@target self: HashMap): Collection
    {
        result = new HashMap_ValuesAutomaton(state = Initialized,
            storageRef = this.storage,
            parent = self
        );
    }

}
