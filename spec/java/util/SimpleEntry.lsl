libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/AbstractMap$SimpleEntry.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/util/Map;


// automata

automaton SimpleEntryAutomaton
(
    var key: Object,
    var value: Object
)
: SimpleEntry
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (SimpleEntry, Map_Entry),
        `<init>` (SimpleEntry, Object, Object),
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

    constructor *.`<init>` (@target self: SimpleEntry, entry: Map_Entry)
    {
        this.key = action CALL_METHOD(entry, "getKey", []);
        this.value = action CALL_METHOD(entry, "getValue", []);
    }


    constructor *.`<init>` (@target self: SimpleEntry, key: Object, value: Object)
    {
        this.key = key;
        this.value = value;
    }


    // static methods

    // methods

    fun *.equals (@target self: SimpleEntry, other: Object): boolean
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
                val otherKey: Object = SimpleEntryAutomaton(other).key;
                val otherValue: Object = SimpleEntryAutomaton(other).value;
                result = action OBJECT_EQUALS(this.key, otherKey) && action OBJECT_EQUALS(this.value, otherValue);
            }
        }
    }


    fun *.getKey (@target self: SimpleEntry): Object
    {
        result = this.key;
    }


    fun *.getValue (@target self: SimpleEntry): Object
    {
        result = this.value;
    }


    fun *.hashCode (@target self: SimpleEntry): int
    {
        // #question: do wee need add checking null (like in original class AbstractMap$SimpleEntry) ?
        result = action OBJECT_HASH_CODE(this.key) ^ action OBJECT_HASH_CODE(this.value);
    }


    fun *.setValue (@target self: SimpleEntry, value: Object): Object
    {
        result = this.value;
        this.value = value;
    }


    fun *.toString (@target self: SimpleEntry): String
    {
        result = action OBJECT_TO_STRING(this.key) + "=" + action OBJECT_TO_STRING(this.value);
    }

}