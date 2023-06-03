//#! pragma: non-synthesizable
libsl "1.1.0";

// TODO: remove debug code
library `?`
    version "11"
    language "Java"
    url "-";

import generator.annotations;


/// generator-specific actions


define action ASSUME (predicate: bool): void;


// specification development -related aspects

@StopsControlFlow
define action ERROR(message: string): void;

@StopsControlFlow
define action NOT_IMPLEMENTED(): void;

@StopsControlFlow
define action TODO(): void;
