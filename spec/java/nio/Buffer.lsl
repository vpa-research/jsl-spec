//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/Buffer.java";

// imports

import java/lang/Object;


// primary semantic types

@abstract type Buffer
    is java.lang.Buffer
    for Object
{
    fun *.capacity(): int;

    fun *.position(): int;

    fun *.position(newPosition: int): any; //Buffer

    fun *.limit(): int;

    fun *.remaining(): int;

    fun *.hasRemaining(): boolean;

    fun *.isReadOnly(): boolean;

    fun *.hasArray(): boolean;

    fun *.array(): Object;

    fun *.arrayOffset(): int;

    fun *.isDirect(): boolean;

    // #problem: self-reference
    fun *.mark(): any; // Buffer

    // #problem: self-reference
    fun *.reset(): any; // Buffer

    // #problem: self-reference
    fun *.clear(): any; // Buffer

    // #problem: self-reference
    fun *.slice(): any; // Buffer

    // #problem: self-reference
    fun *.duplicate(): any; // Buffer

}


// global aliases and type overrides

