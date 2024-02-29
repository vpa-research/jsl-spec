//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Throwable.java";

// imports

import java/io/PrintStream;
import java/io/PrintWriter;
import java/lang/String;
import java/lang/StackTraceElement;
import java/lang/Throwable;


// automata

automaton ThrowableAutomaton
(
)
: LSLThrowable
{
    // states and shifts

    // #todo: use two states: Allocated and Initialized
    initstate Initialized;

    shift Initialized -> self by [
        // constructors
        `<init>` (LSLThrowable),
        `<init>` (LSLThrowable, String),
        `<init>` (LSLThrowable, String, Throwable),
        `<init>` (LSLThrowable, String, Throwable, boolean, boolean),
        `<init>` (LSLThrowable, Throwable),

        // instance methods
        addSuppressed,
        fillInStackTrace,
        getCause,
        getLocalizedMessage,
        getMessage,
        getStackTrace,
        getSuppressed,
        initCause,
        printStackTrace (LSLThrowable),
        printStackTrace (LSLThrowable, PrintStream),
        printStackTrace (LSLThrowable, PrintWriter),
        setStackTrace,
        toString,
    ];

    // internal variables

    // utilities

    // constructors

    @Phantom constructor *.`<init>` (@target self: LSLThrowable)
    {
        // Note: using the original method
        action TODO();
    }


    @Phantom constructor *.`<init>` (@target self: LSLThrowable, message: String)
    {
        // Note: using the original method
        action TODO();
    }


    @Phantom constructor *.`<init>` (@target self: LSLThrowable, message: String, cause: Throwable)
    {
        // Note: using the original method
        action TODO();
    }


    @Phantom @protected constructor *.`<init>` (@target self: LSLThrowable,
                                                message: String, cause: Throwable, enableSuppression: boolean, writableStackTrace: boolean)
    {
        // Note: using the original method
        action TODO();
    }


    @Phantom constructor *.`<init>` (@target self: LSLThrowable, cause: Throwable)
    {
        // Note: using the original method
        action TODO();
    }


    // static methods

    // methods

    @final @synchronized fun *.addSuppressed (@target self: LSLThrowable, exception: Throwable): void
    {
        // UtBotJava: do nothing
    }


    @synchronized fun *.fillInStackTrace (@target self: LSLThrowable): Throwable
    {
        result = action SYMBOLIC("java.lang.Throwable");
    }


    @Phantom @synchronized fun *.getCause (@target self: LSLThrowable): Throwable
    {
        // Note: using the original method
        action TODO();
    }


    @Phantom fun *.getLocalizedMessage (@target self: LSLThrowable): String
    {
        // Note: using the original method
        action TODO();
    }


    @Phantom fun *.getMessage (@target self: LSLThrowable): String
    {
        // Note: using the original method
        action TODO();
    }


    fun *.getStackTrace (@target self: LSLThrowable): array<StackTraceElement>
    {
        val size: int = action SYMBOLIC("int");
        action ASSUME(size >= 0);
        action ASSUME(size < 99); // an arbitrary bound

        result = action SYMBOLIC_ARRAY("java.lang.StackTraceElement", size);
    }


    @final @synchronized fun *.getSuppressed (@target self: LSLThrowable): array<Throwable>
    {
        val size: int = action SYMBOLIC("int");
        action ASSUME(size >= 0);
        action ASSUME(size < 99); // an arbitrary bound

        result = action SYMBOLIC_ARRAY("java.lang.Throwable", size);
    }


    @Phantom @synchronized fun *.initCause (@target self: LSLThrowable, cause: Throwable): Throwable
    {
        // Note: using the original method
        action TODO();
    }


    fun *.printStackTrace (@target self: LSLThrowable): void
    {
        // UtBotJava: do nothing
    }


    @Phantom fun *.printStackTrace (@target self: LSLThrowable, s: PrintStream): void
    {
        // Note: using the original method
        action TODO();
    }


    @Phantom fun *.printStackTrace (@target self: LSLThrowable, s: PrintWriter): void
    {
        // Note: using the original method
        action TODO();
    }


    fun *.setStackTrace (@target self: LSLThrowable, stackTrace: array<StackTraceElement>): void
    {
        // UtBotJava: do nothing
    }


    @Phantom fun *.toString (@target self: LSLThrowable): String
    {
        // Note: using the original method
        action TODO();
    }

}
