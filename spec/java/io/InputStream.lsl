libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/io/InputStream.java";

// imports

import java/io/Closeable;
import java/io/OutputStream;


// primary semantic types

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
    fun *.transferTo(output: OutputStream): long;
}


// global aliases and type overrides

