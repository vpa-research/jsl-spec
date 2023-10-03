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
    exceptionTypes: array<string>,
);

annotation synchronized ();

annotation varargs ();

annotation volatile ();

annotation strict ();

// NOTE: useful only for `CALL` action during "call target" resolution mechanisms
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


// === ACTIONS ===


// language-specific features

// note: result variable should be passed EXPLICITLY!
// usage example: action LOOP_FOR(i, 0, 10, +1, loop_body_proc(i, list, x, y));
define action LOOP_FOR (
        iterator: int32,   // variable!
        lowerBound: int32,
        upperBound: int32,
        step: int32,
        bodyProc: void     // subroutine call!
    ): void;


// note: result variable should be passed EXPLICITLY!
// usage example: action LOOP_WHILE(a < b, loop_body_proc(a));
define action LOOP_WHILE (
        predicate: bool,
        bodyProc: void   // subroutine call!
    ): void;


define action LOOP_BREAK (): void;


@StopsControlFlow
define action THROW_NEW (
        exceptionType: string,
        params: array<any>
    ): void;


@StopsControlFlow
define action THROW_VALUE (
        value: any
    ): void;


/*
Usage example:
action TRY_CATCH(
    _try_proc(),
    [
        ["java.lang.Error",     _catch_proc_a()],
        ["java.util.Exception", _catch_proc_b()],
    ]
);
*/
define action TRY_CATCH (
        tryBlock: void,               // subroutine call!
        catchTable: array<array<any>> // pairs of {name: str, handler: call}
    ): void;

// Use to get reference to the caught exception within the 'catch' section of 'try-catch' block.
// WARNING: applicable only within the exception handler ("catch") subroutine
define action CATCH_GET_EXCEPTION_REF (): any;


// work-arounds

define action CALL (
        callable: any,
        args: array<any>
    ): any;


define action CALL_METHOD (
        obj: any,
        methodName: string, // literal!
        args: array<any>
    ): any;


// helper methods built into the language runtime

define action OBJECT_EQUALS (
        a: any,
        b: any
    ): boolean;


define action OBJECT_HASH_CODE (
        value: any
    ): int;


define action OBJECT_TO_STRING (
        value: any
    ): string;


define action OBJECT_SAME_TYPE (
        a: any,
        b: any
    ): boolean;
