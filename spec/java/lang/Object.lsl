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
        getClass,
        hashCode,
        notify,
        notifyAll,
        toString,
        wait (Object),
        wait (Object, long),
        wait (Object, long, int),
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


    @Phantom @final fun *.getClass (@target self: Object): Class
    {
        // NOTE: using the original method
    }


    fun *.hashCode (@target self: LSLObject): int
    {
        result = action SYMBOLIC("int");
    }


    @Phantom @final fun *.notify (@target self: Object): void
    {
        // NOTE: using the original method
    }


    @Phantom @final fun *.notifyAll (@target self: Object): void
    {
        // NOTE: using the original method
    }


    fun *.toString (@target self: LSLObject): String
    {
        result = action SYMBOLIC("java.lang.String");
        action ASSUME(result != null);
    }


    @throws(["java.lang.InterruptedException"])
    @Phantom @final fun *.wait (@target self: Object): void
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.InterruptedException"])
    @Phantom @final fun *.wait (@target self: Object, timeoutMillis: long): void
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.InterruptedException"])
    @Phantom @final fun *.wait (@target self: Object, timeoutMillis: long, nanos: int): void
    {
        // NOTE: using the original method
    }

}
