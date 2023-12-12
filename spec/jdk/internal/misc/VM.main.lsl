//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/jdk/internal/misc/VM.java";

// imports

import java/lang/Class;
import java/lang/ClassLoader;
import java/lang/Object;
import java/lang/String;
import java/util/Map;
import java/util/Properties;

import jdk/internal/misc/VM;


// automata

automaton VMAutomaton
(
)
: LSLVM
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // static operations
        addFinalRefCount,
        awaitInitLevel,
        getFinalRefCount,
        getNanoTimeAdjustment,
        getPeakFinalRefCount,
        getRuntimeArguments,
        getSavedProperties,
        getSavedProperty,
        getegid,
        geteuid,
        getgid,
        getuid,
        initLevel (),
        initLevel (int),
        initializeFromArchive,
        initializeOSEnvironment,
        isBooted,
        isDirectMemoryPageAligned,
        isModuleSystemInited,
        isSetUID,
        isShutdown,
        isSystemDomainLoader,
        latestUserDefinedLoader,
        maxDirectMemory,
        saveAndRemoveProperties,
        shutdown,
        toThreadState,
    ];

    // internal variables

    // utilities

    // constructors

    // static methods

    @static fun *.addFinalRefCount (n: int): void
    {
        action TODO();
    }


    @throws(["java.lang.InterruptedException"])
    @static fun *.awaitInitLevel (value: int): void
    {
        action TODO();
    }


    @static fun *.getFinalRefCount (): int
    {
        action TODO();
    }


    @static fun *.getNanoTimeAdjustment (arg0: long): long
    {
        action TODO();
    }


    @static fun *.getPeakFinalRefCount (): int
    {
        action TODO();
    }


    @static fun *.getRuntimeArguments (): array<String>
    {
        action TODO();
    }


    @static fun *.getSavedProperties (): Map
    {
        action TODO();
    }


    @static fun *.getSavedProperty (key: String): String
    {
        action TODO();
    }


    @static fun *.getegid (): long
    {
        action TODO();
    }


    @static fun *.geteuid (): long
    {
        action TODO();
    }


    @static fun *.getgid (): long
    {
        action TODO();
    }


    @static fun *.getuid (): long
    {
        action TODO();
    }


    @static fun *.initLevel (): int
    {
        action TODO();
    }


    @static fun *.initLevel (value: int): void
    {
        action TODO();
    }


    @static fun *.initializeFromArchive (arg0: Class): void
    {
        action TODO();
    }


    @static fun *.initializeOSEnvironment (): void
    {
        // doing nothing
    }


    @static fun *.isBooted (): boolean
    {
        action TODO();
    }


    @static fun *.isDirectMemoryPageAligned (): boolean
    {
        action TODO();
    }


    @static fun *.isModuleSystemInited (): boolean
    {
        action TODO();
    }


    @static fun *.isSetUID (): boolean
    {
        action TODO();
    }


    @static fun *.isShutdown (): boolean
    {
        action TODO();
    }


    @static fun *.isSystemDomainLoader (loader: ClassLoader): boolean
    {
        action TODO();
    }


    @static fun *.latestUserDefinedLoader (): ClassLoader
    {
        action TODO();
    }


    @static fun *.maxDirectMemory (): long
    {
        action TODO();
    }


    @static fun *.saveAndRemoveProperties (props: Properties): void
    {
        action TODO();
    }


    @static fun *.shutdown (): void
    {
        action TODO();
    }


    @static fun *.toThreadState (threadStatus: int): Thread_State
    {
        action TODO();
    }


    // methods
}
