//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";
// NOTE: additional url - https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/strings/UtStringBuilder.java

// imports

import java/lang/Character;
import java/lang/StringBuffer;
import java/lang/Runnable;
import java/util/stream/IntStream;

import java/lang/StringBuilder;


// automata

automaton StringBuilderAutomaton
(
    var value: array<char> = null, // WARNING: do not rename or change the type!
    var count: int = 0             // WARNING: do not rename or change the type!
)
: LSLStringBuilder
{
    // states and shifts

    initstate Initialized;  // NOTE: target type is being used too frequently - disabling automata features

    shift Initialized -> self by [
        // constructors
        `<init>` (LSLStringBuilder),
        `<init>` (LSLStringBuilder, CharSequence),
        `<init>` (LSLStringBuilder, String),
        `<init>` (LSLStringBuilder, int),

        // instance methods
        append (LSLStringBuilder, CharSequence),
        append (LSLStringBuilder, CharSequence, int, int),
        append (LSLStringBuilder, Object),
        append (LSLStringBuilder, String),
        append (LSLStringBuilder, StringBuffer),
        append (LSLStringBuilder, boolean),
        append (LSLStringBuilder, char),
        append (LSLStringBuilder, array<char>),
        append (LSLStringBuilder, array<char>, int, int),
        append (LSLStringBuilder, double),
        append (LSLStringBuilder, float),
        append (LSLStringBuilder, int),
        append (LSLStringBuilder, long),
        appendCodePoint,
        capacity,
        charAt,
        chars,
        codePointAt,
        codePointBefore,
        codePointCount,
        codePoints,
        compareTo,
        delete,
        deleteCharAt,
        ensureCapacity,
        getChars,
        getValue,
        indexOf (LSLStringBuilder, String),
        indexOf (LSLStringBuilder, String, int),
        insert (LSLStringBuilder, int, CharSequence),
        insert (LSLStringBuilder, int, CharSequence, int, int),
        insert (LSLStringBuilder, int, Object),
        insert (LSLStringBuilder, int, String),
        insert (LSLStringBuilder, int, boolean),
        insert (LSLStringBuilder, int, char),
        insert (LSLStringBuilder, int, array<char>),
        insert (LSLStringBuilder, int, array<char>, int, int),
        insert (LSLStringBuilder, int, double),
        insert (LSLStringBuilder, int, float),
        insert (LSLStringBuilder, int, int),
        insert (LSLStringBuilder, int, long),
        lastIndexOf (LSLStringBuilder, String),
        lastIndexOf (LSLStringBuilder, String, int),
        length,
        offsetByCodePoints,
        replace,
        reverse,
        setCharAt,
        setLength,
        subSequence,
        substring (LSLStringBuilder, int),
        substring (LSLStringBuilder, int, int),
        toString,
        trimToSize,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _init (): void
    {
        this.value = action ARRAY_NEW("char", STRINGBUILDER_LENGTH_MAX);
    }


    @AutoInline @Phantom proc _preconditionCheck (): void
    {
        // #question: do we need ALL of that?

        action ASSUME(this.value != null);
        action ASSUME(action ARRAY_SIZE(this.value) <= STRINGBUILDER_LENGTH_MAX);
        action ASSUME(this.count <= action ARRAY_SIZE(this.value));
        action ASSUME(this.count >= 0);
    }


    // WARNING: seq should NOT be NULL!
    proc _appendCharSequence (seq: CharSequence, seqStart: int, seqEnd: int): void
    {
        if ((seqStart < 0) || (seqStart > seqEnd) || (seqEnd > action CALL_METHOD(seq, "length", [])))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        // trim long strings
        val avaiable: int = action ARRAY_SIZE(this.value) - this.count;
        var len: int = seqEnd - seqStart;
        if (len > avaiable)
            len = avaiable;

        if (len > 0)
        {
            var str: String = null;
            if (seq is String)
                str = seq as String;
            else
                str = action OBJECT_TO_STRING(seq);

            // note: UtBot implementation
            val chars: array<char> = action CALL_METHOD(str, "toCharArray", []);

            action ARRAY_COPY(chars, seqStart, this.value, this.count, len);
            this.count += len;
        }
    }


    // WARNING: validate indices before passing into this subroutine!
    proc _asString (posStart: int, posEnd: int): String
    {
        val len: int = posEnd - posStart;
        if (len == 0)
        {
            result = "";
        }
        else
        {
            val symbols: array<char> = action ARRAY_NEW("char", len);
            action ARRAY_COPY(this.value, posStart, symbols, 0, len);
            result = action OBJECT_TO_STRING(this.value);
        }
    }


    @KeepVisible proc _asString (): String
    {
        val len: int = this.count;
        if (len == 0)
        {
            result = "";
        }
        else if (len == action ARRAY_SIZE(this.value))
        {
            result = action OBJECT_TO_STRING(this.value);
        }
        else
        {
            val symbols: array<char> = action ARRAY_NEW("char", len);
            action ARRAY_COPY(this.value, 0, symbols, 0, len);
            result = action OBJECT_TO_STRING(this.value);
        }
    }


    proc _insertCharSequence (offset: int, seq: CharSequence, seqStart: int, seqEnd: int): void
    {
        if ((seqStart < 0) || (seqStart > seqEnd) || (seqEnd > action CALL_METHOD(seq, "length", [])) || (offset > this.count))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        // trim long strings
        val avaiable: int = action ARRAY_SIZE(this.value) - offset;
        var len: int = seqEnd - seqStart;
        if (len > avaiable)
            len = avaiable;

        if (len > 0)
        {
            val avaiableForLeftovers: int = avaiable - len;
            if (avaiableForLeftovers > 0)
            {
                var rightLeftovers: int = this.count - offset;
                if (rightLeftovers > avaiableForLeftovers)
                    rightLeftovers = avaiableForLeftovers;

                if (rightLeftovers > 0)
                {
                    val rightIndex: int = offset + 1;
                    action ARRAY_COPY(this.value, rightIndex, this.value, rightIndex + len, rightLeftovers);
                }
            }

            var str: String = null;
            if (seq is String)
                str = seq as String;
            else
                str = action OBJECT_TO_STRING(seq);

            val chars: array<char> = action CALL_METHOD(str, "toCharArray", []);

            action ARRAY_COPY(chars, seqStart, this.value, offset, len);
            this.count += len;
        }
    }


    proc _deleteChars (start: int, end: int): void
    {
        if ((start < 0) || (start > end) || (end > this.count))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        val leftovers: int = this.count - end;
        if (leftovers > 0)
            action ARRAY_COPY(this.value, end, this.value, start, leftovers);

        this.count -= end - start;
    }


    // constructors

    constructor *.`<init>` (@target self: LSLStringBuilder)
    {
        _init();
    }


    constructor *.`<init>` (@target self: LSLStringBuilder, seq: CharSequence)
    {
        if (seq == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _init();

        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));
    }


    constructor *.`<init>` (@target self: LSLStringBuilder, str: String)
    {
        if (str == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _init();

         _appendCharSequence(str, 0, action CALL_METHOD(str, "length", []));
    }


    constructor *.`<init>` (@target self: LSLStringBuilder, cap: int)
    {
        if (cap < 0)
            action THROW_NEW("java.lang.NegativeArraySizeException", []);

        // just an arbitrary limit that can be set externaly by the user
        if (cap > 1073741823) // Integer.MAX_VALUE / 2
            action THROW_NEW("java.lang.OutOfMemoryError", ["Requested array size exceeds VM limit"]);

        _init();
    }


    // methods

    fun *.append (@target self: LSLStringBuilder, seq: CharSequence): LSLStringBuilder
    {
        _preconditionCheck();

        if (seq == null)
            _appendCharSequence("null", 0, 4);
        else
            _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, seq: CharSequence, start: int, end: int): LSLStringBuilder
    {
        _preconditionCheck();

        if (seq == null)
            _appendCharSequence("null", start, end);
        else
            _appendCharSequence(seq, start, end);

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, obj: Object): LSLStringBuilder
    {
        _preconditionCheck();

        if (obj == null)
        {
            _appendCharSequence("null", 0, 4);
        }
        else
        {
            val seq: String = action OBJECT_TO_STRING(obj);
            _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));
        }

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, str: String): LSLStringBuilder
    {
        _preconditionCheck();

        if (str == null)
            _appendCharSequence("null", 0, 4);
        else
            _appendCharSequence(str, 0, action CALL_METHOD(str, "length", []));

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, sb: StringBuffer): LSLStringBuilder
    {
        _preconditionCheck();

        if (sb == null)
        {
            _appendCharSequence("null", 0, 4);
        }
        else
        {
            val seq: String = action OBJECT_TO_STRING(sb);
            _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));
        }

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, x: boolean): LSLStringBuilder
    {
        _preconditionCheck();

        if (x)
            _appendCharSequence("true", 0, 4);
        else
            _appendCharSequence("false", 0, 5);

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, x: char): LSLStringBuilder
    {
        _preconditionCheck();

        if (this.count < action ARRAY_SIZE(this.value))
        {
            this.value[this.count] = x;
            this.count += 1;
        }

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, str: array<char>): LSLStringBuilder
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(str);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, str: array<char>, offset: int, len: int): LSLStringBuilder
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(str);
        _appendCharSequence(seq, offset, len);

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, x: double): LSLStringBuilder
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, x: float): LSLStringBuilder
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, x: int): LSLStringBuilder
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    fun *.append (@target self: LSLStringBuilder, x: long): LSLStringBuilder
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    fun *.appendCodePoint (@target self: LSLStringBuilder, codePoint: int): LSLStringBuilder
    {
        _preconditionCheck();

        val cnt: int = this.count;
        val len: int = action ARRAY_SIZE(this.value);

        if (action CALL_METHOD(null as Character, "isBmpCodePoint", [codePoint]))
        {
            // trim too long strings
            if (cnt + 1 <= len)
            {
                this.value[cnt] = codePoint as char;

                this.count = cnt + 1;
            }
        }
        else if (action CALL_METHOD(null as Character, "isValidCodePoint", [codePoint]))
        {
            // trim too long strings
            if (cnt + 2 <= len)
            {
                this.value[cnt + 1] = action CALL_METHOD(null as Character, "lowSurrogate",  [codePoint]);
                this.value[cnt]     = action CALL_METHOD(null as Character, "highSurrogate", [codePoint]);

                this.count = cnt + 2;
            }
        }
        else
        {
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }

        result = self;
    }


    fun *.capacity (@target self: LSLStringBuilder): int
    {
        _preconditionCheck();

        result = action ARRAY_SIZE(this.value);
    }


    fun *.charAt (@target self: LSLStringBuilder, index: int): char
    {
        _preconditionCheck();

        if ((index < 0) || (index >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = this.value[index];
    }


    // within java.lang.AbstractStringBuilder
    fun *.chars (@target self: LSLStringBuilder): IntStream
    {
        _preconditionCheck();

        val len: int = this.count;
        val intValues: array<int> = action ARRAY_NEW("int", len);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            _toIntArray_loop(i, intValues)
        );

        result = new IntStreamAutomaton(state = Initialized,
            storage = intValues,
            length = len,
            closeHandlers = action LIST_NEW()
        );
    }

    @Phantom proc _toIntArray_loop(i: int, intValues: array<int>): void
    {
        intValues[i] = this.value[i] as int;
    }


    fun *.codePointAt (@target self: LSLStringBuilder, index: int): int
    {
        _preconditionCheck();

        if ((index < 0) || (index >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [index]);

        result = action CALL_METHOD(null as Character, "codePointAt", [this.value, index, this.count]);
    }


    fun *.codePointBefore (@target self: LSLStringBuilder, index: int): int
    {
        _preconditionCheck();

        val i: int = index - 1;
        if ((i < 0) || (i >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [index]);

        result = action CALL_METHOD(null as Character, "codePointBefore", [this.value, index, 0]);
    }


    fun *.codePointCount (@target self: LSLStringBuilder, beginIndex: int, endIndex: int): int
    {
        _preconditionCheck();

        if ((beginIndex < 0) || (beginIndex > endIndex) || (endIndex > this.count))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        result = action CALL_METHOD(null as Character, "codePointCount", [this.value, beginIndex, endIndex - beginIndex]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.codePoints (@target self: LSLStringBuilder): IntStream
    {
        _preconditionCheck();

        val len: int = this.count;
        val intValues: array<int> = action ARRAY_NEW("int", len);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, len, +1,
            _toIntArray_loop(i, intValues)
        );

        result = new IntStreamAutomaton(state = Initialized,
            storage = intValues,
            length = len,
            closeHandlers = action LIST_NEW()
        );
    }


    fun *.compareTo (@target self: LSLStringBuilder, another: LSLStringBuilder): int
    {
        _preconditionCheck();

        if (another == self)
        {
            result = 0;
        }
        else
        {
            val thisString: String = _asString();
            val anotherString: String = StringBuilderAutomaton(another)._asString();

            result = action CALL_METHOD(thisString, "compareTo", [anotherString]);
        }
    }


    fun *.delete (@target self: LSLStringBuilder, start: int, end: int): LSLStringBuilder
    {
        _preconditionCheck();

        _deleteChars(start, end);

        result = self;
    }


    fun *.deleteCharAt (@target self: LSLStringBuilder, index: int): LSLStringBuilder
    {
        _preconditionCheck();

        _deleteChars(index, index + 1);

        result = self;
    }


    fun *.ensureCapacity (@target self: LSLStringBuilder, minimumCapacity: int): void
    {
        // note: UtBot implementation
        action DO_NOTHING();
    }


    fun *.getChars (@target self: LSLStringBuilder, srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void
    {
        _preconditionCheck();

        if ((srcBegin < 0) || (srcBegin > srcEnd) || (srcEnd > this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        val len: int = srcEnd - srcBegin;

        if (dst == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        if ((dstBegin < 0) || (dstBegin + len > action ARRAY_SIZE(dst)))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        if (len > 0)
            action ARRAY_COPY(this.value, srcBegin, dst, dstBegin, len);
    }


    // UtBot note: Needed by String for the contentEquals method
    fun *.getValue (@target self: LSLStringBuilder): array<char>
    {
        _preconditionCheck();

        result = this.value;
    }


    fun *.indexOf (@target self: LSLStringBuilder, str: String): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "indexOf", [str, 0]);
    }


    fun *.indexOf (@target self: LSLStringBuilder, str: String, fromIndex: int): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "indexOf", [str, fromIndex]);
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, s: CharSequence): LSLStringBuilder
    {
        _preconditionCheck();

        if (s == null)
            _insertCharSequence(dstOffset, "null", 0, 4);
        else
            _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, s: CharSequence, start: int, end: int): LSLStringBuilder
    {
        _preconditionCheck();

        if (s == null)
            _insertCharSequence(dstOffset, "null", start, end);
        else
            _insertCharSequence(dstOffset, s, start, end);

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, obj: Object): LSLStringBuilder
    {
        _preconditionCheck();

        if (obj == null)
        {
            _insertCharSequence(dstOffset, "null", 0, 4);
        }
        else
        {
            val s: String = action OBJECT_TO_STRING(obj);
            _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));
        }

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, s: String): LSLStringBuilder
    {
        _preconditionCheck();

        if (s == null)
            _insertCharSequence(dstOffset, "null", 0, 4);
        else
            _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, x: boolean): LSLStringBuilder
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, x: char): LSLStringBuilder
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, 1);

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, x: array<char>): LSLStringBuilder
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, index: int, str: array<char>, offset: int, len: int): LSLStringBuilder
    {
        _preconditionCheck();

        val arr: array<char> = action ARRAY_NEW("char", len);
        action ARRAY_COPY(str, offset, arr, 0, len);

        val s: String = action OBJECT_TO_STRING(arr);
        _insertCharSequence(index, s, 0, len);

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, x: double): LSLStringBuilder
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, x: float): LSLStringBuilder
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, x: int): LSLStringBuilder
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: LSLStringBuilder, dstOffset: int, x: long): LSLStringBuilder
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.lastIndexOf (@target self: LSLStringBuilder, str: String): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "lastIndexOf", [str, this.count]);
    }


    fun *.lastIndexOf (@target self: LSLStringBuilder, str: String, fromIndex: int): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "lastIndexOf", [str, fromIndex]);
    }


    fun *.length (@target self: LSLStringBuilder): int
    {
        _preconditionCheck();

        result = this.count;
    }


    fun *.offsetByCodePoints (@target self: LSLStringBuilder, index: int, codePointOffset: int): int
    {
        _preconditionCheck();

        if ((index < 0) || (index > this.count))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        result = action CALL_METHOD(null as Character, "offsetByCodePoints", [this.value, 0, this.count, index, codePointOffset]);
    }


    fun *.replace (@target self: LSLStringBuilder, start: int, end: int, s: String): LSLStringBuilder
    {
        _preconditionCheck();

        _deleteChars(start, end);

        if (s == null)
            _insertCharSequence(start, "null", 0, 4);
        else
            _insertCharSequence(start, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.reverse (@target self: LSLStringBuilder): LSLStringBuilder
    {
        _preconditionCheck();

        if (this.count != 0)
        {
            var hasSurrogates: boolean = false;

            val n: int = this.count - 1;
            var j: int = 0;
            action LOOP_FOR(
                j, (n - 1) >> 1, -1, -1,
                reverse_loop(j, n, hasSurrogates)
            );

            if (hasSurrogates)
                _reverseAllValidSurrogatePairs(n); // auto-inlined!
        }

        result = self;
    }

    @Phantom proc reverse_loop (j: int, n: int, hasSurrogates: boolean): void
    {
        var k: int = n - j;

        var cj: char = this.value[j];
        var ck: char = this.value[k];

        this.value[j] = ck;
        this.value[k] = cj;

        if (action CALL_METHOD(null as Character, "isSurrogate", [cj]) ||
            action CALL_METHOD(null as Character, "isSurrogate", [ck]))
            hasSurrogates = true;
    }

    @AutoInline @Phantom proc _reverseAllValidSurrogatePairs (n: int): void
    {
        var i: int = 0;
        action LOOP_FOR(
            i, 0, n, +1,
            _reverseAllValidSurrogatePairs_loop(i)
        );
    }

    @Phantom proc _reverseAllValidSurrogatePairs_loop (i: int): void
    {
        var c2: char = this.value[i];

        if (action CALL_METHOD(null as Character, "isLowSurrogate", [c2])) {
            var c1: char = this.value[i + 1];

            if (action CALL_METHOD(null as Character, "isHighSurrogate", [c1])) {
                this.value[i] = c1;
                i += 1;
                this.value[i] = c2;
            }
        }
    }


    fun *.setCharAt (@target self: LSLStringBuilder, index: int, x: char): void
    {
        _preconditionCheck();

        if ((index < 0) || (index >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        this.value[index] = x;
    }


    fun *.setLength (@target self: LSLStringBuilder, newLength: int): void
    {
        _preconditionCheck();

        // trim too long strings
        val maxLength: int = action ARRAY_SIZE(this.value);
        if (newLength > maxLength)
            newLength = maxLength;

        if (newLength < 0)
        {
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);
        }
        else if (newLength < this.count)
        {
            this.count = newLength;
        }
        else if (newLength > this.count)
        {
            action ARRAY_FILL_RANGE(this.value, this.count, newLength, 0 as char);
            this.count = newLength;
        }
    }


    fun *.subSequence (@target self: LSLStringBuilder, start: int, end: int): CharSequence
    {
        _preconditionCheck();

        if ((start < 0) || (start > end) || (end > this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = _asString(start, end);
    }


    fun *.substring (@target self: LSLStringBuilder, start: int): String
    {
        _preconditionCheck();

        if ((start < 0) || (start > this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = _asString(start, this.count);
    }


    fun *.substring (@target self: LSLStringBuilder, start: int, end: int): String
    {
        _preconditionCheck();

        if ((start < 0) || (start > end) || (end > this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = _asString(start, end);
    }


    fun *.toString (@target self: LSLStringBuilder): String
    {
        _preconditionCheck();

        result = _asString();
    }


    fun *.trimToSize (@target self: LSLStringBuilder): void
    {
        _preconditionCheck();

        // #question: what do we need to do here?
        // original - shrink the array (expand it later if needed)
        // utbot - shrink the array (completely abandon later executions that end up writing outside of the new array)
        // proposed - do nothing (array size is fixed)
    }


    // special: serialization

    @throws(["java.io.IOException"])
    @private fun *.writeObject (@target self: LSLStringBuilder, s: ObjectOutputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun *.readObject (@target self: LSLStringBuilder, s: ObjectInputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }

}