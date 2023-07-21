//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "-";

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



// === CONSTANTS ===



//val null: Object = 0;

//val false: boolean = 0;
//val true: boolean = 1;



// === TYPES ===


/*@TypeMapping(builtin=true)*/ typealias boolean = bool;
/*@TypeMapping(builtin=true)*/ typealias byte    = int8;
/*@TypeMapping(builtin=true)*/ typealias short   = int16;
/*@TypeMapping(builtin=true)*/ typealias int     = int32;
/*@TypeMapping(builtin=true)*/ typealias long    = int64;
/*@TypeMapping(builtin=true)*/ typealias float   = float32;
/*@TypeMapping(builtin=true)*/ typealias double  = float64;
/*@TypeMapping(builtin=true)*/
type Object is java.lang.Object for Object {}


// === ACTIONS ===


// language-specific features

@StopsControlFlow
define action THROW_NEW(
        exceptionType: string,
        params: array<any>
    ): void;

@StopsControlFlow
define action THROW_VALUE(
        value: any
    ): void;


// work-arounds

define action CALL(
        callable: any,
        params: array<any>
    ): any;


// "ad-hoc" solutions

// the same as something like: return a == b || (a != null && a.equals(b))
define action OBJECT_EQUALS(
        a: Object,
        b: Object
    ): boolean;

define action OBJECT_TO_STRING(
        thing: Object
    ): string;

define action OBJECT_HASH_CODE(
        thing: Object
    ): int;
