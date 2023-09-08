libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Object.java";

// imports

import java.common;


// local semantic types

@public type LSLObject
    is java.lang.Object
    for Object
{
}


// automata

automaton ObjectAutomaton
(
)
: LSLObject
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // constructors
        LSLObject,
    ];

    shift Initialized -> self by [
        // instance methods
        equals,
        hashCode,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @Phantom constructor *.LSLObject (@target self: LSLObject)
    {
        // NOTE: using the original method
    }


    // static methods

    // methods

    fun *.equals (@target self: LSLObject, obj: Object): boolean
    {
        result = self == obj;
    }


    fun *.hashCode (@target self: LSLObject): int
    {
        result = action SYMBOLIC("int");
    }


    fun *.toString (@target self: LSLObject): String
    {
        result = action SYMBOLIC("java.lang.String");
        action ASSUME(result != null);
    }

}
