//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/String.java";

// imports

import java/lang/Object;

import java/lang/String;


// automata

automaton StringAutomaton
(
    var value: array<byte> = null,
    var length: int = 0,
)
: LSLString
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // constructors
        `<init>` (LSLString),
        `<init>` (LSLString, String),
        `<init>` (LSLString, array<byte>),

        // static operations
        copyValueOf (array<char>),
        copyValueOf (array<char>, int, int),
        valueOf (Object),
        valueOf (boolean),
        valueOf (char),
        valueOf (array<char>),
        valueOf (array<char>, int, int),
        valueOf (double),
        valueOf (float),
        valueOf (int),
        valueOf (long),

        // instance methods
        concat,
        getBytes (LSLString),
        getBytes (LSLString, int, int, array<byte>, int),
        isEmpty,
        length,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _preconditionCheck (): void
    {
        action ASSUME(this.value != null);
        action ASSUME(action ARRAY_SIZE(this.value) <= 50); // #todo: use static final field
        //action ASSUME(action ARRAY_SIZE(this.value) <= STRING_LENGTH_MAX);
        action ASSUME(this.length == action ARRAY_SIZE(this.value));
    }


    // constructors

    constructor *.`<init>` (@target self: LSLString)
    {
        this.value = action ARRAY_NEW("byte", 0);
        this.length = 0;
    }


    constructor *.`<init>` (@target self: LSLString, original: String)
    {
        this.value = StringAutomaton(original).value;
        this.length = action ARRAY_SIZE(this.value);
    }


    constructor *.`<init>` (@target self: LSLString, bytes: array<byte>)
    {
        val len: int = action ARRAY_SIZE(bytes);

        this.length = len;
        this.value = action ARRAY_NEW("byte", len);
        action ARRAY_COPY(bytes, 0, this.value, 0, len);
    }


    // static methods

    @static fun *.copyValueOf (data: array<char>): String
    {
        result = action OBJECT_TO_STRING(data);
    }


    @static fun *.copyValueOf (data: array<char>, offset: int, count: int): String
    {
        val segment: array<char> = action ARRAY_NEW("char", count);
        action ARRAY_COPY(data, offset, segment, 0, count);

        result = action OBJECT_TO_STRING(segment);
    }


    @static fun *.valueOf (x: Object): String
    {
        result = action OBJECT_TO_STRING(x);
    }


    @static fun *.valueOf (x: boolean): String
    {
        result = action OBJECT_TO_STRING(x);
    }


    @static fun *.valueOf (x: char): String
    {
        result = action OBJECT_TO_STRING(x);
    }


    @static fun *.valueOf (data: array<char>): String
    {
        result = action OBJECT_TO_STRING(data);
    }


    @static fun *.valueOf (data: array<char>, offset: int, count: int): String
    {
        val segment: array<char> = action ARRAY_NEW("char", count);
        action ARRAY_COPY(data, offset, segment, 0, count);

        result = action OBJECT_TO_STRING(segment);
    }


    @static fun *.valueOf (x: double): String
    {
        result = action OBJECT_TO_STRING(x);
    }


    @static fun *.valueOf (x: float): String
    {
        result = action OBJECT_TO_STRING(x);
    }


    @static fun *.valueOf (x: int): String
    {
        result = action OBJECT_TO_STRING(x);
    }


    @static fun *.valueOf (x: long): String
    {
        result = action OBJECT_TO_STRING(x);
    }


    // methods

    fun *.concat (@target self: LSLString, str: String): String
    {
        _preconditionCheck();

        val otherVal: array<byte> = StringAutomaton(str).value;
        val otherLen: int = action ARRAY_SIZE(otherVal);

        if (otherLen == 0)
        {
            result = self as Object as String;
        }
        else
        {
            val newLength: int = this.length + otherLen;
            val newValue: array<byte> = action ARRAY_NEW("byte", newLength);

            action ARRAY_COPY(this.value, 0, newValue, 0, this.length);
            action ARRAY_COPY(otherVal, 0, newValue, this.length, otherLen);

            result = new StringAutomaton(state = Initialized,
                value = newValue,
                length = newLength
            );
        }
    }


    fun *.getBytes (@target self: LSLString): array<byte>
    {
        _preconditionCheck();

        result = this.value;
    }


    fun *.getBytes (@target self: LSLString, srcBegin: int, srcEnd: int, dst: array<byte>, dstBegin: int): void
    {
        if (srcBegin < 0)
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [srcBegin]);
        if (this.length < srcEnd)
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [srcEnd]);

        val count: int = srcEnd - srcBegin;
        if (count < 0)
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [count]);

        _preconditionCheck();

        action ARRAY_COPY(this.value, srcBegin, dst, dstBegin, count);
    }


    fun *.isEmpty (@target self: LSLString): boolean
    {
        result = this.length == 0;
    }


    fun *.length (@target self: LSLString): int
    {
        result = this.length;
    }


    // special: class initialization

    @static @Phantom fun *.`<clinit>` (): void
    {
        // nothing - use the original initialization (comparator)
    }

}
