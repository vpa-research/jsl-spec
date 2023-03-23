libsl '1.1.0';


// === READ operations ===


define action LIST_COPY(
        aList: list<any>,
        from: int,
        to: int
    ): list<any>;

define action LIST_FIND(
        aList: list<any>,
        value: any,
        from: int,
        to: int,
        direction: int
    ): int;

define action LIST_GET(
        aList: list<any>,
        index: int
    ): any;

define action LIST_SIZE(
        aList: list<any>
    ): int;


// === UPDATE operations ===


define action LIST_INSERT_AT(
        aList: list<any>,
        index: int,
        value: any
    ): void;

define action LIST_RESIZE(
        aList: list<any>,
        newSize: int
    ): void;

define action LIST_SET(
        aList: list<any>,
        index: int,
        value: any
    ): void;


// === DELETE operations


define action LIST_REMOVE(
        aList: list<any>,
        index: int,
        count: int
    ): void;
