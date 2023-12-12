//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/jdk/internal/misc/VM.java";

// imports

import java/lang/Object;
import java/lang/String;
import java/util/Map;
import java/util/Properties;


// primary semantic types

type VM
    is jdk.internal.misc.VM
    for Object
{
    @static fun *.initLevel(): int;
    @static fun *.initLevel(value: int): void;

    @static fun *.isModuleSystemInited(): boolean;
    @static fun *.isBooted(): boolean;
    @static fun *.isShutdown(): boolean;

    @static fun *.shutdown(): boolean;

    @static fun *.getSavedProperty(key: String): String;
    @static fun *.getSavedProperties(): Map;

    @static fun *.saveAndRemoveProperties(props: Properties);

    @static fun *.initializeOSEnvironment(): void;

    @static fun *.getRuntimeArguments(): array<String>;
}


val VM_JAVA_LANG_SYSTEM_INITED: int     = 1;
val VM_MODULE_SYSTEM_INITED: int        = 2;
val VM_SYSTEM_LOADER_INITIALIZING: int  = 3;
val VM_SYSTEM_BOOTED: int               = 4;
val VM_SYSTEM_SHUTDOWN: int             = 5;


// global aliases and type overrides

type LSLVM
    is jdk.internal.misc.VM
    for VM
{
    @private @static @volatile var initLevel: int = 0; // WARNING: do not rename or change the type!
}

