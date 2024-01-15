libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/DirectByteBufferR.java";

// imports

//import java/nio/DirectByteBuffer;
import sun/nio/ch/DirectBuffer;


// local semantic types
@GenerateMe
//@extends("java.nio.DirectByteBuffer")
@implements("sun.nio.ch.DirectBuffer")
type DirectByteBufferR
    is java.nio.DirectByteBufferR
    for DirectBuffer // DirectByteBuffer,
{
}


@GenerateMe
//@extends("java.nio.DirectByteBuffer")
@implements("sun.nio.ch.DirectBuffer")
@public type LSLDirectByteBufferR
    is java.nio.DirectByteBufferR
    for DirectByteBufferR
{
}
