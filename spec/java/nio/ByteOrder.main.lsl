libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteOrder.java";

// imports

import java/lang/Object;
import java/lang/String;

// automata

automaton ByteOrderAutomaton
(
)
: LSLByteOrder
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,
        // static operations
        nativeOrder,
    ];

    shift Initialized -> self by [
        // instance methods
        toString,
    ];

    // internal variables
    @private var name: String = "";

    // utilities

    // constructors

    @private constructor *.`<init>` (@target self: ByteOrder, name: String)
    {
        this.name = name;
    }


    // static methods

    @static fun *.nativeOrder (): ByteOrder
    {
        result = BIG_ENDIAN;
    }


    // methods

    fun *.toString (@target self: ByteOrder): String
    {
        result = this.name;
    }

}