///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Throwable.java";

// imports

import java.common;
import java/io/_interfaces;
import java/lang/_interfaces;


// local semantic types

@implements("java.io.Serializable")
@public type LSLThrowable
    is java.lang.Throwable
    for Throwable
{
    @private @static val serialVersionUID: long = -3042686055658047285L;

    @private @static val NULL_CAUSE_MESSAGE       : String = "Cannot suppress a null exception.";
    @private @static val SELF_SUPPRESSION_MESSAGE : String = "Self-suppression not permitted";
    @private @static val CAUSE_CAPTION            : String = "Caused by: ";
    @private @static val SUPPRESSED_CAPTION       : String = "Suppressed: ";
}


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
        Throwable (LSLThrowable),
        Throwable (LSLThrowable, String),
        Throwable (LSLThrowable, String, Throwable),
        Throwable (LSLThrowable, String, Throwable, boolean, boolean),
        Throwable (LSLThrowable, Throwable),

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

    @Phantom constructor *.Throwable (@target self: LSLThrowable)
    {
        // Note: using the original method
    }


    @Phantom constructor *.Throwable (@target self: LSLThrowable, message: String)
    {
        // Note: using the original method
    }


    @Phantom constructor *.Throwable (@target self: LSLThrowable, message: String, cause: Throwable)
    {
        // Note: using the original method
    }


    @Phantom @protected constructor *.Throwable (@target self: LSLThrowable,
            message: String, cause: Throwable, enableSuppression: boolean, writableStackTrace: boolean)
    {
        // Note: using the original method
    }


    @Phantom constructor *.Throwable (@target self: LSLThrowable, cause: Throwable)
    {
        // Note: using the original method
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
    }


    @Phantom fun *.getLocalizedMessage (@target self: LSLThrowable): String
    {
        // Note: using the original method
    }


    @Phantom fun *.getMessage (@target self: LSLThrowable): String
    {
        // Note: using the original method
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
    }


    fun *.printStackTrace (@target self: LSLThrowable): void
    {
        // UtBotJava: do nothing
    }


    @Phantom fun *.printStackTrace (@target self: LSLThrowable, s: PrintStream): void
    {
        // Note: using the original method
    }


    @Phantom fun *.printStackTrace (@target self: LSLThrowable, s: PrintWriter): void
    {
        // Note: using the original method
    }


    fun *.setStackTrace (@target self: LSLThrowable, stackTrace: array<StackTraceElement>): void
    {
        // UtBotJava: do nothing
    }


    @Phantom fun *.toString (@target self: LSLThrowable): String
    {
        // Note: using the original method
    }

}
