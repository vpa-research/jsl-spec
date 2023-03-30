libsl '1.1.0';


// === READ operations ===


define action LIST_COPY(
        aList: list<any>,
        from: int,
        to: int
    ): list<any>;

// Copies contents of the list into the provided array. Allows auto-resizing.
// Example behavior from Java: String[] x = arrList.toArray(new String[0]);

define action LIST_TO_ARRAY(
        srcList: list<any>,
        destArray: array<any>,
        from: int,
        to: int
    ): array<any>

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
