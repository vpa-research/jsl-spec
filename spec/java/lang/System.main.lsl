libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/System.java";

// imports

import java/io/Console;
import java/io/InputStream;
import java/io/PrintStream;
import java/lang/Object;
import java/lang/SecurityManager;
import java/lang/String;
import java/nio/channels/Channel;
import java/util/Map;
import java/util/Properties;
import java/util/ResourceBundle;
import jdk/internal/misc/VM;

import java/lang/System;

import runtime/utils/SymbolicInputStream;


// automata

automaton SystemAutomaton
(
)
: LSLSystem
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // constructors
        LSLSystem,

        // static operations
        arraycopy,
        clearProperty,
        console,
        currentTimeMillis,
        exit,
        gc,
        getLogger (String),
        getLogger (String, ResourceBundle),
        getProperties,
        getProperty (String),
        getProperty (String, String),
        getSecurityManager,
        getenv (),
        getenv (String),
        identityHashCode,
        inheritedChannel,
        lineSeparator,
        load,
        loadLibrary,
        mapLibraryName,
        nanoTime,
        runFinalization,
        setErr,
        setIn,
        setOut,
        setProperties,
        setProperty,
        setSecurityManager,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    @static proc _initProperties (): void
    {
        // #problem: no approximation for Properties
        props = null;//new Properties(84);
        // #todo
    }


    // constructors

    @private constructor *.LSLSystem (@target self: LSLSystem)
    {
        // doing nothing - this is a (singleton) utility class
    }


    // static methods

    @Phantom @static fun *.arraycopy (arg0: Object, arg1: int, arg2: Object, arg3: int, arg4: int): void
    {
        // WARNING: do not approximate this method - infinite recursion!
    }


    @Phantom @static fun *.clearProperty (key: String): String
    {
        // NOTE: using the original method
    }


    @static fun *.console (): Console
    {
        result = console;
    }


    @Phantom @static fun *.currentTimeMillis (): long
    {
        // #todo: use NANOTIME_WARP_MAX and NANOTIME_BEGINNING_OF_TIME
        action TODO();
    }


    @static fun *.exit (status: int): void
    {
        // #problem: not way to forcebly shutdown the program execution
        action ERROR("Unexpected shutdown");
    }


    @static fun *.gc (): void
    {
        // this have no effect during symbolic execution
    }


    @Phantom @static fun *.getLogger (name: String): System_Logger
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getLogger (name: String, bundle: ResourceBundle): System_Logger
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getProperties (): Properties
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getProperty (key: String): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getProperty (key: String, def: String): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getSecurityManager (): SecurityManager
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.getenv (): Map
    {
        // NOTE: using the original method
    }


    @static fun *.getenv (name: String): String
    {
        result = action SYMBOLIC("java.lang.String");
        action ASSUME(result != null);
    }


    @static fun *.identityHashCode (x: Object): int
    {
        // #problem: there are no ways of converting a reference to a "memory address" yet
        result = action SYMBOLIC("int");
    }


    @throws(["java.io.IOException"])
    @Phantom @static fun *.inheritedChannel (): Channel
    {
        // NOTE: using the original method
    }


    @static fun *.lineSeparator (): String
    {
        if (SYSTEM_IS_WINDOWS)
            result = "\r\n";
        else
            result = "\n";
    }


    @Phantom @static fun *.load (filename: String): void
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.loadLibrary (libname: String): void
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.mapLibraryName (arg0: String): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.nanoTime (): long
    {
        // #todo: use NANOTIME_WARP_MAX and NANOTIME_BEGINNING_OF_TIME
        action TODO();
    }


    @Phantom @static fun *.runFinalization (): void
    {
        // #problem: what do we need to do here?
        action TODO();
    }


    @static fun *.setErr (stream: PrintStream): void
    {
        if (stream == null)
            _throwNPE();

        // #todo: add checks and exceptions
        err = stream;
    }


    @static fun *.setIn (stream: InputStream): void
    {
        if (stream == null)
            _throwNPE();

        // #todo: add checks and exceptions
        in = stream;
    }


    @static fun *.setOut (stream: PrintStream): void
    {
        if (stream == null)
            _throwNPE();

        // #todo: add checks and exceptions
        out = stream;
    }


    @Phantom @static fun *.setProperties (props: Properties): void
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.setProperty (key: String, value: String): String
    {
        // NOTE: using the original method
    }


    @Phantom @static fun *.setSecurityManager (s: SecurityManager): void
    {
        // NOTE: using the original method
    }


    // methods

    // special: internal class initialization by the JRE

    @private @static proc initPhase1 (): void  // WARNING: do not rename!
    {
        _initProperties();

        //action CALL_METHOD(null as VM, "saveAndRemoveProperties", [props]);

        //action CALL_METHOD(null as StaticProperty, "javaHome", []);
        //VersionProps.init();

        // configure the standard <INPUT/OUTPUT/ERROR> streams
        val newInput: InputStream = new SymbolicInputStreamAutomaton(state = Initialized,
            maxSize = 1000,
            supportMarks = false,
        );
        // #todo: unsafe operations in BufferedInputStream
        in = newInput;//action DEBUG_DO("new java.io.BufferedInputStream(newInput)");
        out = new System_PrintStreamAutomaton(state = Initialized);
        err = new System_PrintStreamAutomaton(state = Initialized);

        // #problem: no OS signal support
        //Terminator.setup();

        // JDK comment: system is fully initialized
        action CALL_METHOD(null as VM, "initializeOSEnvironment", []);

        // #problem: no thread support
        //val current: Thread = action CALL_METHOD(null as Thread, "currentThread", []);
        //val threadGroup: ThreadGroup = action CALL_METHOD(current, "getThreadGroup", []);
        //action CALL_METHOD(threadGroup, "add", [current]);

        // #todo
        //setJavaLangAccess();

        // #problem: too complex, package-private
        //action CALL_METHOD(null as ClassLoader, "initLibraryPaths", []);

        // JDK comment: IMPORTANT: Ensure that this remains the last initialization action!
        action CALL_METHOD(null as VM, "initLevel", [1]);
    }


    @private @static proc initPhase2 (): int  // WARNING: do not change!
    {
        // #problem: java.lang.System#bootLayer initialization

        // JDK comment: module system initialized
        action CALL_METHOD(null as VM, "initLevel", [2]);

        // JDK comment: JNI_OK
        result = 0;
    }


    @private @static proc initPhase3 (): void  // WARNING: do not rename!
    {
        // #todo

        // JDK comment: initializing the system class loader
        action CALL_METHOD(null as VM, "initLevel", [3]);

        // #todo

        // JDK comment: system is fully initialized
        action CALL_METHOD(null as VM, "initLevel", [4]);
    }


    // special: static initialization

    @Phantom @static fun *.__clinit__ (): void
    {
        initPhase1();
        initPhase2();
        initPhase3();
    }

}
