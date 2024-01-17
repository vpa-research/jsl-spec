//#! pragma: non-synthesizable
libsl "1.1.0";

library any
    version "*"
    language "any"
    url "-";


// === LIFE-TIME management ===


define action ARRAY_NEW (
        typeName: string, // literal!
        size: int32
    ): array<any>;

// unused
define action ARRAY_FREE (
        arr: array<any>
    ): void;


// === READ operations ===


define action ARRAY_SIZE (
        arr: array<any>
    ): int32;


// === UPDATE operations ===


// #question: do we actually need this?
define action ARRAY_FILL (
        arr: array<any>,
        value: any
    ): void;

// WARNING: do range checks ahead of time!
define action ARRAY_FILL_RANGE (
        arr: array<any>,
        fromIndex: int32,
        toIndex: int32,
        value: any
    ): void;

define action ARRAY_COPY (
        src: array<any>,
        srcPos: int32,
        dst: array<any>,
        dstPos: int32,
        count: int32
    ): void;


// === DELETE operations


// -
