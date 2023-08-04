//#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/tree/master/src/java.base/share/classes/java/util/regex";

// imports

import java.common;
import java/lang/_interfaces;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// local semantic types

type MatchResult
    is java.util.regex.MatchResult
    for Object
{
}


@implements("java.util.regex.MatchResult")
@final type Matcher
    is java.util.regex.Matcher
    for MatchResult
{
}


@implements("java.io.Serializable")
type Pattern
    is java.util.regex.Pattern
    for Object
{
    @private @static val serialVersionUID: long = 1; // #problem: should be 5073258162644648461

    @public @static val CANON_EQ: int = 128;
    @public @static val CASE_INSENSITIVE: int = 2;
    @public @static val COMMENTS: int = 4;
    @public @static val DOTALL: int = 32;
    @public @static val LITERAL: int = 16;
    @public @static val MULTILINE: int = 8;
    @public @static val UNICODE_CASE: int = 64;
    @public @static val UNICODE_CHARACTER_CLASS: int = 256;
    @public @static val UNIX_LINES: int = 1;
}



// automata

automaton MatcherAutomaton
(
    var pattern: Pattern,
)
: Matcher
{
    // states and shifts

    initstate Initialized;


    // constructors

    /*@packagePrivate*/ constructor Matcher (@target self: Matcher)
    {
        action TODO();
    }


    /*@packagePrivate*/ constructor Matcher (@target self: Matcher, arg0: Pattern, arg1: CharSequence)
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




automaton PatternAutomaton
: Pattern
{
    // states and shifts

    initstate Initialized;


    // constructors

    @private constructor Pattern (@target self: Pattern, arg0: String, arg1: int)
    {
        action TODO();
    }


    // utilities

    // static methods

    @static fun compile (arg0: String): Pattern
    {
        action TODO();
    }


    @static fun compile (arg0: String, arg1: int): Pattern
    {
        action TODO();
    }


    @static fun matches (arg0: String, arg1: CharSequence): boolean
    {
        action TODO();
    }


    @static fun quote (arg0: String): String
    {
        action TODO();
    }


    // methods

    @ParameterizedResult("java.lang.String")
    fun asMatchPredicate (@target self: Pattern): Predicate
    {
        // #problem: a lambda object should be returned here
        // #solution: a new type with automaton with a single method
        action NOT_IMPLEMENTED();
    }


    @ParameterizedResult("java.lang.String")
    fun asPredicate (@target self: Pattern): Predicate
    {
        // #problem: a lambda object should be returned here
        // #solution: a new type with automaton with a single method
        action NOT_IMPLEMENTED();
    }


    fun flags (@target self: Pattern): int
    {
        action TODO();
    }


    fun matcher (@target self: Pattern, arg0: CharSequence): Matcher
    {
        action TODO();
    }


    fun pattern (@target self: Pattern): String
    {
        action TODO();
    }


    fun split (@target self: Pattern, arg0: CharSequence): array<String>
    {
        action TODO();
    }


    fun split (@target self: Pattern, arg0: CharSequence, arg1: int): array<String>
    {
        action TODO();
    }


    @ParameterizedResult("java.lang.String")
    fun splitAsStream (@target self: Pattern, @final input: CharSequence): Stream
    {
        action TODO();
    }


    fun toString (@target self: Pattern): String
    {
        action TODO();
    }

}
