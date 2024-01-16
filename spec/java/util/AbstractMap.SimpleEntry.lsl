libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractMap.java#L604";

// imports

import java/lang/Object;
import java/lang/String;

import java/util/AbstractMap;


// automata

automaton AbstractMap_SimpleEntryAutomaton
(
    var key: Object,
    var value: Object
)
: AbstractMap_SimpleEntry
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (AbstractMap_SimpleEntry, Map_Entry),
        `<init>` (AbstractMap_SimpleEntry, Object, Object),
    ];

    shift Initialized -> self by [
        // instance methods
        equals,
        getKey,
        getValue,
        hashCode,
        setValue,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: AbstractMap_SimpleEntry, entry: Map_Entry)
    {
        this.key = action CALL_METHOD(entry, "getKey", []);
        this.value = action CALL_METHOD(entry, "getValue", []);
    }


    constructor *.`<init>` (@target self: AbstractMap_SimpleEntry, key: Object, value: Object)
    {
        this.key = key;
        this.value = value;
    }


    // static methods

    // methods

    fun *.equals (@target self: AbstractMap_SimpleEntry, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            result = other is Map_Entry;
            if (result)
            {
                val oEntry: Map_Entry = other as Map_Entry;
                val otherKey: Object = action CALL_METHOD(oEntry, "getKey", []);
                val otherValue: Object = action CALL_METHOD(oEntry, "getValue", []);
                result = action OBJECT_EQUALS(this.key, otherKey) && action OBJECT_EQUALS(this.value, otherValue);
            }
        }
    }


    fun *.getKey (@target self: AbstractMap_SimpleEntry): Object
    {
        result = this.key;
    }


    fun *.getValue (@target self: AbstractMap_SimpleEntry): Object
    {
        result = this.value;
    }


    fun *.hashCode (@target self: AbstractMap_SimpleEntry): int
    {
        result = action OBJECT_HASH_CODE(this.key) ^ action OBJECT_HASH_CODE(this.value);
    }


    fun *.setValue (@target self: AbstractMap_SimpleEntry, value: Object): Object
    {
        result = this.value;
        this.value = value;
    }


    fun *.toString (@target self: AbstractMap_SimpleEntry): String
    {
        result = action OBJECT_TO_STRING(this.key) + "=" + action OBJECT_TO_STRING(this.value);
    }

}
