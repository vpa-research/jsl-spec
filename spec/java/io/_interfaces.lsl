//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/io";

// imports

import java/lang/_interfaces;


// semantic types

@interface type Closeable
    is java.io.Closeable
    for AutoCloseable
{
    @throws(["java.io.IOException"])
    fun *.close(): void;
}


@interface type Flushable
    is java.io.Flushable
    for Object
{
    @throws(["java.io.IOException"])
    fun *.flush(): void;
}


type OutputStream
    is java.io.OutputStream
    for Closeable, Flushable
{
    @throws(["java.io.IOException"])
    fun *.write(b: array<byte>): void;

    @throws(["java.io.IOException"])
    fun *.write(b: array<byte>, off: int, len: int): void;

    @throws(["java.io.IOException"])
    fun *.write(b: int): void;
}


type InputStream
    is java.io.InputStream
    for Closeable
{
    @throws(["java.io.IOException"])
    fun *.available(): int;

    fun *.mark(readlimit: int): void;

    fun *.markSupported(): boolean;

    @throws(["java.io.IOException"])
    fun *.read(): int;

    @throws(["java.io.IOException"])
    fun *.read(b: array<byte>): int;

    @throws(["java.io.IOException"])
    fun *.read(b: array<byte>, off: int, len: int): int;

    @throws(["java.io.IOException"])
    fun *.readAllBytes(): array<byte>;

    @throws(["java.io.IOException"])
    fun *.readNBytes(b: array<byte>, off: int, len: int): int;

    @throws(["java.io.IOException"])
    fun *.readNBytes(len: int): array<byte>;

    @throws(["java.io.IOException"])
    fun *.reset(): void;

    @throws(["java.io.IOException"])
    fun *.skip(n: long): long;

    @throws(["java.io.IOException"])
    fun *.transferTo(out: OutputStream): long;
}


type ObjectInputStream
    is java.io.ObjectInputStream
    for InputStream
{
}


type ObjectOutputStream
    is java.io.ObjectOutputStream
    for OutputStream
{
}


type PrintStream
    is java.io.PrintStream
    for Object
{
}


type PrintWriter
    is java.io.PrintWriter
    for Object
{
}
