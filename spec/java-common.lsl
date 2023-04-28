libsl "1.1.0";

library `std` language "Java" version "11" url "-";

// DO NOT REMOVE!
import generator-annotations;



// === ACTIONS ===



// specification development -related actions

@NoReturn
define action TODO(): void;

@NoReturn
define action NOT_IMPLEMENTED(): void;

@NoReturn
define action ERROR(message: string): void;


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
        callable: Object,
        params: array<any>
    ): Object;


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



// === ANNOTATIONS ===



annotation static ();

annotation final ();

annotation transient ();

annotation private ();

annotation packageprivate ();

annotation public ();

annotation extends (
    fullClassName: string;
);

annotation implements (
    fullInterfaceNames: array<string>;
);

annotation throws (
    exceptionTypes: array<string> = [];
    generic: bool = false;
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



@TypeMapping(builtin=true) typealias boolean = bool;
@TypeMapping(builtin=true) typealias int     = int32;
@TypeMapping(builtin=true) typealias long    = int64;
@TypeMapping(builtin=true) typealias float   = float32;
@TypeMapping(builtin=true) typealias double  = float64;
@TypeMapping(builtin=true) typealias Object  = *void;

