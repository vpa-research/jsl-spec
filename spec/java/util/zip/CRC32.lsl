libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/zip/CRC32.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/nio/_interfaces;
import java/util/zip/_interfaces;


// local semantic types

@implements("java.util.zip.Checksum")
@public type CRC32
    is java.util.zip.CRC32
    for Object
{
}


// automata

automaton CRC32Automaton
(
)
: CRC32
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        CRC32,
    ];

    shift Initialized -> self by [
        // instance methods
        getValue,
        reset,
        update (CRC32, ByteBuffer),
        update (CRC32, array<byte>),
        update (CRC32, array<byte>, int, int),
        update (CRC32, int),
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.CRC32 (@target self: CRC32)
    {
        action TODO();
    }


    // static methods

    // methods

    fun *.getValue (@target self: CRC32): long
    {
        action TODO();
    }


    fun *.reset (@target self: CRC32): void
    {
        action TODO();
    }


    fun *.update (@target self: CRC32, buffer: ByteBuffer): void
    {
        action TODO();
    }


    // within java.util.zip.Checksum
    @default fun *.update (@target self: CRC32, b: array<byte>): void
    {
        action TODO();
    }


    fun *.update (@target self: CRC32, b: array<byte>, off: int, len: int): void
    {
        action TODO();
    }


    fun *.update (@target self: CRC32, b: int): void
    {
        action TODO();
    }

}