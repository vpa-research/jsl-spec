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
    @static @final @public var BIG_ENDIAN: Object = new ByteOrderAutomaton(state = Initialized, name = "BIG_ENDIAN");
    @static @final @public var LITTLE_ENDIAN: Object = new ByteOrderAutomaton(state = Initialized, name = "LITTLE_ENDIAN");

    @static fun *.nativeOrder (): ByteOrder;
}


@final type LSLByteOrder
    is java.nio.ByteOrder
    for Object
{
}
