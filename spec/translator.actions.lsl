//#! pragma: non-synthesizable
libsl "1.1.0";

// TODO: remove debug code
library any
    version "*"
    language "*"
    url "-";

import translator.annotations;
import actions.array;
import actions.list;
//import actions.map; // #problem: types with multiple type parameters


/// generator-specific actions


define action ASSUME (
        predicate: bool
    ): void;


define action SYMBOLIC (
        valueType: string // literal!
    ): any;


define action SYMBOLIC_ARRAY (
        elementType: string, // literal!
        size: int32
    ): array<any>;


define action DEBUG_DO (
        code: string // literal!
    ): any;


// note: result variable may be shared
// usage example: action LOOP_FOR(i, 0, 10, +1, loop_body_proc(i, list, x, y));
define action LOOP_FOR (
        iterator: int32,   // variable!
        lowerBound: int32,
        upperBound: int32,
        step: int32,
        bodyProc: any      // subroutine call!
    ): void;


// note: result variable may be shared
// usage example: action LOOP_WHILE(a < b, loop_body_proc(a));
define action LOOP_WHILE (
        predicate: bool,
        bodyProc: any    // subroutine call!
    ): void;


define action LOOP_BREAK (): void;



/// specification development -related aspects


@StopsControlFlow
define action ERROR (
        message: string
    ): void;


@StopsControlFlow
define action NOT_IMPLEMENTED (
        reason: string
    ): void;


@StopsControlFlow
define action TODO (): void;

// do nothing explicitly but detectable by the translator if needed
define action DO_NOTHING (): void;
