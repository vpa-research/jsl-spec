///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionalLong.java";

// imports

import java/lang/Runnable;
import java/util/function/LongConsumer;
import java/util/function/LongSupplier;
import java/util/function/Supplier;
import java/util/stream/LongStream;

import java/util/OptionalLong;


// automata

automaton OptionalLongAutomaton
(
    var value: long,
    var present: boolean,
)
: LSLOptionalLong
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (LSLOptionalLong),
        `<init>` (LSLOptionalLong, long),

        // static methods
        empty,
        of,
    ];

    shift Initialized -> self by [
        // read operations
        getAsLong,
        isPresent,
        isEmpty,
        ifPresent,
        ifPresentOrElse,
        stream,
        orElse,
        orElseGet,
        orElseThrow (LSLOptionalLong),
        orElseThrow (LSLOptionalLong, Supplier),
        toString,
        hashCode,
        equals,
    ];


    // utilities

    @AutoInline @Phantom proc _throwNPE (): void
    {
        action THROW_NEW("java.lang.NullPointerException", []);
    }


    // constructors

    @private constructor *.`<init>` (@target self: LSLOptionalLong)
    {
        action NOT_IMPLEMENTED("this method can be called using reflection only");
    }


    @private constructor *.`<init>` (@target self: LSLOptionalLong, x: long)
    {
        action NOT_IMPLEMENTED("this method can be called using reflection only");
    }


    // static methods

    @static fun *.empty (): OptionalLong
    {
        result = EMPTY;
    }


    @static fun *.of (x: long): OptionalLong
    {
        result = new OptionalLongAutomaton(state = Initialized,
            value = x,
            present = true
        );
    }


    // methods

    @AnnotatedWith("java.lang.Override")
    fun *.equals (@target self: LSLOptionalLong, other: Object): boolean
    {
        if (other == self)
        {
            result = true;
        }
        else
        {
            val isSameType: boolean = action OBJECT_SAME_TYPE(self, other);
            if (isSameType)
            {
                val otherValue: long = OptionalLongAutomaton(other).value;
                val otherPresent: boolean = OptionalLongAutomaton(other).present;

                if (this.present && otherPresent)
                    result = this.value == otherValue;
                else
                    result = this.present == otherPresent;
            }
            else
            {
                result = false;
            }
        }
    }


    fun *.getAsLong (@target self: LSLOptionalLong): long
    {
        if (!this.present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @AnnotatedWith("java.lang.Override")
    fun *.hashCode (@target self: LSLOptionalLong): int
    {
        if (this.present)
            result = action OBJECT_HASH_CODE(this.value);
        else
            result = 0;
    }


    fun *.ifPresent (@target self: LSLOptionalLong, consumer: LongConsumer): void
    {
        requires !this.present || (this.present && consumer != null);

        if (this.present)
        {
            if (consumer == null)
                _throwNPE();

            action CALL(consumer, [this.value]);
        }
    }


    fun *.ifPresentOrElse (@target self: LSLOptionalLong, consumer: LongConsumer, emptyAction: Runnable): void
    {
        requires !this.present || (this.present  && consumer != null);
        requires this.present  || (!this.present && emptyAction != null);

        if (this.present)
        {
            if (consumer == null)
                _throwNPE();

            action CALL(consumer, [this.value]);
        }
        else
        {
            if (emptyAction == null)
                _throwNPE();

            action CALL(emptyAction, []);
        }
    }


    fun *.isEmpty (@target self: LSLOptionalLong): boolean
    {
        result = this.present == false;
    }


    fun *.isPresent (@target self: LSLOptionalLong): boolean
    {
        result = this.present == true;
    }


    fun *.orElse (@target self: LSLOptionalLong, other: long): long
    {
        if (this.present)
            result = this.value;
        else
            result = other;
    }


    fun *.orElseGet (@target self: LSLOptionalLong, supplier: LongSupplier): long
    {
        requires (supplier != null && !this.present) || this.present;

        if (this.present)
            result = this.value;
        else
            result = action CALL(supplier, []);
    }


    fun *.orElseThrow (@target self: LSLOptionalLong): long
    {
        requires this.present;

        if (!this.present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @Parameterized(["X extends java.lang.Throwable"])
    @throws(["java.lang.Throwable"])
    fun *.orElseThrow(@target self: LSLOptionalLong, @Parameterized(["? extends X"]) exceptionSupplier: Supplier): long
    {
        requires exceptionSupplier != null;

        if (exceptionSupplier == null)
            _throwNPE();

        if (!this.present)
        {
            val exception: Object = action CALL(exceptionSupplier, []);
            action THROW_VALUE(exception);
        }
        else
        {
            result = this.value;
        }
    }


    fun *.stream (@target self: LSLOptionalLong): LongStream
    {
        var items: array<long> = null;
        if (this.present)
        {
            items = action ARRAY_NEW("long", 1);
            items[0] = this.value;
        }
        else
        {
            items = action ARRAY_NEW("long", 0);
        }

        result = new LongStreamAutomaton(state = Initialized,
            storage = items,
            length = action ARRAY_SIZE(items),
            closeHandlers = action LIST_NEW(),
            isParallel = false,
        );
    }


    @AnnotatedWith("java.lang.Override")
    fun *.toString (@target self: LSLOptionalLong): String
    {
        if (this.present)
        {
            val valueStr: String = action OBJECT_TO_STRING(this.value);
            result = "OptionalLong[" + valueStr + "]";
        }
        else
        {
            result = "OptionalLong.empty";
        }
    }


    // special

    @Phantom @static fun *.`<clinit>` (): void
    {
        EMPTY = new OptionalLongAutomaton(state = Initialized,
            value = 0L,
            present = false
        );
    }

}

