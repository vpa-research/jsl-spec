///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionDouble.java";

// imports

import java/lang/Runnable;
import java/util/function/DoubleConsumer;
import java/util/function/DoubleSupplier;
import java/util/function/Supplier;
import java/util/OptionalDouble;


// globals

val EMPTY_OPTIONAL_DOUBLE: OptionalDouble
    = new OptionalDoubleAutomaton(state = Initialized,
        value = 0.0,
        present = false
    );


// automata

automaton OptionalDoubleAutomaton
(
    var value: double,
    var present: boolean
)
: LSLOptionalDouble
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>` (LSLOptionalDouble),
        `<init>` (LSLOptionalDouble, double),

        // static methods
        empty,
        of,
    ];

    shift Initialized -> self by [
        // read operations
        getAsDouble,
        isPresent,
        isEmpty,
        ifPresent,
        ifPresentOrElse,
        stream,
        orElse,
        orElseGet,
        orElseThrow (LSLOptionalDouble),
        orElseThrow (LSLOptionalDouble, Supplier),
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

    @private constructor *.`<init>` (@target self: LSLOptionalDouble)
    {
        action NOT_IMPLEMENTED("this method can be called using reflection only");
    }


    @private constructor *.`<init>` (@target self: LSLOptionalDouble, x: double)
    {
        action NOT_IMPLEMENTED("this method can be called using reflection only");
    }


    // static methods

    @static fun *.empty (): OptionalDouble
    {
        result = EMPTY_OPTIONAL_DOUBLE;
    }


    @static fun *.of (x: double): OptionalDouble
    {
        result = new OptionalDoubleAutomaton(state = Initialized,
            value = x,
            present = true
        );
    }


    // methods

    @AnnotatedWith("java.lang.Override")
    fun *.equals (@target self: LSLOptionalDouble, other: Object): boolean
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
                val otherValue: double = OptionalDoubleAutomaton(other).value;
                val otherPresent: boolean = OptionalDoubleAutomaton(other).present;

                if (this.present && otherPresent)
                    result = action OBJECT_EQUALS(this.value, otherValue);
                else
                    result = this.present == otherPresent;
            }
            else
            {
                result = false;
            }
        }
    }


    fun *.getAsDouble (@target self: LSLOptionalDouble): double
    {
        if (!this.present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @AnnotatedWith("java.lang.Override")
    fun *.hashCode (@target self: LSLOptionalDouble): int
    {
        if (this.present)
            result = action OBJECT_HASH_CODE(this.value);
        else
            result = 0;
    }


    fun *.ifPresent (@target self: LSLOptionalDouble, consumer: DoubleConsumer): void
    {
        requires !this.present || (this.present && consumer != null);

        if (this.present)
        {
            if (consumer == null)
                _throwNPE();

            action CALL(consumer, [this.value]);
        }
    }


    fun *.ifPresentOrElse (@target self: LSLOptionalDouble, consumer: DoubleConsumer, emptyAction: Runnable): void
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


    fun *.isEmpty (@target self: LSLOptionalDouble): boolean
    {
        result = this.present == false;
    }


    fun *.isPresent (@target self: LSLOptionalDouble): boolean
    {
        result = this.present == true;
    }


    fun *.orElse (@target self: LSLOptionalDouble, other: double): double
    {
        if (this.present)
            result = this.value;
        else
            result = other;
    }


    fun *.orElseGet (@target self: LSLOptionalDouble, supplier: DoubleSupplier): double
    {
        requires supplier != null;

        if (supplier == null)
            _throwNPE();

        if (this.present)
            result = this.value;
        else
            result = action CALL(supplier, []);
    }


    fun *.orElseThrow (@target self: LSLOptionalDouble): double
    {
        requires this.present;

        if (!this.present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @Parameterized(["X extends java.lang.Throwable"])
    @throws(["java.lang.Throwable"])
    fun *.orElseThrow (@target self: LSLOptionalDouble, @Parameterized(["? extends X"]) exceptionSupplier: Supplier): double
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


    fun *.stream (@target self: LSLOptionalDouble): DoubleStream
    {
        // #todo: use custom stream implementation
        result = action SYMBOLIC("java.util.stream.DoubleStream");
        action ASSUME(result != null);
    }


    @AnnotatedWith("java.lang.Override", [])
    fun *.toString (@target self: LSLOptionalDouble): String
    {
        if (this.present)
        {
            val valueStr: String = action OBJECT_TO_STRING(this.value);
            result = "OptionalDouble[" + valueStr + "]";
        }
        else
        {
            result = "OptionalDouble.empty";
        }
    }

}
