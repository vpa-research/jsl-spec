//#! pragma: non-synthesizable
libsl "1.1.0";

library any
    version "*"
    language "any"
    url "-";


// === READ operations ===


define action MAP_NEW(
    ): map<any, any>;

define action MAP_SIZE(
        aMap: map<any, any>
    ): int32;


// === UPDATE operations ===


//-


// === DELETE operations


define action MAP_FREE(
        aMap: map<any, any>
    ): void;
