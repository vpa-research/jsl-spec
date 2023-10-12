libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/zip/Checksum.java";

// imports

import java.common;
import java/nio/ByteBuffer;


// local semantic types

@interface type Checksum
    is java.util.zip.Checksum
    for Object
{
    fun *.update(@target self: Checksum, b: int): void;

    fun *.update (@target self: Checksum, buffer: ByteBuffer): void;

    fun *.update(@target self: Checksum, b: array<byte>, off: int, len: int): void;

    fun *.update (@target self: Checksum, b: array<byte>): void;

    fun *.getValue(@target self: Checksum): long;

    fun *.reset(@target self: Checksum): void;

}