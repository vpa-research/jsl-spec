//#! pragma: non-synthesizable
libsl "1.1.0";

// TODO: remove debug code
library any
    version "11"
    language "Java"
    url "-";

import translator.annotations;
import list.actions;
//import map.actions;


/// generator-specific actions


define action ASSUME (predicate: bool): void;


define action ARRAY_LENGTH(arr: array<any>): int32;

define action ARRAY_GET(arr: array<any>, index: int32): any;

define action ARRAY_SET(arr: array<any>, index: int32, value: any): void;


// usage example: action FOR(0, 10, +1, "loop_1", [list, x, y]);
define action FOR(
    lowerBound: int,
    upperBound: int,
    step: int,
    bodyProcName: string,
    procArgs: array<any>
): void;

// usage example: action WHILE("loop_condition", [a, b], "loop_body", [a]);
define action WHILE(
    predicateProcName: string,
    predicateArgs: array<any>,
    bodyProcName: string,
    bodyArgs: array<any>
): void;

// eliminates subroutine using its body as an element for loop structure (condition or body)
annotation LoopComponent();


// specification development -related aspects

@StopsControlFlow
define action ERROR(message: string): void;

@StopsControlFlow
define action NOT_IMPLEMENTED(): void;

@StopsControlFlow
define action TODO(): void;
