libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/zip/CRC32.java";

// imports

import java/lang/Object;
import java/util/zip/Checksum;


// primary semantic types

@implements("java.util.zip.Checksum")
@public type CRC32
    is java.util.zip.CRC32
    for Object
{
}

// a replacement type for automata construction
@implements("java.util.zip.Checksum")
@public type LSLCRC32
    is java.util.zip.CRC32
    for CRC32
{
}