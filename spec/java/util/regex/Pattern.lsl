//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections:regex`
    version "11"
    language "Java"
    url "-";

// imports

import java.common;
import java/lang/_interfaces;
import java/util/function/_interfaces;
import java/util/regex/Matcher;
import java/util/stream/_interfaces;

import list.actions;


// local semantic types

@implements(["java.io.Serializable"])
type Pattern is java.util.regex.Pattern for Object {
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

automaton PatternAutomaton: Pattern
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
        action TODO();
    }


    @ParameterizedResult("java.lang.String")
    fun asPredicate (@target self: Pattern): Predicate
    {
        action TODO();
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
    fun splitAsStream (@target self: Pattern, arg0: CharSequence): Stream
    {
        action TODO();
    }


    fun toString (@target self: Pattern): String
    {
        action TODO();
    }

}
