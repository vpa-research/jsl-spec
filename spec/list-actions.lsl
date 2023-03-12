libsl '1.1.0';


define action LIST_FIND(
        aList: list<any>,
        value: any
    ): int;

define action LIST_GET(
        aList: list<any>,
        index: int
    ): any;

define action LIST_INSERT_AT(
        aList: list<any>,
        index: int,
        value: any
    ): void;

define action LIST_SET(
        aList: list<any>,
        index: int,
        value: any
    ): void;

define action LIST_SIZE(
        aList: list<any>
    ): int;

define action LIST_RESIZE(
        aList: list<any>,
        newSize: int
    ): void;

define action LIST_DUP(
        aList: list<any>
    ): list<any>;
    
define action LIST_REMOVE(
        aList: list<any>,
        index: int
    ): void;
