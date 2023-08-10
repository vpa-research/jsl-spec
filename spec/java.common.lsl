//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master";

// DO NOT REMOVE!
import translator.annotations;
import translator.actions;



// === ANNOTATIONS ===



annotation static ();

annotation final ();

annotation transient ();

annotation private ();

annotation packageprivate ();

annotation public ();

annotation extends (
    canonicalClassName: string,
);

annotation implements (
    canonicalInterfaceName: string,
);

annotation throws (
    exceptionTypes: array<string> = [],
    generic: bool = false,
);

annotation synchronized ();

annotation varargs ();

annotation volatile ();

annotation strict ();

annotation FunctionalInterface (
    callableName: string = null
);



// === TYPES ===


typealias boolean = bool;
typealias byte    = int8;
typealias short   = int16;
typealias int     = int32;
typealias long    = int64;
typealias float   = float32;
typealias double  = float64;

type Object is java.lang.Object for Object
{
    // WARNING: use OBJECT_HASH_CODE and OBJECT_EQUALS actions instead of calling these methods directly
}


// === ACTIONS ===


// language-specific features


@StopsControlFlow
define action THROW_NEW (
        exceptionType: string,
        params: array<any>
    ): void;

@StopsControlFlow
define action THROW_VALUE (
        value: any
    ): void;




// work-arounds


define action CALL (
        callable: any,
        args: array<any>
    ): any;


define action CALL_METHOD (
        obj: any,           // variable!
        methodName: string, // literal!
        args: array<any>
    ): any;



// helper methods in runtime


define action OBJECT_EQUALS(
        a: any,
        b: any
    ): boolean;

define action OBJECT_TO_STRING(
        value: any
    ): string;

define action OBJECT_HASH_CODE(
        value: any
    ): int;
