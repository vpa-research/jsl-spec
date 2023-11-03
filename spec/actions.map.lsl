//#! pragma: non-synthesizable
libsl "1.1.0";

library any
    version "*"
    language "any"
    url "-";


// === LIFE-TIME management ===


// NOTE: uses `Object.equals` method for key comparison
define action MAP_NEW (): map<any, any>;

// NOTE: uses `==` (equals) operator on object references for key comparison
define action IDENTITY_MAP_NEW (): map<any, any>;

// unused
define action MAP_FREE (
        aMap: map<any, any>
    ): void;


// === READ operations ===


// NOTE: more efficient (and internal type aware) version of "MAP_NEW + MAP_UNION_WITH"
define action MAP_CLONE (
        aMap: map<any, any>
    ): map<any, any>;

define action MAP_GET (
        aMap: map<any, any>,
        key: any
    ): any;

// WARNING: check if map is empty or not before calling this
define action MAP_GET_ANY_KEY (
        aMap: map<any, any>
    ): any;

define action MAP_HAS_KEY (
        aMap: map<any, any>,
        key: any
    ): bool;

define action MAP_SIZE (
        aMap: map<any, any>
    ): int32;


// === UPDATE operations ===


define action MAP_INTERSECT_WITH (
        receiver: map<any, any>,
        otherSource: map<any, any>
    ): void;

define action MAP_SET (
        aMap: map<any, any>,
        key: any,
        value: any
    ): void;

define action MAP_UNITE_WITH (
        receiver: map<any, any>,
        otherSource: map<any, any>
    ): void;


// === DELETE operations


define action MAP_REMOVE (
        aMap: map<any, any>,
        key: any
    ): void;
