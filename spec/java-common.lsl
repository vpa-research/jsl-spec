libsl '1.1.0';

library 'std:common' language 'Java' version '11' url '-';


// === TYPES ===


typealias boolean = bool;
typealias int     = int32;
typealias long    = int64;
typealias float   = float32;
typealias double  = float64;

@Alias('java.lang.Object')
typealias Object = *void;


// === CONSTANTS ===


val null: Object = 0;

val false: boolean = 0;
val true: boolean = 1;


// === ACTIONS ===


@NoReturn
define action THROW_NEW(
		exceptionType: string,
		params: any[]
	): void;

@NoReturn
define action THROW_VALUE(
		value: any
	): void;

@NoReturn
define action ERROR(
		message: string
	): void;

@NoReturn
define action TODO(): void;

@NoReturn
define action NOT_IMPLEMENTED(): void;

define action CALL(
		callable: Object,
		params: any[]
	): Object;
