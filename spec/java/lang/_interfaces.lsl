//#! pragma: non-synthesizable
libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";


@TypeMapping("java.lang.Runnable")
typealias Runnable = Object;    // #problem

@TypeMapping("java.lang.Throwable")
typealias Throwable = Object;    // #problem


// built-in types / boxing

@TypeMapping(builtin=true) typealias Boolean = bool;
@TypeMapping(builtin=true) typealias Integer = int32;
@TypeMapping(builtin=true) typealias Long    = int64;
@TypeMapping(builtin=true) typealias Float   = float32;
@TypeMapping(builtin=true) typealias Double  = float64;
@TypeMapping(builtin=true) typealias String  = string;
