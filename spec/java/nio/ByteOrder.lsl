libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/ByteOrder.java";

// imports

import java/lang/Object;
import java/lang/String;


// local semantic types
@public @final type ByteOrder
    is java.nio.ByteOrder
    for Object
{
    @static fun *.nativeOrder (): Object; // #problem: self-reference
}


@final type LSLByteOrder
    is java.nio.ByteOrder
    for ByteOrder
{
    @static @public var BIG_ENDIAN: Object = null;
    @static @public var LITTLE_ENDIAN: Object = null;
}
