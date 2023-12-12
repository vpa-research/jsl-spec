///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuilder.java";

// imports

import java/lang/Character;
import java/lang/StringBuilder;
import java/lang/StringBuffer;
import java/lang/Runnable;


// automata

automaton StringBuilderAutomaton
(
)
: StringBuilder
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (StringBuilder),
        `<init>` (StringBuilder, CharSequence),
        `<init>` (StringBuilder, String),
        `<init>` (StringBuilder, int),
    ];

    shift Initialized -> self by [
        // instance methods
        append (StringBuilder, CharSequence),
        append (StringBuilder, CharSequence, int, int),
        append (StringBuilder, Object),
        append (StringBuilder, String),
        append (StringBuilder, StringBuffer),
        append (StringBuilder, boolean),
        append (StringBuilder, char),
        append (StringBuilder, array<char>),
        append (StringBuilder, array<char>, int, int),
        append (StringBuilder, double),
        append (StringBuilder, float),
        append (StringBuilder, int),
        append (StringBuilder, long),
        appendCodePoint,
        compareTo,
        delete,
        deleteCharAt,
        indexOf (StringBuilder, String),
        indexOf (StringBuilder, String, int),
        insert (StringBuilder, int, CharSequence),
        insert (StringBuilder, int, CharSequence, int, int),
        insert (StringBuilder, int, Object),
        insert (StringBuilder, int, String),
        insert (StringBuilder, int, boolean),
        insert (StringBuilder, int, char),
        insert (StringBuilder, int, array<char>),
        insert (StringBuilder, int, array<char>, int, int),
        insert (StringBuilder, int, double),
        insert (StringBuilder, int, float),
        insert (StringBuilder, int, int),
        insert (StringBuilder, int, long),
        lastIndexOf (StringBuilder, String),
        lastIndexOf (StringBuilder, String, int),
        replace,
        reverse,
        toString,
        capacity,
        ensureCapacity,
        length,
        charAt,
        setLength,
        setCharAt,
        trimToSize,
        substring (StringBuilder, int),
        substring (StringBuilder, int, int),
        subSequence,
        getChars,
        codePointCount,
        codePointAt,
        codePointBefore,
        offsetByCodePoints,
        codePoints,
        chars,
    ];

    // internal variables

    var storage: String = "";
    // The length is equal to the number of chars in String
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
        var newStr_i: int = 0;
        action LOOP_FOR(
            i, start, end, +1,
            _newSubString_loop(i, newStr, newStr_i)
        );
        result = action OBJECT_TO_STRING(newStr);
    }


    @Phantom proc _newSubString_loop (i: int, newStr: array<char>, newStr_i: int): void
    {
        newStr[newStr_i] = action CALL_METHOD(this.storage, "charAt", [i]);
        newStr_i += 1;
    }

    // constructors

    constructor *.`<init>` (@target self: StringBuilder)
    {
        // This constructor's body is empty, because in original class is used byte array and this initializes 16 size;
        // In this realization is used "String" instead of to array; And this string initializes in "internal variables";
    }


    constructor *.`<init>` (@target self: StringBuilder, seq: CharSequence)
    {
        if (seq == null)
            _throwNPE();

        _appendCharSequence(seq);
    }


    constructor *.`<init>` (@target self: StringBuilder, str: String)
    {
        if (str == null)
            _throwNPE();

        _appendString(str);
    }


    constructor *.`<init>` (@target self: StringBuilder, capacity: int)
    {
        // This constructor's body is empty, because in original class is used byte array and this initializes 16 + capacity size;
        // In this realization is used "String" instead of to array; And this string initializes in "internal variables";
    }


    // methods

    fun *.append (@target self: StringBuilder, seq: CharSequence): StringBuilder
    {
        _appendCharSequence(seq);

        result = self;
    }


    fun *.append (@target self: StringBuilder, seq: CharSequence, start: int, end: int): StringBuilder
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


    fun *.append (@target self: StringBuilder, obj: Object): StringBuilder
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


    fun *.append (@target self: StringBuilder, str: String): StringBuilder
    {
        _appendString(str);

        result = self;
    }


    fun *.append (@target self: StringBuilder, sb: StringBuffer): StringBuilder
    {
        if (sb == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else
        {
            // #problem: StringBufferAutomaton isn't finished now;
           /* if (sb has StringBufferAutomaton)
            {
                this.storage += StringBufferAutomaton(sb).storage;
                this.length += StringBufferAutomaton(sb).length;
            } */

            this.storage += action OBJECT_TO_STRING(sb);
            this.length = action CALL_METHOD(this.storage, "length", []);
        }
        result = self;
    }


    fun *.append (@target self: StringBuilder, b: boolean): StringBuilder
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


    fun *.append (@target self: StringBuilder, c: char): StringBuilder
    {
        this.storage += action OBJECT_TO_STRING(c);
        this.length += 1;
        result = self;
    }


    fun *.append (@target self: StringBuilder, str: array<char>): StringBuilder
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


    fun *.append (@target self: StringBuilder, str: array<char>, offset: int, len: int): StringBuilder
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


    fun *.append (@target self: StringBuilder, d: double): StringBuilder
    {
        val dString: String = action OBJECT_TO_STRING(d);
        this.storage += dString;
        this.length += action CALL_METHOD(dString, "length", []);
        result = self;
    }


    fun *.append (@target self: StringBuilder, f: float): StringBuilder
    {
        val fString: String = action OBJECT_TO_STRING(f);
        this.storage += fString;
        this.length += action CALL_METHOD(fString, "length", []);
        result = self;
    }


    fun *.append (@target self: StringBuilder, i: int): StringBuilder
    {
        val iString: String = action OBJECT_TO_STRING(i);
        this.storage += iString;
        this.length += action CALL_METHOD(iString, "length", []);
        result = self;
    }


    fun *.append (@target self: StringBuilder, lng: long): StringBuilder
    {
        val lngString: String = action OBJECT_TO_STRING(lng);
        this.storage += lngString;
        this.length += action CALL_METHOD(lngString, "length", []);
        result = self;
    }


    // I suppose that realization of this function can be more plain ! Maybe use DEBUG_DO action with Character class ?
    fun *.appendCodePoint (@target self: StringBuilder, codePoint: int): StringBuilder
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


    fun *.compareTo (@target self: StringBuilder, another: StringBuilder): int
    {
        if (another == self)
        {
            result = 0;
        }
        else
        {
            val anotherString: String = StringBuilderAutomaton(another).storage;
            result = action CALL_METHOD(this.storage, "compareTo", [anotherString]);
        }
    }


    fun *.delete (@target self: StringBuilder, start: int, end: int): StringBuilder
    {
        if (end > this.length)
            end = this.length;

        _checkRangeSIOOBE(start, end, this.length);

        _delete(start, end);

        result = self;
    }


    fun *.deleteCharAt (@target self: StringBuilder, index: int): StringBuilder
    {
        _checkIndex(index);

        _delete(index, index + 1);

        result = self;
    }


    fun *.indexOf (@target self: StringBuilder, str: String): int
    {
        result = action CALL_METHOD(this.storage, "indexOf", [str, 0]);
    }


    fun *.indexOf (@target self: StringBuilder, str: String, fromIndex: int): int
    {
        result = action CALL_METHOD(this.storage, "indexOf", [str, fromIndex]);
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, s: CharSequence): StringBuilder
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


    fun *.insert (@target self: StringBuilder, dstOffset: int, s: CharSequence, start: int, end: int): StringBuilder
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


    fun *.insert (@target self: StringBuilder, dstOffset: int, obj: Object): StringBuilder
    {
        _checkOffset(dstOffset);

        var s: String = "null";
        var len: int = 4;

        if (obj != null)
        {
            s = action OBJECT_TO_STRING(obj);
            len = action CALL_METHOD(s, "length", []);
        }
        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, s: String): StringBuilder
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


    fun *.insert (@target self: StringBuilder, dstOffset: int, b: boolean): StringBuilder
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


    fun *.insert (@target self: StringBuilder, dstOffset: int, c: char): StringBuilder
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


    fun *.insert (@target self: StringBuilder, dstOffset: int, str: array<char>): StringBuilder
    {
        _checkOffset(dstOffset);
        val s: String = action OBJECT_TO_STRING(str);

        val len: int = action ARRAY_SIZE(str);
        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, str: array<char>, start: int, end: int): StringBuilder
    {
        _checkOffset(dstOffset);
        val s: String = action OBJECT_TO_STRING(str);
        val len: int = action ARRAY_SIZE(str);
        _checkRangeSIOOBE(start, start + end, len);

        _insertCharSequence(dstOffset, s, len, start, end);

        result = self;
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, d: double): StringBuilder
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(d);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, f: float): StringBuilder
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(f);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, ii: int): StringBuilder
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(ii);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.insert (@target self: StringBuilder, dstOffset: int, l: long): StringBuilder
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(l);
        var len: int = action CALL_METHOD(s, "length", []);

        _insertCharSequence(dstOffset, s, len, 0, len);

        result = self;
    }


    fun *.lastIndexOf (@target self: StringBuilder, str: String): int
    {
        result = action CALL_METHOD(this.storage, "lastIndexOf", [str]);
    }


    fun *.lastIndexOf (@target self: StringBuilder, str: String, fromIndex: int): int
    {
        result = action CALL_METHOD(this.storage, "lastIndexOf", [str, fromIndex]);
    }


    fun *.replace (@target self: StringBuilder, start: int, end: int, s: String): StringBuilder
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


    fun *.reverse (@target self: StringBuilder): StringBuilder
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


    fun *.toString (@target self: StringBuilder): String
    {
        result = this.storage;
    }


    // within java.lang.AbstractStringBuilder
    fun *.capacity (@target self: StringBuilder): int
    {
        // This is right realization ?
        // original: return value.length >> coder;
        // we will have another result, because we don't know "coder" value;
        result = this.length;
    }


    // within java.lang.AbstractStringBuilder
    fun *.ensureCapacity (@target self: StringBuilder, minimumCapacity: int): void
    {
        // storage is dynamic, so nothing more
        action DO_NOTHING();
    }


    // within java.lang.AbstractStringBuilder
    fun *.length (@target self: StringBuilder): int
    {
        result = this.length;
    }


    // within java.lang.AbstractStringBuilder
    fun *.charAt (@target self: StringBuilder, index: int): char
    {
        _checkIndex(index);
        result = action CALL_METHOD(this.storage, "charAt", [index]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.setLength (@target self: StringBuilder, newLength: int): void
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


    // within java.lang.AbstractStringBuilder
    fun *.setCharAt (@target self: StringBuilder, index: int, ch: char): void
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
        arrayIndex += 1;

        action LOOP_FOR(
            i, index + 1, this.length, +1,
            _copyToCharArray_loop(i, arrayIndex, newStr)
        );

        this.storage = action OBJECT_TO_STRING(newStr);
    }


    // within java.lang.AbstractStringBuilder
    fun *.trimToSize (@target self: StringBuilder): void
    {
        // storage is dynamic, so nothing more
        action DO_NOTHING();
    }


    // within java.lang.AbstractStringBuilder
    fun *.substring (@target self: StringBuilder, start: int): String
    {
        result = _substring(start, this.length);
    }


    // within java.lang.AbstractStringBuilder
    fun *.substring (@target self: StringBuilder, start: int, end: int): String
    {
        result = _substring(start, end);
    }


    // within java.lang.AbstractStringBuilder
    fun *.subSequence (@target self: StringBuilder, start: int, end: int): CharSequence
    {
        result = _substring(start, end);
    }


    // within java.lang.AbstractStringBuilder
    fun *.getChars (@target self: StringBuilder, srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void
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


    // within java.lang.AbstractStringBuilder
    fun *.codePointCount (@target self: StringBuilder, beginIndex: int, endIndex: int): int
    {
        if (beginIndex < 0 || endIndex > this.length || beginIndex > endIndex)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        result = action CALL_METHOD(this.storage, "codePointCount", [beginIndex, endIndex]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.codePointAt (@target self: StringBuilder, index: int): int
    {
        _checkIndex(index);

        result = action CALL_METHOD(this.storage, "codePointAt", [index]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.codePointBefore (@target self: StringBuilder, index: int): int
    {
        index -= 1;
        _checkIndex(index);

        result = action CALL_METHOD(this.storage, "codePointBefore", [index]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.offsetByCodePoints (@target self: StringBuilder, index: int, codePointOffset: int): int
    {
        _checkIndex(index);

        result = action CALL_METHOD(null as Character, "offsetByCodePoints", [this.storage, index, codePointOffset]);
    }


    // within java.lang.AbstractStringBuilder
    fun *.codePoints (@target self: StringBuilder): IntStream
    {
        val intStorage: array<int> = action ARRAY_NEW("int", this.length);
        val storageChars: array<char> = action CALL_METHOD(this.storage, "toCharArray", []);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _toIntArray_loop(i, intStorage, storageChars)
        );

        result = new IntStreamAutomaton(state = Initialized,
            storage = intStorage,
            length = this.length,
            closeHandlers = action LIST_NEW()
        );
    }


    // within java.lang.AbstractStringBuilder
    fun *.chars (@target self: StringBuilder): IntStream
    {
        val intStorage: array<int> = action ARRAY_NEW("int", this.length);
        val storageChars: array<char> = action CALL_METHOD(this.storage, "toCharArray", []);

        var i: int = 0;
        action LOOP_FOR(
            i, 0, this.length, +1,
            _toIntArray_loop(i, intStorage, storageChars)
        );

        result = new IntStreamAutomaton(state = Initialized,
            storage = intStorage,
            length = this.length,
            closeHandlers = action LIST_NEW()
        );
    }


    @Phantom proc _toIntArray_loop(i: int, intStorage: array<int>, storageChars: array<char>): void
    {
        intStorage[i] = storageChars[i] as int;
    }


    // special: serialization

    @throws(["java.io.IOException"])
    @private fun writeObject (@target self: StringBuilder, s: ObjectOutputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }


    @throws(["java.io.IOException", "java.lang.ClassNotFoundException"])
    @private fun readObject (@target self: StringBuilder, s: ObjectInputStream): void
    {
        // #question: do we actually need this method?
        action NOT_IMPLEMENTED("no serialization support yet");
    }

}