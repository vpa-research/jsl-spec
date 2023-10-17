//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/zip/Checksum.java";

// imports

import java/lang/Object;
import java/nio/ByteBuffer;


// local semantic types

@interface type Checksum
    is java.util.zip.Checksum
    for Object
{
    fun *.update(b: int): void;

    fun *.update (buffer: ByteBuffer): void;

    fun *.update(b: array<byte>, off: int, len: int): void;

    fun *.update (b: array<byte>): void;

    fun *.getValue(): long;

    fun *.reset(): void;

}