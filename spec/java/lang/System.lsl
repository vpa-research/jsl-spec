//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/System.java";

// imports

import java/io/Console;
import java/io/InputStream;
import java/io/PrintStream;
import java/lang/Integer;
import java/lang/Object;
import java/lang/SecurityManager;
import java/lang/String;
import java/lang/Throwable;
import java/util/Properties;


// primary semantic types

@final type System
    is java.lang.System
    for Object
{
}


@final type System_Logger_Level
    is java.lang.System.Logger.Level
    for Object
{
    // #problem: enum constants
}


@interface type System_Logger
    is java.lang.System.Logger
    for Object
{
    fun *.getName(): String;

    fun *.isLoggable(level: System_Logger_Level): boolean;

    fun *.log(level: System_Logger_Level, msg: String): void;

    fun *.log(level: System_Logger_Level, obj: Object): void;

    fun *.log(level: System_Logger_Level, msg: String, thrown: Throwable): void;
}


// global aliases and type overrides

@final type LSLSystem
    is java.lang.System
    for System
{
    @private @static val propsMap: map<String, String> = action MAP_NEW();

    @private @static @volatile var security: SecurityManager = null; // WARNING: do not change!
    @private @static var props: Properties = null;                   // WARNING: do not change!

    // #todo: attach I/O streams from this
    @private @static var console: Console = null;

    @public @static var in: InputStream = null;  // WARNING: do not change!
    @public @static var out: PrintStream = null; // WARNING: do not change!
    @public @static var err: PrintStream = null; // WARNING: do not change!

    @private @static val NANOTIME_BEGINNING_OF_TIME: long = 1000L;
    @private @static val NANOTIME_WARP_MAX: long = 1000L;

    @private @static val identityHashCodeMap: map<Object, Integer> = action IDENTITY_MAP_NEW();
}

// WARNING: declaration order is important!
val SYSTEM_IS_MAC: boolean     = action SYMBOLIC("boolean");
val SYSTEM_IS_WINDOWS: boolean = !SYSTEM_IS_MAC && action SYMBOLIC("boolean");


@GenerateMe
@extends("java.io.PrintStream")
@public @final type System_PrintStream
    is java.lang.System_PrintStream
    for PrintStream
{
}
