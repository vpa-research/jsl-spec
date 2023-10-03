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
import actions.map;


/// USVM-specific actions

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



/// specification development -related aspects

define action DEBUG_DO (
        code: string // literal!
    ): any;


// NOTE: a unique number will be produced on every call
define action GUID_NEXT (
    ): int32;


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
