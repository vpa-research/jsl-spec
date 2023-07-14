//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

import java.common;

// built-in types / boxing

//@TypeMapping(builtin=true)
type Object is java.lang.Object for Object {}

//@TypeMapping(builtin=true)
type Boolean is java.lang.Boolean for Object, bool {}

//@TypeMapping(builtin=true)
type Integer is java.lang.Integer for Object, int32 {}

//@TypeMapping(builtin=true)
type Long is java.lang.Long for Object, int64 {}

//@TypeMapping(builtin=true)
type Float is java.lang.Float for Object, float32 {}

//@TypeMapping(builtin=true)
type Double is java.lang.Double for Object, float64 {}

//@TypeMapping(builtin=true)
type String is java.lang.String for Object, string {}


// general interfaces

type Runnable is java.lang.Runnable for Object {
    fun run (): void;
}

@TypeMapping("java.lang.Throwable")
typealias Throwable = Object;    // #problem


@Parameterized(["T"])
type Iterable
    is java.lang.Iterable
    for Object
{
}

