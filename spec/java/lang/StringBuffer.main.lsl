///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuffer.java";

// imports

import java/lang/Character;
import java/lang/StringBuffer;


// automata

automaton StringBufferAutomaton
(
)
: StringBuffer
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        StringBuffer (StringBuffer),
        StringBuffer (StringBuffer, CharSequence),
        StringBuffer (StringBuffer, String),
        StringBuffer (StringBuffer, int),
    ];

    shift Initialized -> self by [
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

    var storage: String = "";
    var length: int = 0;


    // utilities

    proc _checkRange (start: int, end: int, len: int): void
    {
        if (start < 0 || start > end || end > len)
        {
            //val message: String = "start " + action OBJECT_TO_STRING(start) + ", end " + action OBJECT_TO_STRING(end) + ", length " + action OBJECT_TO_STRING(len);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);
        }
    }


    proc _checkRangeSIOOBE (start: int, end: int, len: int): void
    {
        if (start < 0 || start > end || end > len)
        {
            //val message: String = "start " + action OBJECT_TO_STRING(start) + ", end " + action OBJECT_TO_STRING(end) + ", length " + action OBJECT_TO_STRING(len);
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);
        }
    }


    proc _checkIndex (index: int): void
    {
        if (index < 0 || index >= this.length)
        {
            //val message: String = "index " + action OBJECT_TO_STRING(index) + ",length " + action OBJECT_TO_STRING(this.length);
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);
        }
    }


    proc _checkOffset (offset: int): void
    {
        if (offset < 0 || offset > this.length) {
            //val message: String = "offset " + action OBJECT_TO_STRING(offset) + ",length " + action OBJECT_TO_STRING(this.length);
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);
        }
    }


    proc _isBmpCodePoint (codePoint: int): boolean
    {
        result = (codePoint >>> 16) == 0;
    }


    proc _isValidCodePoint (codePoint: int): boolean
    {
        result = (codePoint >= MIN_CODE_POINT && codePoint <= MAX_CODE_POINT);
    }


    proc _lowSurrogate (codePoint: int): char
    {
        result = ((codePoint & 1023) + MIN_LOW_SURROGATE) as char;
    }


    proc _highSurrogate (codePoint: int): char
    {
        result = ((codePoint >>> 10) + (MIN_HIGH_SURROGATE - (MIN_SUPPLEMENTARY_CODE_POINT >>> 10))) as char;
    }


    proc _appendCharSequence (seq: CharSequence): void
    {
        if (seq == null)
        {
            this.storage += action OBJECT_TO_STRING("null");
            this.length += 4;
        }
        else
        {
            val seqLength: int = action CALL_METHOD(seq, "length", []);
            this.length += seqLength;

            var i: int = 0;
            action LOOP_FOR(
                i, 0, seqLength, +1,
                _appendCharSequence_loop(i, seq)
            );
        }
    }


    @Phantom proc _appendCharSequence_loop(i: int, seq: CharSequence): void
    {
        var currentChar: char = action CALL_METHOD(seq, "charAt", [i]);
        this.storage += action OBJECT_TO_STRING(currentChar);
    }


    proc _appendString (str: String): void
    {
        if (str == null)
        {
            str = "null";
            this.length += 4;
        }
        else
        {
            this.length += action CALL_METHOD(str, "length", []);
        }
        this.storage += str;
    }


    proc _delete (start: int, end: int): void
    {
        val len: int = this.length - end + start;
        var newStr: array<char> = action ARRAY_NEW("char", len);

        var i: int = 0;
        var arrayIndex: int = 0;
        action LOOP_FOR(
            i, 0, start, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );

        action LOOP_FOR(
            i, end, this.length, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );

        this.storage = action OBJECT_TO_STRING(newStr);
        this.length = len;
    }


    @Phantom proc _copyToCharArray_loop (i: int, arrayIndex:int, newStr: array<char>): void
    {
        newStr[arrayIndex] = action CALL_METHOD(this.storage, "charAt", [i]);
        arrayIndex += 1;
    }


    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    proc _insertCharSequence (dstOffset: int, s: CharSequence, len: int, start: int, end: int): void
    {
        _checkRange(start, end, len);

        val countInsertedElements: int = end - start;
        val newStr: array<char> = action ARRAY_NEW("char", this.length + countInsertedElements);

        var i: int = 0;
        var arrayIndex: int = 0;

        action LOOP_FOR(
            i, 0, dstOffset, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );
        action LOOP_FOR(
            i, start, end, +1,
            _insertSequence_loop(i, arrayIndex, newStr, s)
        );
        action LOOP_FOR(
            i, dstOffset, this.length, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );

        this.storage = action OBJECT_TO_STRING(newStr);
        this.length += countInsertedElements;
    }


    @Phantom proc _insertSequence_loop(i: int, arrayIndex: int, newStr: array<char>, s: CharSequence): void
    {
            newStr[arrayIndex] = action CALL_METHOD(s, "charAt", [i]);
            arrayIndex += 1;
    }


    proc _substring(start: int, end: int): String
    {
        _checkRangeSIOOBE(start, end, this.length);
        val sizeNewString: int = end - start;
        val newStr: array<char> = action ARRAY_NEW("char", sizeNewString);

        var i: int = 0;
        action LOOP_FOR(
            i, start, end, +1,
            _newSubString_loop(i, newStr)
        );
        result = action OBJECT_TO_STRING(newStr);
    }


    @Phantom proc _newSubString_loop (i: int, newStr: array<char>): void
    {
        newStr[i] = action CALL_METHOD(this.storage, "charAt", [i]);
    }

    // constructors

    constructor *.StringBuffer (@target self: StringBuffer)
    {
        // This constructor's body is empty, because in original class is used byte array and this initializes 16 size;
        // In this realization is used "String" instead of to array; And this string initializes in "internal variables";
    }


    constructor *.StringBuffer (@target self: StringBuffer, seq: CharSequence)
    {
        if (seq == null)
            _throwNPE();

        _appendCharSequence(seq);
    }


    constructor *.StringBuffer (@target self: StringBuffer, str: String)
    {
        if (str == null)
            _throwNPE();

        _appendString(str);
    }


    constructor *.StringBuffer (@target self: StringBuffer, capacity: int)
    {
        // This constructor's body is empty, because in original class is used byte array and this initializes 16 + capacity size;
        // In this realization is used "String" instead of to array; And this string initializes in "internal variables";
    }


    // methods

    @synchronized fun *.append (@target self: StringBuffer, seq: CharSequence): StringBuffer
    {
        _appendCharSequence(seq);

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, seq: CharSequence, start: int, end: int): StringBuffer
    {
        var seqLength: int = 4;
        if (seq == null)
            seq = "null";

        seqLength = action CALL_METHOD(seq, "length", []);

        _checkRange(start, end, seqLength);
        this.length += end - start;

        var i: int = 0;
        action LOOP_FOR(
            i, start, end, +1,
            _appendCharSequence_loop(i, seq)
        );

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, obj: Object): StringBuffer
    {
        if (obj == null)
        {
            this.storage += "null";
            this.length += 4;
        }
            else
            {
                val objString: String = action OBJECT_TO_STRING(obj);
                this.storage += objString;
                this.length += action CALL_METHOD(objString, "length", []);
            }
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, str: String): StringBuffer
    {
        _appendString(str);

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, sb: StringBuffer): StringBuffer
    {
        val s: Object = sb;
        if (s == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else if (s has StringBufferAutomaton)
        {
            this.storage += StringBufferAutomaton(sb).storage;
            this.length += StringBufferAutomaton(sb).length;
        }

        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, b: boolean): StringBuffer
    {
        if (b)
        {
            this.storage += "true";
            this.length += 4;
        }
        else
        {
            this.storage += "false";
            this.length += 5;
        }
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, c: char): StringBuffer
    {
        this.storage += action OBJECT_TO_STRING(c);
        this.length += 1;
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>): StringBuffer
    {
        val strSize: int = action ARRAY_SIZE(str);
        this.length += strSize;
        this.storage += action OBJECT_TO_STRING(str);
        result = self;
    }


    @Phantom proc _fromSrcArrayToDstArray_loop (i: int, arrayIndex: int, str: array<char>, subArray: array<char>): void
    {
        subArray[arrayIndex] = str[i];
        arrayIndex += 1;
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>, offset: int, len: int): StringBuffer
    {
        val end: int = offset + len;
        val strSize: int = action ARRAY_SIZE(str);
        _checkRange(offset, end, strSize);
        val subArray: array<char> = action ARRAY_NEW("char", len);
        var arrayIndex: int = 0;
        var i: int = 0;
        action LOOP_FOR(
            i, offset, end, +1,
            _fromSrcArrayToDstArray_loop(i, arrayIndex, str, subArray)
        );
        this.length += len;
        this.storage += action OBJECT_TO_STRING(subArray);
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, d: double): StringBuffer
    {
        val dString: String = action OBJECT_TO_STRING(d);
        this.storage += dString;
        this.length += action CALL_METHOD(dString, "length", []);
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, f: float): StringBuffer
    {
        val fString: String = action OBJECT_TO_STRING(f);
        this.storage += fString;
        this.length += action CALL_METHOD(fString, "length", []);
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, i: int): StringBuffer
    {
        val iString: String = action OBJECT_TO_STRING(i);
        this.storage += iString;
        this.length += action CALL_METHOD(iString, "length", []);
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, lng: long): StringBuffer
    {
        val lngString: String = action OBJECT_TO_STRING(lng);
        this.storage += lngString;
        this.length += action CALL_METHOD(lngString, "length", []);
        result = self;
    }


    @synchronized fun *.appendCodePoint (@target self: StringBuffer, codePoint: int): StringBuffer
    {
        if (_isBmpCodePoint(codePoint))
        {
            val curChar: char = codePoint as char;
            this.storage += action OBJECT_TO_STRING(curChar);
            this.length += 1;
        }
        else if (_isValidCodePoint(codePoint))
        {
            val charsArray: array<char> = action ARRAY_NEW("char", 2);
            charsArray[0] = _lowSurrogate(codePoint);
            charsArray[1] = _highSurrogate(codePoint);
            this.storage += action OBJECT_TO_STRING(charsArray);
            this.length += 2;
        }
        else
        {
            //val message: String = "Not a valid Unicode code point: 0x%X" + action OBJECT_TO_STRING(codePoint);
            action THROW_NEW("java.lang.IllegalArgumentException", []);
        }
        result = self;
    }


    @synchronized fun *.capacity (@target self: StringBuffer): int
    {
        // This is right realization ?
        // original: return value.length >> coder;
        // we will have another result, because we don't know "coder" value;
        result = this.length;
    }


    @synchronized fun *.charAt (@target self: StringBuffer, index: int): char
    {
        _checkIndex(index);
        result = action CALL_METHOD(this.storage, "charAt", [index]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.chars (@target self: StringBuffer): IntStream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    @synchronized fun *.codePointAt (@target self: StringBuffer, index: int): int
    {
        _checkIndex(index);

        val codePoint: int = action SYMBOLIC("int");
        action ASSUME(codePoint >= MIN_CODE_POINT);
        action ASSUME(codePoint <= MAX_CODE_POINT);
        result = codePoint;
    }


    @synchronized fun *.codePointBefore (@target self: StringBuffer, index: int): int
    {
        index -= 1;
        _checkIndex(index);

        val codePoint: int = action SYMBOLIC("int");
        action ASSUME(codePoint >= MIN_CODE_POINT);
        action ASSUME(codePoint <= MAX_CODE_POINT);
        result = codePoint;
    }


    @synchronized fun *.codePointCount (@target self: StringBuffer, beginIndex: int, endIndex: int): int
    {
        if (beginIndex < 0 || endIndex > this.length || beginIndex > endIndex)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        val codePoint: int = action SYMBOLIC("int");
        val leftBorder: int = endIndex - beginIndex;
        val rightBorder: int = (endIndex - beginIndex) * 2;
        action ASSUME(codePoint >= leftBorder);
        action ASSUME(codePoint <= rightBorder);
    }


    // within java.lang.AbstractStringBuilder
    fun *.codePoints (@target self: StringBuffer): IntStream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.IntStream");
        action ASSUME(result != null);
    }


    @synchronized fun *.compareTo (@target self: StringBuffer, another: StringBuffer): int
    {
        if (another == self)
        {
            result = 0;
        }
        else
        {
            val anotherString: String = StringBufferAutomaton(another).storage;
            result = action CALL_METHOD(this.storage, "compareTo", [anotherString]);
        }
    }


    @synchronized fun *.delete (@target self: StringBuffer, start: int, end: int): StringBuffer
    {
        if (end > this.length)
            end = this.length;

        _checkRangeSIOOBE(start, end, this.length);

        _delete(start, end);

        result = self;
    }


    @synchronized fun *.deleteCharAt (@target self: StringBuffer, index: int): StringBuffer
    {
        _checkIndex(index);

        _delete(index, index + 1);

        result = self;
    }


    @synchronized fun *.ensureCapacity (@target self: StringBuffer, minimumCapacity: int): void
    {
        // storage is dynamic, so nothing more
        action DO_NOTHING();
    }


    @synchronized fun *.getChars (@target self: StringBuffer, srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void
    {
        _checkRangeSIOOBE(srcBegin, srcEnd, this.length);
        var n: int = srcEnd - srcBegin;
        val dstLength: int = action ARRAY_SIZE(dst);
        _checkRange(dstBegin, dstBegin + n, dstLength);

        var storageChars: array<char> = action CALL_METHOD(this.storage, "toCharArray", []);

        var i: int = 0;
        action LOOP_FOR(
            i, srcBegin, srcEnd, +1,
            _getChars_loop(i, dstBegin, dst, storageChars)
        );
    }


    @Phantom proc _getChars_loop(i: int, dstBegin: int, dst: array<char>, storageChars: array<char>): void
    {
        dst[dstBegin] = storageChars[i];
        dstBegin += 1;
    }


    fun *.indexOf (@target self: StringBuffer, str: String): int
    {
        result = action CALL_METHOD(this.storage, "indexOf", [str, 0]);
    }


    @synchronized fun *.indexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        result = action CALL_METHOD(this.storage, "indexOf", [str, fromIndex]);
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence): StringBuffer
    {
        _checkOffset(dstOffset);
        var len: int = 4;
        if (s == null)
            s = "null";
        else
            len = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence, start: int, end: int): StringBuffer
    {
        _checkOffset(dstOffset);
        var len: int = 4;
        if (s == null)
            s = "null";
        else
            len = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, start, end);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, obj: Object): StringBuffer
    {
        _checkOffset(dstOffset);

        var s: String = "null";
        var len: int = 4;

        if (obj != null)
            s = action OBJECT_TO_STRING(obj);
        else
            len = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, s: String): StringBuffer
    {
        _checkOffset(dstOffset);
        var len: int = 4;
        if (s == null)
            s = "null";
        else
            len = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, b: boolean): StringBuffer
    {
        _checkOffset(dstOffset);

        var s: String = "false";
        var len: int =  5;
        if (b)
        {
            s = "true";
            len = 4;
        }

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, c: char): StringBuffer
    {
        _checkOffset(dstOffset);

        val subArray: array<char> = action ARRAY_NEW("char", this.length + 1);
        val str: array<char> = action CALL_METHOD(this.storage, "toCharArray", []);

        var i: int = 0;
        var arrayIndex: int = 0;

        action LOOP_FOR(
            i, 0, dstOffset, +1,
            _fromSrcArrayToDstArray_loop(i, arrayIndex, str, subArray)
        );
        subArray[i] = c;
        arrayIndex += 1;
        action LOOP_FOR(
            i, dstOffset, this.length, +1,
            _fromSrcArrayToDstArray_loop(i, arrayIndex, str, subArray)
        );

        this.storage = action OBJECT_TO_STRING(subArray);
        this.length += 1;
        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, str: array<char>): StringBuffer
    {
        _checkOffset(dstOffset);
        val s: String = action OBJECT_TO_STRING(str);

        val len: int = action ARRAY_SIZE(str);
        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, index: int, str: array<char>, offset: int, len: int): StringBuffer
    {
        _checkOffset(index);

        val lenStr: int = action ARRAY_SIZE(str);
        _checkRangeSIOOBE(offset, offset + len, lenStr);

        val s: String = action OBJECT_TO_STRING(str);

        _insertCharSequence(index, s, len, offset, offset + len);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, d: double): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(d);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, f: float): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(f);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, ii: int): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(ii);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, l: long): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(l);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.lastIndexOf (@target self: StringBuffer, str: String): int
    {
        result = action DEBUG_DO("this.storage.lastIndexOf(str)");
    }


    @synchronized fun *.lastIndexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        result = action DEBUG_DO("this.storage.lastIndexOf(str, fromIndex)");
    }


    @synchronized fun *.length (@target self: StringBuffer): int
    {
        result = this.length;
    }


    @synchronized fun *.offsetByCodePoints (@target self: StringBuffer, index: int, codePointOffset: int): int
    {
        _checkIndex(index);

        result = action DEBUG_DO("Character.offsetByCodePoints(this.storage, index, codePointOffset)");
    }


    @synchronized fun *.replace (@target self: StringBuffer, start: int, end: int, s: String): StringBuffer
    {
        if (end > this.length)
            end = this.length;

        _checkRangeSIOOBE(start, end, this.length);

        val strLength: int = action CALL_METHOD(s, "length", []);

        val newLength: int = this.length + strLength - (end - start);
        val newStr: array<char> = action ARRAY_NEW("char", newLength);
        var arrayIndex: int = 0;
        var i: int = 0;

        action LOOP_FOR(
            i, 0, start, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );
        action LOOP_FOR(
            i, 0, strLength, +1,
            _insertSequence_loop(i, arrayIndex, newStr, s)
        );
        action LOOP_FOR(
            i, end, this.length, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );

        this.storage = action OBJECT_TO_STRING(newStr);
        this.length = newLength;
        result = self;
    }


    @synchronized fun *.reverse (@target self: StringBuffer): StringBuffer
    {
        if (this.length != 0)
        {
            action ASSUME(this.length > 0);
            // serialize current state of storage string
            val oldStorage: array<char> = action CALL_METHOD(this.storage, "toCharArray", []);

            // prepare a new serialized but processed version of the storage
            val newStorage: array<char> = action ARRAY_NEW("char", this.length);
            action ASSUME(action ARRAY_SIZE(newStorage) == this.length);
            action ASSUME(action ARRAY_SIZE(oldStorage) == action ARRAY_SIZE(newStorage));

            var j: int = this.length - 1;
            var i: int = 0;
            action LOOP_FOR(
                i, 0, this.length, +1,
                _reverse_loop(i, oldStorage, j, newStorage)
            );

            // replace the old state with a reversed (buffer) version
            this.storage = action OBJECT_TO_STRING(newStorage);
        }
        result = self;
    }


    @Phantom proc _reverse_loop (i: int, oldStorage: array<char>, j: int, newStorage: array<char>): void
    {
        newStorage[j] = oldStorage[i];
        j -= 1;
    }


    @synchronized fun *.setCharAt (@target self: StringBuffer, index: int, ch: char): void
    {
        _checkIndex(index);
        val newStr: array<char> = action ARRAY_NEW("char", this.length);
        var arrayIndex: int = 0;
        var i: int = 0;
        action LOOP_FOR(
            i, 0, index, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );
        newStr[index] = ch;
        action LOOP_FOR(
            i, index + 1, this.length, +1,
            _copyToCharArray_loop(i, index, newStr)
        );

        this.storage = action OBJECT_TO_STRING(newStr);
    }


    @synchronized fun *.setLength (@target self: StringBuffer, newLength: int): void
    {
        if (newLength < 0)
        {
            //val message: String = "String index out of range: " + action OBJECT_TO_STRING(newLength);
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", []);
        }
        else if (newLength == 0)
        {
            this.storage = "";
            this.length = 0;
        }
        else
        {
            var i: int = 0;
            val newStr: array<char> = action ARRAY_NEW("char", newLength);
            if (newLength > this.length)
            {
                action LOOP_FOR(
                    i, 0, this.length, +1,
                    _setNewLength_loop(i, newStr)
                );
                action LOOP_FOR(
                    i, this.length, newLength, +1,
                    _fillZeros_loop(i, newStr)
                );
            }
            else
            {
                action LOOP_FOR(
                    i, 0, newLength, +1,
                    _setNewLength_loop(i, newStr)
                );
            }
            this.storage = action OBJECT_TO_STRING(newStr);
            this.length = newLength;
        }
    }


    @Phantom proc _setNewLength_loop (i: int, newStr: array<char>): void
    {
        newStr[i] = action CALL_METHOD(this.storage, "charAt", [i]);
    }

    @Phantom proc _fillZeros_loop (i: int, newStr: array<char>): void
    {
        newStr[i] = 0;
    }


    @synchronized fun *.subSequence (@target self: StringBuffer, start: int, end: int): CharSequence
    {
        result = _substring(start, end);
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int): String
    {
        result = _substring(start, this.length);
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int, end: int): String
    {
        result = _substring(start, end);
    }


    @synchronized fun *.toString (@target self: StringBuffer): String
    {
        result = this.storage;
    }


    @synchronized fun *.trimToSize (@target self: StringBuffer): void
    {
        // storage is dynamic, so nothing more
        action DO_NOTHING();
    }

}