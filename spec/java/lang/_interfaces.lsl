//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

import java-common;


type Runnable is java.lang.Runnable for Object {
    fun run (): void;
}

@TypeMapping("java.lang.Throwable")
typealias Throwable = Object;    // #problem


// built-in types / boxing

@TypeMapping(builtin=true) typealias Boolean = bool;
@TypeMapping(builtin=true) typealias Integer = int32;
@TypeMapping(builtin=true) typealias Long    = int64;
@TypeMapping(builtin=true) typealias Float   = float32;
@TypeMapping(builtin=true) typealias Double  = float64;
@TypeMapping(builtin=true) typealias String  = string;
