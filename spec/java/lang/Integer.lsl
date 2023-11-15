//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Integer.java";

// imports

import java/lang/Class;
import java/lang/Comparable;
import java/lang/Number;


// primary semantic types

@FunctionalInterface("intValue")
@final type Integer
    is java.lang.Integer
    for Comparable, Number
{
    // WARNING: use 'intValue' to get primitive value

    @static fun *.valueOf(x: int): Number; // #problem: self-reference
}


// global aliases and type overrides

// note: this is a partial implementation, no need for additional constraints (abstract class) and synthetic methods (Comparable)
// @extends("java.lang.Number")
// @implements("java.lang.Comparable<Integer>")
@final type LSLInteger
    is java.lang.Integer
    for Integer
{
    @private @static val serialVersionUID: long = 1360826667806852920L;

    @public @static val MIN_VALUE: int = -2147483648;
    @public @static val MAX_VALUE: int =  2147483647;

    // #problem: unable to get reference to primitive type
    @public @static val TYPE: Class = action TYPE_OF("Integer"); // preventing recursion

    @public @static val SIZE: int = 32;
    @public @static val BYTES: int = 4;

    // WARNING: do not change!
    @static val digits: array<char> = [
        '0' , '1' , '2' , '3' , '4' , '5' ,
        '6' , '7' , '8' , '9' , 'a' , 'b' ,
        'c' , 'd' , 'e' , 'f' , 'g' , 'h' ,
        'i' , 'j' , 'k' , 'l' , 'm' , 'n' ,
        'o' , 'p' , 'q' , 'r' , 's' , 't' ,
        'u' , 'v' , 'w' , 'x' , 'y' , 'z' ,
    ];

    // WARNING: do not change!
    @static val DigitTens: array<char> = [
        '0', '0', '0', '0', '0', '0', '0', '0', '0', '0',
        '1', '1', '1', '1', '1', '1', '1', '1', '1', '1',
        '2', '2', '2', '2', '2', '2', '2', '2', '2', '2',
        '3', '3', '3', '3', '3', '3', '3', '3', '3', '3',
        '4', '4', '4', '4', '4', '4', '4', '4', '4', '4',
        '5', '5', '5', '5', '5', '5', '5', '5', '5', '5',
        '6', '6', '6', '6', '6', '6', '6', '6', '6', '6',
        '7', '7', '7', '7', '7', '7', '7', '7', '7', '7',
        '8', '8', '8', '8', '8', '8', '8', '8', '8', '8',
        '9', '9', '9', '9', '9', '9', '9', '9', '9', '9',
    ];

    // WARNING: do not change!
    @static val DigitOnes: array<char> = [
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    ];

    // WARNING: do not change!
    @static val sizeTable: array<int> = [
        9, 99, 999, 9999, 99999, 999999, 9999999, 99999999, 999999999, 2147483647
    ];
}
