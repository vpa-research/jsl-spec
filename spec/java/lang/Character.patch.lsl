//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/Character.java";
    // other url: https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/Character.java

// imports

import java/lang/Character;


// automata

automaton CharacterAutomaton
(
    var value: char = '?', // WARNING: do not rename or change the type!
)
: LSLCharacter
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // constructors
        `<init>`,

        // static operations
        isWhitespace (char),
        toLowerCase (char),
        toUpperCase (char),
        valueOf,

        // instance methods
        charValue,
    ];

    // internal variables

    // utilities

    // constructors

    constructor *.`<init>` (@target self: LSLCharacter, c: char)
    {
        this.value = c;
    }


    // static methods

    @static fun *.isWhitespace (ch: char): boolean
    {
        // #problem: character literal parsing
        if (ch == ' ' || ch == CHAR_SN || ch == CHAR_ST || ch == CHAR_SF || ch == CHAR_SR)
            result = true;
        else
            result = false;
    }


    @static fun *.toLowerCase (ch: char): char
    {
        if ((ch >= 'A') && (ch <= 'Z'))
            result = (ch - 'A' + 'a') as char;
        else
            result = ch;
    }


    @static fun *.toUpperCase (ch: char): char
    {
        if ((ch >= 'a') && (ch <= 'z'))
            result = (ch - 'a' + 'A') as char;
        else
            result = ch;
    }


    @static fun *.valueOf (c: char): Character
    {
        result = new CharacterAutomaton(state = Initialized,
            value = c,
        );
    }


    // methods

    fun *.charValue (@target self: LSLCharacter): char
    {
        result = this.value;
    }

}
