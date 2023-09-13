//#! pragma: non-synthesizable

libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/lang/StringBuffer.java";

// imports

import java.common;
import java/io/_interfaces;
import java/lang/_interfaces;


// local semantic types

//@extends("java.lang.AbstractStringBuilder") - убирать, так как он виден только в пакете джавы, оставлять только если паблик
@implements("java.io.Serializable")
@implements("java.lang.Comparable")
@implements("java.lang.CharSequence")
@public @final type StringBuffer
    is java.lang.StringBuffer
    for Object
{
   // @private @static @final var serialVersionUID: long = 3388685877147921107;
}


// === CONSTANTS ===

val MAX_CODE_POINT: int = 1114111;
val MIN_LOW_SURROGATE: int = 56320;
val MIN_HIGH_SURROGATE: int = 55296;
val MIN_SUPPLEMENTARY_CODE_POINT: int = 65536;


// automata

automaton StringBufferAutomaton
(
    @private @transient toStringCache: String,
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
        equals,
        getChars,
        getClass,
        hashCode,
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
        notify,
        notifyAll,
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
        wait (StringBuffer),
        wait (StringBuffer, long),
        wait (StringBuffer, long, int),
    ];

    // internal variables
    var storage: String;
    var length: int;

    var toStringCache: String = action OBJECT_TO_STRING(object);


    // utilities

     proc _checkRange (start: int, end: int, len: int): void
    {
        if (start < 0 || start > end || end > len)
        {
            val message: String = "start " + action OBJECT_TO_STRING(start) + ", end " + action OBJECT_TO_STRING(end) + ", length " + action OBJECT_TO_STRING(len);
            action THROW_NEW("java.lang.IndexOutOfBoundsException", [message]);
        }
    }


    proc _checkRangeSIOOBE (start: int, end: int, len: int): void
    {
        if (start < 0 || start > end || end > len)
        {
            val message: String = "start " + action OBJECT_TO_STRING(start) + ", end " + action OBJECT_TO_STRING(end) + ", length " + action OBJECT_TO_STRING(len);
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [message]);
        }
    }


    proc _checkIndex (index: int): void
    {
         if (index < 0 || index >= this.length)
         {
             val message: String = "index " + action OBJECT_TO_STRING(index) + ",length " + action OBJECT_TO_STRING(this.length);
             action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [message]);
         }
    }


    proc _checkOffset (offset: int): void
    {
        if (offset < 0 || offset > this.length) {
            val message: String = "offset " + action OBJECT_TO_STRING(offset) + ",length " + action OBJECT_TO_STRING(this.length);
            action THROW_NEW("java.lang.StringIndexOutOfBoundsException", [message]);
        }
    }


    proc _isBmpCodePoint (codePoint: int): boolean
    {
        result = codePoint >>> 16 == 0;
    }


    proc _isValidCodePoint (codePoint: int): boolean
    {
        val plane: int = codePoint >>> 16;
        result = plane < ((MAX_CODE_POINT + 1) >>> 16);
    }


    proc _lowSurrogate (codePoint: int): char
    {
        result = ((codePoint & 1023) + MIN_LOW_SURROGATE) as char;
    }


    proc _highSurrogate (codePoint: int): char
    {
        result = ((codePoint >>> 10) + (MIN_HIGH_SURROGATE - (MIN_SUPPLEMENTARY_CODE_POINT >>> 10))) as char;
    }


    proc _appendCharSequence_loop(i: int, seq: CharSequence): void
    {
        var currentChar: char = action CALL_METHOD(seq, "charAt", [i]);
        this.storage += action OBJECT_TO_STRING(currentChar);
    }


    // constructors
    @AnnotatedWith("jdk.internal.HotSpotIntrinsicCandidate") //убрать!
    constructor *.StringBuffer (@target self: StringBuffer)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length >= 0;

        this.storage = "";
        this.length = 0;
    }


    constructor *.StringBuffer (@target self: StringBuffer, seq: CharSequence)
    {
       assigns this.storage;
       assigns this.length;
       ensures this.storage != null;
       ensures this.length >= 0;

       if (seq == null)
       {
            action THROW_NEW("java.lang.NullPointerException");
       }
       else
       {
           val seqLength: int = action CALL_METHOD(seq, "length", []);
           this.length = seqLength;

           var i: int = 0;
           action LOOP_FOR(i, 0, seqLength, +1, _appendCharSequence_loop(i, seq));
       }
    }


    constructor *.StringBuffer (@target self: StringBuffer, str: String)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length >= 0;

        if (str == null)
        {
            action THROW_NEW("java.lang.NullPointerException");
        }
        else
        {
            val strLength: int = action CALL_METHOD(str, "length", []);
            this.length = strLength;
            this.storage = str;
        }
    }

    constructor *.StringBuffer (@target self: StringBuffer, capacity: int)
    {
        assigns this.storage;
        assigns this.length;
        ensures this.storage != null;
        ensures this.length >= 0;

        this.storage = "";
        this.length = 0;
    }


    // static methods

    // methods
    @AnnotatedWith("java.lang.Override")
    @synchronized fun *.append (@target self: StringBuffer, s: CharSequence): StringBuffer
    {
        if (seq == null)
        {
            action THROW_NEW("java.lang.NullPointerException");
        }
        else
        {
            val seqLength: int = action CALL_METHOD(seq, "length", []);
            this.length += seqLength;

            var i: int = 0;
            action LOOP_FOR(i, 0, seqLength, +1, _appendCharSequence_loop(i, seq));
        }
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, s: CharSequence, start: int, end: int): StringBuffer
    {
        if (seq == null)
            seq = "null";
        val seqLength: int = action CALL_METHOD(seq, "length", []);
        _checkRange(start, end, seqLength);
        this.length += end - start;
        var i: int = 0;
        action LOOP_FOR(i, start, end, +1, _appendCharSequence_loop(i, seq));
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
          this.storage += action OBJECT_TO_STRING(obj);
          this.length = action CALL_METHOD(this.storage, "length", []);
      }
      result = self;
    }

    @synchronized fun *.append (@target self: StringBuffer, str: String): StringBuffer
    {
     if (str == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else
        {
            this.storage += str;
            this.length = action CALL_METHOD(this.storage, "length", []);
        }
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, sb: StringBuffer): StringBuffer
    {
        if (sb == null)
        {
            this.storage += "null";
            this.length += 4;
        }
        else
        {
            // That's right for StringBuffer ?
            this.storage += action OBJECT_TO_STRING(sb);
            this.length = action CALL_METHOD(this.storage, "length", []);
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
        // That's right for char ?
        this.storage += action OBJECT_TO_STRING(c);
        this.length += 1;
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>): StringBuffer
    {
        val strSize: int = action ARRAY_SIZE(str);
        this.length += strSize;
        var i: int = 0;
        action LOOP_FOR(i, 0, strSize, +1, _appendCharsArray_loop(i, str));
        result = self;
    }

    @Phantom proc _appendCharsArray_loop(i: int, str: array<char>): void
    {
        var currentChar: char = str[i];
        this.storage += action OBJECT_TO_STRING(currentChar);
    }


    @synchronized fun *.append (@target self: StringBuffer, str: array<char>, offset: int, len: int): StringBuffer
    {
        val end: int = offset + len;
        val strSize: int = action ARRAY_SIZE(str);
        _checkRange(offset, end, strSize);
        var i: int = 0;
        action LOOP_FOR(i, 0, strSize, +1, _appendCharsArray_loop(i, str));
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, d: double): StringBuffer
    {
        this.storage += action OBJECT_TO_STRING(d);
        this.length += 1;
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, f: float): StringBuffer
    {
        this.storage += action OBJECT_TO_STRING(f);
        this.length += 1;
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, i: int): StringBuffer
    {
        this.storage += action OBJECT_TO_STRING(i);
        this.length += 1;
        result = self;
    }


    @synchronized fun *.append (@target self: StringBuffer, lng: long): StringBuffer
    {
        this.storage += action OBJECT_TO_STRING(lng);
        this.length += 1;
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
            val firstChar: char = _lowSurrogate(codePoint);
            val secondChar: char = _highSurrogate(codePoint);
            this.storage += action OBJECT_TO_STRING(firstChar);
            this.storage += action OBJECT_TO_STRING(secondChar);
            this.length += 2;
        }
        else
        {
            val message: String = "Not a valid Unicode code point: 0x%X" + action OBJECT_TO_STRING(codePoint);
            action THROW_NEW("java.lang.IllegalArgumentException", [message]);
        }
        result = self;
    }

    @AnnotatedWith("java.lang.Override")
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


//  within java.lang.AbstractStringBuilder
//  It is right? Example from Random.lsl.
    fun *.chars (@target self: StringBuffer): IntStream
    {
      // #problem: no streams yet
       result = action SYMBOLIC("java.util.stream.IntStream");
       action ASSUME(result != null);
    }

    @Phantom proc _strToCharArray_loop(i: int, charArray: array<char>): void
    {
        charArray[i] = action CALL_METHOD(this.storage, "charAt", [i]);
    }


    @synchronized fun *.codePointAt (@target self: StringBuffer, index: int): int
    {
        _checkIndex(index);

        val charArray: array<char> = action ARRAY_NEW("char", this.length);
        var i: int = 0;
        action LOOP_FOR(i, 0, this.length, +1, _strToCharArray_loop(i, charArray));

        result = action DEBUG_DO("Character.codePointAt(charArray, index, this.length)");
    }


    @synchronized fun *.codePointBefore (@target self: StringBuffer, index: int): int
    {
        index -= 1;
        _checkIndex(index);

        val charArray: array<char> = action ARRAY_NEW("char", this.length);
        var i: int = 0;
        action LOOP_FOR(i, 0, this.length, +1, _strToCharArray_loop(i, charArray));

        result = action DEBUG_DO("Character.codePointAt(charArray, index, this.length)");
    }


    @synchronized fun *.codePointCount (@target self: StringBuffer, beginIndex: int, endIndex: int): int
    {
        if (beginIndex < 0 || endIndex > this.length || beginIndex > endIndex)
            action THROW_NEW("java.lang.IndexOutOfBoundsException", []);

        val count: int = endIndex - beginIndex;
        val charArray: array<char> = action ARRAY_NEW("char", this.length);
        var i: int = 0;
        action LOOP_FOR(i, 0, this.length, +1, _strToCharArray_loop(i, charArray));

        result = action DEBUG_DO("Character.codePointCount(charArray, beginIndex, count)");
    }


    // within java.lang.AbstractStringBuilder
    //  It is right? Example from Random.lsl.
    fun *.codePoints (@target self: StringBuffer): IntStream
    {
       // #problem: no streams yet
       result = action SYMBOLIC("java.util.stream.IntStream");
       action ASSUME(result != null);
    }

    @AnnotatedWith("java.lang.Override")
    @synchronized fun *.compareTo (@target self: StringBuffer, another: StringBuffer): int
    {
        if (another == self)
        {
            result = 0;
        }
        val anotherString: String = action OBJECT_TO_STRING(another);
        result = action CALL_METHOD(this.storage, "compareTo", [anotherString]);
    }


    @synchronized fun *.delete (@target self: StringBuffer, start: int, end: int): StringBuffer
    {
        if (end > this.length)
            end = this.length;

        _checkRangeSIOOBE(start, end, this.length);

        val len: int = end - start;
        var newString: array<char> = action ARRAY_NEW("char", len);

        var i: int = 0;
        var currentIndex: int = 0;
        val index: int = -1;
        action LOOP_FOR(i, start, end, +1, _deleteCharAt_loop(i, index, currentIndex, newString));

        this.storage = action OBJECT_TO_STRING(newString);

        result = self;
    }


    @synchronized fun *.deleteCharAt (@target self: StringBuffer, index: int): StringBuffer
    {
        _checkIndex(index);
        //var newString: String = "";
        var newString: array<char> = action ARRAY_NEW("char", this.length - 1);
        var i: int = 0;
        var currentIndex: int = 0;
        action LOOP_FOR(i, 0, this.length, +1, _deleteCharAt_loop(i, index, currentIndex, newString));

        this.storage = action OBJECT_TO_STRING(newString);
        this.length -= 1;
        result = self;
    }

    @Phantom proc _deleteCharAt_loop(i: int, index: int, currentIndex:int, newString: array<char>): void
    {
        if (i != index)
        {
            val currentChar: char = action CALL_METHOD(this.storage, "charAt", [i]);
            newString[currentIndex] = currentChar;
            currentIndex += 1;
        }
    }


    @synchronized fun *.ensureCapacity (@target self: StringBuffer, minimumCapacity: int): void
    {

    }


    // within java.lang.Object
    fun *.equals (@target self: StringBuffer, obj: Object): boolean
    {
        result = action OBJECT_EQUALS(self, obj);
    }


    @synchronized fun *.getChars (@target self: StringBuffer, srcBegin: int, srcEnd: int, dst: array<char>, dstBegin: int): void
    {
        _checkRangeSIOOBE(srcBegin, srcEnd, this.length);
        var n: int = srcEnd - srcBegin;
        val dstLength: int = action ARRAY_SIZE(dst);
        _checkRange(dstBegin, dstBegin + n, dstLength);

        var i: int = 0;
        action LOOP_FOR(i, srcBegin, srcEnd, +1, _getChars_loop(i, dstBegin, dst));
    }


    @Phantom proc _getChars_loop(i: int, dstBegin: int, dst: array<char>): void
    {
        dst[dstBegin] = action CALL_METHOD(this.storage, "charAt", [i]);
        dstBegin += 1;
    }


    // within java.lang.Object
    @final fun *.getClass (@target self: StringBuffer): Class
    {
        action TODO();
    }


    // within java.lang.Object
    fun *.hashCode (@target self: StringBuffer): int
    {
         result = action OBJECT_HASH_CODE(this.storage);
    }


    fun *.indexOf (@target self: StringBuffer, str: String): int
    {
        result = action DEBUG_DO("this.storage.indexOf(str)");
    }


    @synchronized fun *.indexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        result = action DEBUG_DO("this.storage.indexOf(str, fromIndex)");
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence): StringBuffer
    {
        _checkOffset(dstOffset);

        if (s == null)
            s = "null";

        val len: int = action CALL_METHOD(s, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }

    @Phantom proc _insertCharSequence_loop(i: int, dstOffset: int, endIndex: int, currentIndex:int, newStr: array<char>, s: CharSequence): void
    {
        if (i < dstOffset)
        {
            val currentChar_1: char = action CALL_METHOD(this.storage, "charAt", [i]);
            newStr[i] = currentChar_1;
        }
        else if (i < endIndex)
        {
            val currentChar_2: char = action CALL_METHOD(s, "charAt", [currentIndex]);
            newStr[i] = currentChar_2;
            currentIndex += 1;
        }
        else
        {
            val index: int = i - dstOffset;
            val currentChar_3: char = action CALL_METHOD(this.storage, "charAt", [index]);
            newStr[i] = currentChar_3;
        }
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, s: CharSequence, start: int, end: int): StringBuffer
    {
        _checkOffset(dstOffset);

        if (s == null)
            s = "null";

        val len: int = action CALL_METHOD(s, "length", []);

        _checkRange(start, end, len);

        val countInsertedElements: int = end - start;
        val newStr: array<char> = action ARRAY_NEW("char", this.length + countInsertedElements);

        var i: int = 0;
        var currentIndex: int = start;
        val endIndex: int = dstOffset + countInsertedElements;
        this.length += countInsertedElements;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, offset: int, obj: Object): StringBuffer
    {
        // For cycle (names must be equals)
        val dstOffset: int = offset;

        _checkOffset(dstOffset);

        var s: String = "null";

        if (obj != null)
            s = action OBJECT_TO_STRING(obj);

        val len: int = action CALL_METHOD(s, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, offset: int, s: String): StringBuffer
    {
        // For cycle (names must be equals)
        val dstOffset: int = offset;

        _checkOffset(dstOffset);

        if (s == null)
            s = "null";

        val len: int = action CALL_METHOD(str, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, str));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, b: boolean): StringBuffer
    {
        _checkOffset(dstOffset);

        var s: String = "false";
        if (b)
            s = "true";

        val len: int = action CALL_METHOD(s, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, c: char): StringBuffer
    {
        _checkOffset(dstOffset);
        val s: String = action OBJECT_TO_STRING(c);

        val len: int = 1;
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, dstOffset: int, str: array<char>): StringBuffer
    {
        _checkOffset(dstOffset);
        val s: String = action OBJECT_TO_STRING(str);

        val len: int = 1;
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    @synchronized fun *.insert (@target self: StringBuffer, index: int, str: array<char>, offset: int, len: int): StringBuffer
    {
        action TODO();
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, d: double): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(d);

        if (s == null)
            s = "null";

        val len: int = action CALL_METHOD(s, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, dstOffset: int, f: float): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(f);

        if (s == null)
            s = "null";

        val len: int = action CALL_METHOD(s, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, offset: int, ii: int): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(ii);

        if (s == null)
            s = "null";

        val len: int = action CALL_METHOD(s, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    fun *.insert (@target self: StringBuffer, offset: int, l: long): StringBuffer
    {
        _checkOffset(dstOffset);
        var s: String = action OBJECT_TO_STRING(l);

        if (s == null)
            s = "null";

        val len: int = action CALL_METHOD(s, "length", []);
        val newStr: array<char> = action ARRAY_NEW("char", this.length + len);

        var i: int = 0;
        var currentIndex: int = 0;
        val endIndex: int = dstOffset + len;
        this.length += len;

        action LOOP_FOR(i, 0, this.length, +1, _insertCharSequence_loop(i, dstOffset, endIndex, currentIndex, newStr, s));

        this.storage = action OBJECT_TO_STRING(newStr);

        result = self;
    }


    fun *.lastIndexOf (@target self: StringBuffer, str: String): int
    {
        // May be = len - 1?
        result = action DEBUG_DO("this.storage.lastIndexOf(str)");
    }


    @synchronized fun *.lastIndexOf (@target self: StringBuffer, str: String, fromIndex: int): int
    {
        result = action DEBUG_DO("this.storage.lastIndexOf(str, fromIndex)");
    }


    @synchronized fun *.length (@target self: StringBuffer): int
    {
        action TODO();
    }


    // within java.lang.Object
    @final fun *.notify (@target self: StringBuffer): void
    {
        action TODO();
    }


    // within java.lang.Object
    @final fun *.notifyAll (@target self: StringBuffer): void
    {
        action TODO();
    }


    @synchronized fun *.offsetByCodePoints (@target self: StringBuffer, index: int, codePointOffset: int): int
    {
        action TODO();
    }


    @synchronized fun *.replace (@target self: StringBuffer, start: int, end: int, str: String): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.reverse (@target self: StringBuffer): StringBuffer
    {
        action TODO();
    }


    @synchronized fun *.setCharAt (@target self: StringBuffer, index: int, ch: char): void
    {
        action TODO();
    }


    @synchronized fun *.setLength (@target self: StringBuffer, newLength: int): void
    {
        action TODO();
    }


    @synchronized fun *.subSequence (@target self: StringBuffer, start: int, end: int): CharSequence
    {
        action TODO();
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int): String
    {
        action TODO();
    }


    @synchronized fun *.substring (@target self: StringBuffer, start: int, end: int): String
    {
        action TODO();
    }


    @synchronized fun *.toString (@target self: StringBuffer): String
    {
        action TODO();
    }


    @synchronized fun *.trimToSize (@target self: StringBuffer): void
    {
        action TODO();
    }


    @throws(["java.lang.InterruptedException"])
    // within java.lang.Object
    @final fun *.wait (@target self: StringBuffer): void
    {
        action TODO();
    }


    @throws(["java.lang.InterruptedException"])
    // within java.lang.Object
    @final fun *.wait (@target self: StringBuffer, arg0: long): void
    {
        action TODO();
    }


    @throws(["java.lang.InterruptedException"])
    // within java.lang.Object
    @final fun *.wait (@target self: StringBuffer, timeoutMillis: long, nanos: int): void
    {
        action TODO();
    }

}