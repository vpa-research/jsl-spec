//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/nio/channels/Channel.java";

// imports

import java/io/Closeable;


// primary semantic types

@interface type Channel
    is java.nio.channels.Channel
    for Closeable
{
}


// global aliases and type overrides

