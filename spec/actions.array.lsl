//#! pragma: non-synthesizable
libsl "1.1.0";

library any
    version "*"
    language "any"
    url "-";


// === READ operations ===


define action ARRAY_GET(
        arr: array<any>,
        itemIndex: int32
    ): any;

define action ARRAY_NEW(
    ): array<any>;

define action ARRAY_SIZE(
        arr: array<any>
    ): int32;


// === UPDATE operations ===


define action ARRAY_FILL(
        arr: array<any>,
        value: any
    ): void;

define action ARRAY_COPY(
        src: array<any>,
        dst: array<any>,
        srcPos: int32,
        dstPos: int32,
        len: int32
    ): void;

define action ARRAY_SET(
        arr: array<any>,
        itemIndex: int32,
        value: any
    ): void;


// === DELETE operations


define action ARRAY_FREE(
        arr: array<any>
    ): void;
