//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/AutoCloseable.java";

// imports

import java/lang/AutoCloseable;


// automata

automaton AutoCloseableAutomaton
(
)
: LSLAutoCloseable
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        close,
    ];

    // internal variables

    // utilities

    // constructors

    // static methods

    // methods

    @default fun close (@target self: LSLAutoCloseable): void
    {
        // UtBotJava: do nothing
    }
}
