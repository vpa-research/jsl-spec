libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Object.java";

// imports

import java/lang/Class;
import java/lang/Cloneable;
import java/lang/Object;
import java/lang/String;


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
        `<init>`,

        // instance methods
        equals,
        clone,
        getClass,
        hashCode,
        notify,
        notifyAll,
        toString,
        wait (LSLObject),
        wait (LSLObject, long),
        wait (LSLObject, long, int),
    ];

    // internal variables

    // utilities

    // constructors

    @Phantom constructor *.`<init>` (@target self: LSLObject)
    {
        // WARNING: Using the original method here. Do not change! (infinite recursion otherwise)
    }


    // static methods

    // methods

    fun *.equals (@target self: LSLObject, obj: Object): boolean
    {
        result = self == obj;
    }


    @throws(["java.lang.CloneNotSupportedException"])
    @protected fun *.clone (@target self: LSLObject): Object
    {
        if (self is Cloneable == false)
            action THROW_NEW("java.lang.CloneNotSupportedException", []);

        result = action SYMBOLIC("java.lang.Object");
        action ASSUME(result != null);

        val thisType: Class = action TYPE_OF(self);
        val cloneType: Class = action TYPE_OF(result);
        action ASSUME(thisType == cloneType);
    }


    @Phantom @final fun *.getClass (@target self: LSLObject): Class
    {
        // NOTE: using the original method
    }


    fun *.hashCode (@target self: LSLObject): int
    {
        result = action SYMBOLIC("int");
    }


    @Phantom @final fun *.notify (@target self: LSLObject): void
    {
        // NOTE: using the original method
    }


    @Phantom @final fun *.notifyAll (@target self: LSLObject): void
    {
        // NOTE: using the original method
    }


    fun *.toString (@target self: LSLObject): String
    {
        // #todo: use class name and a random hex string
        result = "java.lang.Object@735b5592";
    }


    @throws(["java.lang.InterruptedException"])
    @Phantom @final fun *.wait (@target self: LSLObject): void
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.InterruptedException"])
    @Phantom @final fun *.wait (@target self: LSLObject, timeoutMillis: long): void
    {
        // NOTE: using the original method
    }


    @throws(["java.lang.InterruptedException"])
    @Phantom @final fun *.wait (@target self: LSLObject, timeoutMillis: long, nanos: int): void
    {
        // NOTE: using the original method
    }


    // special: static initialization

    @Phantom @static fun *.`<clinit>` (): void
    {
        action DO_NOTHING();
    }

}
