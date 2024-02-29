//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuffer.java";
// NOTE: additional url - https://github.com/UnitTestBot/UTBotJava/blob/main/utbot-framework/src/main/java/org/utbot/engine/overrides/strings/UtStringBuffer.java

// imports

import java/lang/Character;
import java/util/stream/IntStream;

import java/lang/StringBuffer;


// automata

automaton StringBufferAutomaton
(
    var value: array<char> = null, // WARNING: do not rename or change the type!
    var count: int = 0             // WARNING: do not rename or change the type!
)
: StringBuffer
{
    // states and shifts

    initstate Initialized;  // NOTE: target type is being used too frequently - disabling automata features

    shift Initialized -> self by [
        // constructors
        `<init>` (StringBuffer),
        `<init>` (StringBuffer, CharSequence),
        `<init>` (StringBuffer, String),
        `<init>` (StringBuffer, int),

        // instance methods
        append (StringBuffer, CharSequence),
        append (StringBuffer, CharSequence, int, int),
        append (StringBuffer, Object),
        append (StringBuffer, String),
        append (StringBuffer, StringBuffer),
        append (StringBuffer, boolean),
        append (StringBuffer, char),
        append (StringBuffer, array<char>),
        append (StringBuffer, array<char>, int, int),
        append (StringBuffer, double),
        append (StringBuffer, float),
        append (StringBuffer, int),
        append (StringBuffer, long),
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
        indexOf (StringBuffer, String),
        indexOf (StringBuffer, String, int),
        insert (StringBuffer, int, CharSequence),
        insert (StringBuffer, int, CharSequence, int, int),
        insert (StringBuffer, int, Object),
        insert (StringBuffer, int, String),
        insert (StringBuffer, int, boolean),
        insert (StringBuffer, int, char),
        insert (StringBuffer, int, array<char>),
        insert (StringBuffer, int, array<char>, int, int),
        insert (StringBuffer, int, double),
        insert (StringBuffer, int, float),
        insert (StringBuffer, int, int),
        insert (StringBuffer, int, long),
        lastIndexOf (StringBuffer, String),
        lastIndexOf (StringBuffer, String, int),
        length,
        offsetByCodePoints,
        replace,
        reverse,
        setCharAt,
        setLength,
        subSequence,
        substring (StringBuffer, int),
        substring (StringBuffer, int, int),
        toString,
        trimToSize,
    ];

    // internal variables

    // utilities

    @AutoInline @Phantom proc _init (): void
    {
        this.value = action ARRAY_NEW("char", STRINGBUFFER_LENGTH_MAX);
    }


    @AutoInline @Phantom proc _preconditionCheck (): void
    {
        // #question: do we need ALL of that?

        action ASSUME(this.value != null);
        action ASSUME(action ARRAY_SIZE(this.value) <= STRINGBUFFER_LENGTH_MAX);
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

    constructor *.`<init>` (@target self: StringBuffer)
    {
        _init();
    }


    constructor *.`<init>` (@target self: StringBuffer, seq: CharSequence)
    {
        if (seq == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _init();

        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));
    }


    constructor *.`<init>` (@target self: StringBuffer, str: String)
    {
        if (str == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        _init();

         _appendCharSequence(str, 0, action CALL_METHOD(str, "length", []));
    }


    constructor *.`<init>` (@target self: StringBuffer, cap: int)
    {
        if (cap < 0)
            action THROW_NEW("java.lang.NegativeArraySizeException", []);

        // just an arbitrary limit that can be set externaly by the user
        if (cap > 1073741823) // Integer.MAX_VALUE / 2
            action THROW_NEW("java.lang.OutOfMemoryError", ["Requested array size exceeds VM limit"]);

        _init();
    }


    // methods

    @synchronized fun *.append (@target self: StringBuffer, seq: CharSequence): StringBuffer
    {
        _preconditionCheck();

        if (seq == null)
            _appendCharSequence("null", 0, 4);
        else
            _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, seq: CharSequence, start: int, end: int): StringBuffer
    {
        _preconditionCheck();

        if (seq == null)
            _appendCharSequence("null", start, end);
        else
            _appendCharSequence(seq, start, end);

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, obj: Object): StringBuffer
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


    @synchronized fun *.append (@target self: StringBuffer, str: String): StringBuffer
    {
        _preconditionCheck();

        if (str == null)
            _appendCharSequence("null", 0, 4);
        else
            _appendCharSequence(str, 0, action CALL_METHOD(str, "length", []));

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, sb: StringBuffer): StringBuffer
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


    @synchronized fun *.append (@target self: StringBuffer, x: boolean): StringBuffer
    {
        _preconditionCheck();

        if (x)
            _appendCharSequence("true", 0, 4);
        else
            _appendCharSequence("false", 0, 5);

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, x: char): StringBuffer
    {
        _preconditionCheck();

        if (this.count < action ARRAY_SIZE(this.value))
        {
            this.value[this.count] = x;
            this.count += 1;
        }

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>): StringBuffer
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(str);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>, offset: int, len: int): StringBuffer
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(str);
        _appendCharSequence(seq, offset, len);

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, x: double): StringBuffer
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, x: float): StringBuffer
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, x: int): StringBuffer
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, x: long): StringBuffer
    {
        _preconditionCheck();

        val seq: String = action OBJECT_TO_STRING(x);
        _appendCharSequence(seq, 0, action CALL_METHOD(seq, "length", []));

        result = self;
    }


    @synchronized fun *.appendCodePoint (@target self: StringBuffer, codePoint: int): StringBuffer
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


    @synchronized fun *.capacity (@target self: StringBuffer): int
    {
        _preconditionCheck();

        result = action ARRAY_SIZE(this.value);
    }


    @synchronized fun *.charAt (@target self: StringBuffer, index: int): char
    {
        _preconditionCheck();

        if ((index < 0) || (index >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = this.value[index];
    }


    // within java.lang.AbstractStringBuilder
    fun *.chars (@target self: StringBuffer): IntStream
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


    @synchronized fun *.codePointAt (@target self: StringBuffer, index: int): int
    {
        _preconditionCheck();

        if ((index < 0) || (index >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [index]);

        result = action CALL_METHOD(null as Character, "codePointAt", [this.value, index, this.count]);
    }


    @synchronized fun *.codePointBefore (@target self: StringBuffer, index: int): int
    {
        _preconditionCheck();

        val i: int = index - 1;
        if ((i < 0) || (i >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [index]);

        result = action CALL_METHOD(null as Character, "codePointBefore", [this.value, index, 0]);
    }


    @synchronized fun *.codePointCount (@target self: StringBuffer, beginIndex: int, endIndex: int): int
    {
        _preconditionCheck();

        if ((beginIndex < 0) || (beginIndex > endIndex) || (endIndex > this.count))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        result = action CALL_METHOD(null as Character, "codePointCount", [this.value, beginIndex, endIndex - beginIndex]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.codePoints (@target self: StringBuffer): IntStream
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


    @synchronized fun *.compareTo (@target self: StringBuffer, another: StringBuffer): int
    {
        _preconditionCheck();

        if (another == self)
        {
            result = 0;
        }
        else
        {
            val thisString: String = _asString();
            val anotherString: String = StringBufferAutomaton(another)._asString();

            result = action CALL_METHOD(thisString, "compareTo", [anotherString]);
        }
    }


    @synchronized fun *.delete (@target self: StringBuffer, start: int, end: int): StringBuffer
    {
        _preconditionCheck();

        _deleteChars(start, end);

        result = self;
    }


    @synchronized fun *.deleteCharAt (@target self: StringBuffer, index: int): StringBuffer
    {
        _preconditionCheck();

        _deleteChars(index, index + 1);

        result = self;
    }


    @synchronized fun *.ensureCapacity (@target self: StringBuffer, minimumCapacity: int): void
    {
        // note: UtBot implementation
        action DO_NOTHING();
    }


    @synchronized fun *.getChars (@target self: StringBuffer, srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void
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
    fun *.getValue (@target self: StringBuffer): array<char>
    {
        _preconditionCheck();

        result = this.value;
    }


    fun *.indexOf (@target self: StringBuffer, str: String): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "indexOf", [str, 0]);
    }


    @synchronized fun *.indexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "indexOf", [str, fromIndex]);
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence): StringBuffer
    {
        _preconditionCheck();

        if (s == null)
            _insertCharSequence(dstOffset, "null", 0, 4);
        else
            _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence, start: int, end: int): StringBuffer
    {
        _preconditionCheck();

        if (s == null)
            _insertCharSequence(dstOffset, "null", start, end);
        else
            _insertCharSequence(dstOffset, s, start, end);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, obj: Object): StringBuffer
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


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, s: String): StringBuffer
    {
        _preconditionCheck();

        if (s == null)
            _insertCharSequence(dstOffset, "null", 0, 4);
        else
            _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, x: boolean): StringBuffer
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, x: char): StringBuffer
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, 1);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, x: array<char>): StringBuffer
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, index: int, str: array<char>, offset: int, len: int): StringBuffer
    {
        _preconditionCheck();

        val arr: array<char> = action ARRAY_NEW("char", len);
        action ARRAY_COPY(str, offset, arr, 0, len);

        val s: String = action OBJECT_TO_STRING(arr);
        _insertCharSequence(index, s, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, x: double): StringBuffer
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, x: float): StringBuffer
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, x: int): StringBuffer
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, x: long): StringBuffer
    {
        _preconditionCheck();

        val s: String = action OBJECT_TO_STRING(x);
        _insertCharSequence(dstOffset, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    fun *.lastIndexOf (@target self: StringBuffer, str: String): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "lastIndexOf", [str, this.count]);
    }


    @synchronized fun *.lastIndexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        _preconditionCheck();

        // note: UtBot implementation
        result = action CALL_METHOD(_asString(), "lastIndexOf", [str, fromIndex]);
    }


    @synchronized fun *.length (@target self: StringBuffer): int
    {
        _preconditionCheck();

        result = this.count;
    }


    @synchronized fun *.offsetByCodePoints (@target self: StringBuffer, index: int, codePointOffset: int): int
    {
        _preconditionCheck();

        if ((index < 0) || (index > this.count))
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        result = action CALL_METHOD(null as Character, "offsetByCodePoints", [this.value, 0, this.count, index, codePointOffset]);
    }


    @synchronized fun *.replace (@target self: StringBuffer, start: int, end: int, s: String): StringBuffer
    {
        _preconditionCheck();

        _deleteChars(start, end);

        if (s == null)
            _insertCharSequence(start, "null", 0, 4);
        else
            _insertCharSequence(start, s, 0, action CALL_METHOD(s, "length", []));

        result = self;
    }


    @synchronized fun *.reverse (@target self: StringBuffer): StringBuffer
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


    @synchronized fun *.setCharAt (@target self: StringBuffer, index: int, x: char): void
    {
        _preconditionCheck();

        if ((index < 0) || (index >= this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        this.value[index] = x;
    }


    @synchronized fun *.setLength (@target self: StringBuffer, newLength: int): void
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


    @synchronized fun *.subSequence (@target self: StringBuffer, start: int, end: int): CharSequence
    {
        _preconditionCheck();

        if ((start < 0) || (start > end) || (end > this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = _asString(start, end);
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int): String
    {
        _preconditionCheck();

        if ((start < 0) || (start > this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = _asString(start, this.count);
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int, end: int): String
    {
        _preconditionCheck();

        if ((start < 0) || (start > end) || (end > this.count))
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);

        result = _asString(start, end);
    }


    @synchronized fun *.toString (@target self: StringBuffer): String
    {
        _preconditionCheck();

        result = _asString();
    }


    @synchronized fun *.trimToSize (@target self: StringBuffer): void
    {
        _preconditionCheck();

        // #question: what do we need to do here?
        // original - shrink the array (expand it later if needed)
        // utbot - shrink the array (completely abandon later executions that end up writing outside of the new array)
        // proposed - do nothing (array size is fixed)
    }

}
