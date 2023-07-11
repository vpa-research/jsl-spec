//#! pragma: non-synthesizable
libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/lang/StringBuffer.lsl";
import "java/lang/StringBuilder.lsl";
import "java/lang/_interfaces.lsl";
import "java/util/function/_interfaces.lsl";
import "java/util/regex/Pattern.lsl";
import "java/util/regex/_interfaces.lsl";
import "java/util/stream/_interfaces.lsl";

import "list-actions.lsl";


// local semantic types



// automata

@implements(["java.util.regex.MatchResult"])
@public @final automaton Matcher: int
(
)
{
    // states and shifts

    initstate Initialized;


    // constructors

    @`package-private` constructor Matcher (@target self: Matcher)
    {
        action TODO();
    }


    @`package-private` constructor Matcher (@target self: Matcher, arg0: Pattern, arg1: CharSequence)
    {
        action TODO();
    }


    // utilities

    // static methods

    @static fun quoteReplacement (arg0: String): String
    {
        action TODO();
    }


    // methods

    fun appendReplacement (@target self: Matcher, arg0: StringBuffer, arg1: String): Matcher
    {
        action TODO();
    }


    fun appendReplacement (@target self: Matcher, arg0: StringBuilder, arg1: String): Matcher
    {
        action TODO();
    }


    fun appendTail (@target self: Matcher, arg0: StringBuffer): StringBuffer
    {
        action TODO();
    }


    fun appendTail (@target self: Matcher, arg0: StringBuilder): StringBuilder
    {
        action TODO();
    }


    fun end (@target self: Matcher): int
    {
        action TODO();
    }


    fun end (@target self: Matcher, arg0: String): int
    {
        action TODO();
    }


    fun end (@target self: Matcher, arg0: int): int
    {
        action TODO();
    }


    fun find (@target self: Matcher): boolean
    {
        action TODO();
    }


    fun find (@target self: Matcher, arg0: int): boolean
    {
        action TODO();
    }


    fun group (@target self: Matcher): String
    {
        action TODO();
    }


    fun group (@target self: Matcher, arg0: String): String
    {
        action TODO();
    }


    fun group (@target self: Matcher, arg0: int): String
    {
        action TODO();
    }


    fun groupCount (@target self: Matcher): int
    {
        action TODO();
    }


    fun hasAnchoringBounds (@target self: Matcher): boolean
    {
        action TODO();
    }


    fun hasTransparentBounds (@target self: Matcher): boolean
    {
        action TODO();
    }


    fun hitEnd (@target self: Matcher): boolean
    {
        action TODO();
    }


    fun lookingAt (@target self: Matcher): boolean
    {
        action TODO();
    }


    fun matches (@target self: Matcher): boolean
    {
        action TODO();
    }


    fun pattern (@target self: Matcher): Pattern
    {
        action TODO();
    }


    fun region (@target self: Matcher, arg0: int, arg1: int): Matcher
    {
        action TODO();
    }


    fun regionEnd (@target self: Matcher): int
    {
        action TODO();
    }


    fun regionStart (@target self: Matcher): int
    {
        action TODO();
    }


    fun replaceAll (@target self: Matcher, @Parameterized("java.util.regex.MatchResult, java.lang.String") arg0: Function): String
    {
        action TODO();
    }


    fun replaceAll (@target self: Matcher, arg0: String): String
    {
        action TODO();
    }


    fun replaceFirst (@target self: Matcher, @Parameterized("java.util.regex.MatchResult, java.lang.String") arg0: Function): String
    {
        action TODO();
    }


    fun replaceFirst (@target self: Matcher, arg0: String): String
    {
        action TODO();
    }


    fun requireEnd (@target self: Matcher): boolean
    {
        action TODO();
    }


    fun reset (@target self: Matcher): Matcher
    {
        action TODO();
    }


    fun reset (@target self: Matcher, arg0: CharSequence): Matcher
    {
        action TODO();
    }


    @ParameterizedResult("java.util.regex.MatchResult")
    fun results (@target self: Matcher): Stream
    {
        action TODO();
    }


    fun start (@target self: Matcher): int
    {
        action TODO();
    }


    fun start (@target self: Matcher, arg0: String): int
    {
        action TODO();
    }


    fun start (@target self: Matcher, arg0: int): int
    {
        action TODO();
    }


    fun toMatchResult (@target self: Matcher): MatchResult
    {
        action TODO();
    }


    fun toString (@target self: Matcher): String
    {
        action TODO();
    }


    fun useAnchoringBounds (@target self: Matcher, arg0: boolean): Matcher
    {
        action TODO();
    }


    fun usePattern (@target self: Matcher, arg0: Pattern): Matcher
    {
        action TODO();
    }


    fun useTransparentBounds (@target self: Matcher, arg0: boolean): Matcher
    {
        action TODO();
    }

}
