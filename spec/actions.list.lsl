//#! pragma: non-synthesizable
libsl "1.1.0";

library any
    version "*"
    language "any"
    url "-";


// === READ operations ===


define action LIST_NEW(
    ): list<any>;

define action LIST_FIND(
        aList: list<any>,
        value: any,
        from: int32,
        to: int32
    ): int32;

define action LIST_GET(
        aList: list<any>,
        itemIndex: int32
    ): any;

define action LIST_SIZE(
        aList: list<any>
    ): int32;


// === UPDATE operations ===


define action LIST_COPY(
        src: list<any>,
        dst: list<any>,
        srcPos: int32,
        dstPos: int32,
        len: int32
    ): void;

define action LIST_INSERT_AT(
        aList: list<any>,
        itemIndex: int32,
        value: any
    ): void;

define action LIST_SET(
        aList: list<any>,
        itemIndex: int32,
        value: any
    ): void;


// === DELETE operations


define action LIST_FREE(
        aList: list<any>
    ): void;

define action LIST_REMOVE(
        aList: list<any>,
        itemIndex: int32
    ): void;
