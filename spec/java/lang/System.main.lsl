//#! pragma: target=java
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

import jdk/internal/misc/VM; // #problem: does not exist in Java-8
import sun/misc/Version;
import sun/misc/VM; // #problem: does not exist in Java-11

import java/lang/System;

import libsl/utils/SymbolicInputStream;


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
        `<init>`,

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


    @AutoInline @Phantom proc _checkKey (key: String): void
    {
        if (key == null)
            action THROW_NEW("java.lang.NullPointerException", ["key can't be null"]);

        if (action CALL_METHOD(key, "length", []) == 0)
            action THROW_NEW("java.lang.NullPointerException", ["key can't be empty"]);
    }


    @static proc _initProperties (): void
    {
        // prepare raw values
        val pm: map<String, String> = propsMap; // NOTE: avoiding unwanted frequent static field access

        // NOTE: symbolic JRE version is too expensive to use
        val javaVersion: int = 8;

        // NOTE: valid symbolic name is too expensive to use and construct
        val userName: String = "Admin";

        // convert it into properties

        action MAP_SET(pm, "file.encoding", "Cp1251");
        action MAP_SET(pm, "sun.io.unicode.encoding", "UnicodeLittle");
        action MAP_SET(pm, "sun.jnu.encoding", "Cp1251");
        action MAP_SET(pm, "sun.stderr.encoding", "cp866");
        action MAP_SET(pm, "sun.stdout.encoding", "cp866");

        val versionStrings: array<String> = [
            "0", "1", "2", "3", "4", "5", "6", "7",
            "8",
            "9",
            "10",
            "11",
            "12", "13", "14", "15",
        ];
        val versionString: String = versionStrings[javaVersion];

        action MAP_SET(pm, "java.specification.name", "Java Platform API Specification");
        action MAP_SET(pm, "java.specification.vendor", "Oracle Corporation");
        action MAP_SET(pm, "java.specification.version", versionString);
        action MAP_SET(pm, "java.vm.info", "mixed mode");
        action MAP_SET(pm, "java.vm.name", "OpenJDK 64-Bit Server VM");
        action MAP_SET(pm, "java.vm.specification.name", "Java Virtual Machine Specification");
        action MAP_SET(pm, "java.vm.specification.vendor", "Oracle Corporation");
        action MAP_SET(pm, "java.vm.specification.version", versionString);
        action MAP_SET(pm, "java.vm.vendor", "Eclipse Adoptium");
        action MAP_SET(pm, "java.vm.version", versionString + ".0.362+9");

        action MAP_SET(pm, "java.library.path", "C:\\Program Files\\Eclipse Adoptium\\jdk-8.0.362.9-hotspot\\bin;C:\\Windows\\Sun\\Java\\bin;C:\\Windows\\system32;.");
        action MAP_SET(pm, "java.home", "C:\\Program Files\\Eclipse Adoptium\\jdk-8.0.362.9-hotspot");
        action MAP_SET(pm, "sun.boot.library.path", "C:\\Program Files\\Eclipse Adoptium\\jdk-8.0.362.9-hotspot\\bin");
        action MAP_SET(pm, "java.io.tmpdir", "T:\\Temp\\");
        action MAP_SET(pm, "java.class.path", ".");

        if (SYSTEM_IS_WINDOWS)
        {
            action MAP_SET(pm, "file.separator", "\\");
            action MAP_SET(pm, "line.separator", "\r\n");
            action MAP_SET(pm, "path.separator", ";");
        }
        else
        {
            action MAP_SET(pm, "file.separator", "/");
            action MAP_SET(pm, "line.separator", "\n");
            action MAP_SET(pm, "path.separator", ":");
        }

        action MAP_SET(pm, "user.country", "RU");
        action MAP_SET(pm, "user.country.format", "US");
        action MAP_SET(pm, "user.language", "ru");

        val bytecodeVersions: array<String> = [
            "?",    /* 0? */
            "?",    /* 1? */
            "?",    /* 2? */
            "?",    /* 3? */
            "?",    /* 4? */
            "49.0", /* Java SE 5  */
            "50.0", /* Java SE 6  */
            "51.0", /* Java SE 7  */
            "52.0", /* Java SE 8  */
            "53.0", /* Java SE 9  */
            "54.0", /* Java SE 10 */
            "55.0", /* Java SE 11 */
            "?",    /* 12? */
            "?",    /* 13? */
            "?",    /* 14? */
            "?",    /* 15? */
        ];
        action MAP_SET(pm, "java.class.version", bytecodeVersions[javaVersion]);

        action MAP_SET(pm, "os.arch", "amd64");
        action MAP_SET(pm, "os.name", "Windows 10");
        action MAP_SET(pm, "os.version", "10.0");
        action MAP_SET(pm, "sun.arch.data.model", "64");
        action MAP_SET(pm, "sun.cpu.endian", "little");
        action MAP_SET(pm, "sun.cpu.isalist", "amd64");
        action MAP_SET(pm, "sun.desktop", "windows");

        action MAP_SET(pm, "user.dir", "D:\\Company\\Prod\\Service");
        action MAP_SET(pm, "user.home", "C:\\Users\\" + userName);
        action MAP_SET(pm, "user.name", userName);
        action MAP_SET(pm, "user.script", "");
        action MAP_SET(pm, "user.timezone", "");
        action MAP_SET(pm, "user.variant", "");

        // unknown misc stuff
        action MAP_SET(pm, "sun.java.command", "org.example.MainClass"); // #problem: main class
        action MAP_SET(pm, "awt.toolkit", "sun.awt.windows.WToolkit");
        action MAP_SET(pm, "java.awt.graphicsenv", "sun.awt.Win32GraphicsEnvironment");
        action MAP_SET(pm, "java.awt.printerjob", "sun.awt.windows.WPrinterJob");
        action MAP_SET(pm, "sun.java.launcher", "SUN_STANDARD");
        action MAP_SET(pm, "sun.management.compiler", "HotSpot 64-Bit Tiered Compilers");
        action MAP_SET(pm, "sun.nio.MaxDirectMemorySize", "-1");
        action MAP_SET(pm, "sun.os.patch.level", "");
        action MAP_SET(pm, "java.vm.compressedOopsMode", "Zero based");
        action MAP_SET(pm, "jdk.boot.class.path.append", "");
        action MAP_SET(pm, "jdk.debug", "release");

        // #problem: no approximation for Properties
        props = null;//new Properties(84);
        // #todo: init 'props' from the map above
    }


    @AutoInline @Phantom proc _checkIO (): void
    {
        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPermission", [
                action DEBUG_DO("new RuntimePermission(\"setIO\")")
            ]);
    }


    // constructors

    @private constructor *.`<init>` (@target self: LSLSystem)
    {
        // doing nothing - this is a (singleton) utility class
    }


    // static methods

    @Phantom @static fun *.arraycopy (src: Object, srcPos: int, dest: Object, destPos: int, length: int): void
    {
        // WARNING: do not approximate this method - infinite recursion!
    }


    @static fun *.clearProperty (key: String): String
    {
        _checkKey(key);

        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPermission", [
                action DEBUG_DO("new java.util.PropertyPermission(key, \"write\")")
            ]);

        val pm: map<String, String> = propsMap;
        if (action MAP_HAS_KEY(pm, key))
        {
            result = action MAP_GET(pm, key);

            // #todo: remove key from 'props'

            action MAP_REMOVE(pm, key);
        }
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
        // #problem: not way to forcibly shutdown the program execution
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


    @static fun *.getProperties (): Properties
    {
        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPropertiesAccess", []);

        result = props;
    }


    @static fun *.getProperty (key: String): String
    {
        _checkKey(key);

        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPropertyAccess", [key]);

        val pm: map<String, String> = propsMap;
        if (action MAP_HAS_KEY(pm, key))
            result = action MAP_GET(pm, key);
        else
            result = null;
    }


    @static fun *.getProperty (key: String, def: String): String
    {
        _checkKey(key);

        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPropertyAccess", [key]);

        val pm: map<String, String> = propsMap;
        if (action MAP_HAS_KEY(pm, key))
            result = action MAP_GET(pm, key);
        else
            result = def;
    }


    @static fun *.getSecurityManager (): SecurityManager
    {
        result = security;
    }


    @Phantom @static fun *.getenv (): Map
    {
        // NOTE: using the original method

        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPermission", [
                action DEBUG_DO("new RuntimePermission(\"getenv.*\")")
            ]);

        // #todo: provide an actual map with symbolic values
    }


    @static fun *.getenv (name: String): String
    {
        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPermission", [
                action DEBUG_DO("new RuntimePermission(\"getenv.\".concat(name))")
            ]);

        result = action SYMBOLIC("java.lang.String");
        action ASSUME(result != null);

        val len: int = action CALL_METHOD(result, "length", []);
        action ASSUME(len >= 0);
        action ASSUME(len < 250);
    }


    @static fun *.identityHashCode (x: Object): int
    {
        if (x == null)
        {
            result = 0;
        }
        else if (action MAP_HAS_KEY(identityHashCodeMap, x))
        {
            val value: Integer = action MAP_GET(identityHashCodeMap, x);
            action ASSUME(value != null);
            result = action CALL_METHOD(value, "intValue", []);
        }
        else
        {
            // sequential unique numbers
            result = action MAP_SIZE(identityHashCodeMap);

            val hash: Integer = action CALL_METHOD(null as Integer, "valueOf", [result]);
            action MAP_SET(identityHashCodeMap, x, hash);
        }
    }


    @throws(["java.io.IOException"])
    @Phantom @static fun *.inheritedChannel (): Channel
    {
        // NOTE: using the original method
    }


    @static fun *.lineSeparator (): String
    {
        result = action MAP_GET(propsMap, "line.separator");
    }


    @static fun *.load (filename: String): void
    {
        if (filename == null)
            _throwNPE();

        // faking underlying checks and loading procedures
        if (action SYMBOLIC("boolean")) action THROW_NEW("java.lang.SecurityException",    ["<message>"]);
        if (action SYMBOLIC("boolean")) action THROW_NEW("java.lang.UnsatisfiedLinkError", ["<message>"]);
    }


    @static fun *.loadLibrary (libname: String): void
    {
        if (libname == null)
            _throwNPE();

        // faking underlying checks and loading procedures
        if (action SYMBOLIC("boolean")) action THROW_NEW("java.lang.SecurityException",    ["<message>"]);
        if (action SYMBOLIC("boolean")) action THROW_NEW("java.lang.UnsatisfiedLinkError", ["<message>"]);
    }


    @static fun *.mapLibraryName (libname: String): String
    {
        if (libname == null)
            _throwNPE();

        // https://github.com/openjdk/jdk8/blob/master/jdk/src/share/native/java/lang/System.c#L466
        val len: int = action CALL_METHOD(libname, "length", []);
        if (len > 240)
            action THROW_NEW("java.lang.IllegalArgumentException", ["name too long"]);

        if (SYSTEM_IS_WINDOWS)
            result = libname + ".dll";
        else if (SYSTEM_IS_MAC)
            result = "lib" + libname + ".dylib";
        else
            result = "lib" + libname + ".so";
    }


    @Phantom @static fun *.nanoTime (): long
    {
        // #todo: use NANOTIME_WARP_MAX and NANOTIME_BEGINNING_OF_TIME
        action TODO();
    }


    @static fun *.runFinalization (): void
    {
        // #problem: it is not possible to call finalizer method on an arbitrary object
    }


    @static fun *.setErr (stream: PrintStream): void
    {
        _checkIO();
        `err` = stream;
    }


    @static fun *.setIn (stream: InputStream): void
    {
        _checkIO();
        `in` = stream;
    }


    @static fun *.setOut (stream: PrintStream): void
    {
        _checkIO();
        `out` = stream;
    }


    @static fun *.setProperties (p: Properties): void
    {
        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPropertiesAccess", []);

        // #todo: improve after there will be some implementation for Properties
        props = p;
    }


    @static fun *.setProperty (key: String, value: String): String
    {
        _checkKey(key);

        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPermission", [
                action DEBUG_DO("new java.util.PropertyPermission(key, \"write\")")
            ]);

        // #todo: update 'props'

        val pm: map<String, String> = propsMap;
        if (action MAP_HAS_KEY(pm, key))
            result = action MAP_GET(pm, key);
        else
            result = null;

        action MAP_SET(pm, key, value);
    }


    @static fun *.setSecurityManager (s: SecurityManager): void
    {
        val sm: SecurityManager = security;
        if (sm != null)
            action CALL_METHOD(sm, "checkPermission", [
                action DEBUG_DO("new RuntimePermission(\"setSecurityManager\")")
            ]);

        // #problem: no protection domain checks here

        security = s;
    }


    // methods

    // special: internal class initialization by the JRE

    @private @static proc initPhase1 (): void  // WARNING: do not change signature!
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
        `in` = newInput;//action DEBUG_DO("new java.io.BufferedInputStream(newInput)");
        `out` = new System_PrintStreamAutomaton(state = Initialized);
        `err` = new System_PrintStreamAutomaton(state = Initialized);

        // #problem: no OS signal support
        //Terminator.setup();

        // JDK comment: system is fully initialized
        //action CALL_METHOD(null as VM, "initializeOSEnvironment", []); <- NPE

        // #problem: no thread support
        //val current: Thread = action CALL_METHOD(null as Thread, "currentThread", []);
        //val threadGroup: ThreadGroup = action CALL_METHOD(current, "getThreadGroup", []);
        //action CALL_METHOD(threadGroup, "add", [current]);

        // #problem: unable to call or model 'java.lang.System#setJavaLangAccess'

        // #problem: too complex, package-private
        //action CALL_METHOD(null as ClassLoader, "initLibraryPaths", []);

        // JDK comment: IMPORTANT: Ensure that this remains the last initialization action!
        action CALL_METHOD(null as VM, "initLevel", [1]);
    }


    @private @static proc initPhase2 (): int  // WARNING: do not change signature!
    {
        // #problem: java.lang.System#bootLayer initialization

        // JDK comment: module system initialized
        action CALL_METHOD(null as VM, "initLevel", [2]);

        // JDK comment: JNI_OK
        result = 0;
    }


    @private @static proc initPhase3 (): void  // WARNING: do not change signature!
    {
        // #problem: reflective access during security manager initialization
        // #todo: check property 'java.security.manager'
        security = null;//new SecurityManagerAutomaton(state = Initialized);

        // JDK comment: initializing the system class loader
        action CALL_METHOD(null as VM, "initLevel", [3]);

        // #problem: java.lang.ClassLoader#initSystemClassLoader is package-private

        // JDK comment: system is fully initialized
        action CALL_METHOD(null as VM, "initLevel", [4]);
    }


    // NOTE: not using this
    @Phantom @private @static proc init_as_java8 (): void
    {
        // #todo: use dedicated Properties automaton
        props = action DEBUG_DO("new Properties()");

        _initProperties();

        action CALL_METHOD(null as SUN_Version, "init", []);

        // configure the standard <INPUT/OUTPUT/ERROR> streams
        val newInput: InputStream = new SymbolicInputStreamAutomaton(state = Initialized,
            maxSize = 1000,
            supportMarks = false,
        );
        // #todo: unsafe operations in BufferedInputStream
        `in` = newInput;//action DEBUG_DO("new java.io.BufferedInputStream(newInput)");
        `out` = new System_PrintStreamAutomaton(state = Initialized);
        `err` = new System_PrintStreamAutomaton(state = Initialized);

        // #problem: thread group initialization

        // #problem: unable to call or model 'java.lang.System#setJavaLangAccess'

        action CALL_METHOD(null as SUN_VM, "booted", []);
    }


    // special: static initialization

    @Phantom @static fun *.`<clinit>` (): void
    {
        // #problem: version-specific initialization

        initPhase1();
        initPhase2();
        initPhase3();

        /*
        init_as_java8();
        */
    }

}
