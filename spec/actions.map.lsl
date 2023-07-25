//#! pragma: non-synthesizable
libsl "1.1.0";

library any
    version "*"
    language "any"
    url "-";


// === LIFE-TIME management ===


define action MAP_NEW(
    ): map<any, any>;

// unused
define action MAP_FREE(
        aMap: map<any, any>
    ): void;


// === READ operations ===


define action MAP_GET(
        aMap: map<any, any>,
        key: any
    ): any;

define action MAP_HAS_KEY(
        aMap: map<any, any>,
        key: any
    ): bool;

define action MAP_SIZE(
        aMap: map<any, any>
    ): int32;


// === UPDATE operations ===


define action MAP_SET(
        aMap: map<any, any>,
        key: any,
        value: any
    ): any;


// === DELETE operations


define action MAP_REMOVE(
        aMap: map<any, any>,
        key: any
    ): void;
