libsl "1.1.0";

library "std" language "Java" version "11" url "-";

// DO NOT REMOVE!
import "generator-annotations.lsl";



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

define action OBJECT_EQUALS(
        a: Object,
        b: Object
    ): string;

define action OBJECT_TO_STRING(
        thing: Object
    ): string;

define action OBJECT_HASH_CODE(
        thing: Object
    ): int;



// === ANNOTATIONS ===



annotation Static ();

annotation Final ();

annotation Transient ();

annotation Private ();

annotation PackagePrivate ();

annotation Public ();

annotation Extends (
    fullClassName: string;
);

annotation Implements (
    fullInterfaceNames: array<string>;
);

annotation Throws (
    exceptionTypes: array<string> = [];
);



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

