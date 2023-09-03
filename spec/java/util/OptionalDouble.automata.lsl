///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/OptionDouble.java";

// imports

import java/lang/_interfaces;
import java/util/OptionalDouble;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// globals

val EMPTY_OPTIONAL_DOUBLE: OptionalDouble
    = new OptionalDoubleAutomaton(state = Initialized,
        value = 0.0d,
        present = false
    );


// automata

// TODO: find ways to get concepts working
@Deprecated
automaton concept TestConcept: Object
{
    var value: double;
}

automaton OptionalDoubleAutomaton
(
    var value: double,
    var present: boolean
)
: OptionalDouble
    implements TestConcept
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        OptionalDouble (OptionalDouble),
        OptionalDouble (OptionalDouble, double),

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
        orElseThrow (OptionalDouble),
        orElseThrow (OptionalDouble, Supplier),
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

    @private constructor *.OptionalDouble (@target self: OptionalDouble)
    {
        action NOT_IMPLEMENTED("this method can be called using reflection only");
    }


    @private constructor *.OptionalDouble (@target self: OptionalDouble, x: double)
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
    fun *.equals (@target self: OptionalDouble, other: Object): boolean
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
                    // #problem: need `Double.compare(this.value, other.value) == 0`
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


    fun *.getAsDouble (@target self: OptionalDouble): double
    {
        if (!this.present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @AnnotatedWith("java.lang.Override")
    fun *.hashCode (@target self: OptionalDouble): int
    {
        if (this.present)
            result = action OBJECT_HASH_CODE(this.value);
        else
            result = 0;
    }


    fun *.ifPresent (@target self: OptionalDouble, consumer: DoubleConsumer): void
    {
        requires !this.present || (this.present && consumer != null);

        if (this.present)
        {
            if (consumer == null)
                _throwNPE();

            action CALL(consumer, [this.value]);
        }
    }


    fun *.ifPresentOrElse (@target self: OptionalDouble, consumer: DoubleConsumer, emptyAction: Runnable): void
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


    fun *.isEmpty (@target self: OptionalDouble): boolean
    {
        result = this.present == false;
    }


    fun *.isPresent (@target self: OptionalDouble): boolean
    {
        result = this.present == true;
    }


    fun *.orElse (@target self: OptionalDouble, other: double): double
    {
        if (this.present)
            result = this.value;
        else
            result = other;
    }


    fun *.orElseGet (@target self: OptionalDouble, supplier: DoubleSupplier): double
    {
        requires supplier != null;

        if (supplier == null)
            _throwNPE();

        if (this.present)
            result = this.value;
        else
            result = action CALL(supplier, []);
    }


    fun *.orElseThrow (@target self: OptionalDouble): double
    {
        requires this.present;

        if (!this.present)
            action THROW_NEW("java.util.NoSuchElementException", ["No value present"]);

        result = this.value;
    }


    @Parameterized(["X extends java.lang.Throwable"])
    @throws(["java.lang.Throwable"])
    fun *.orElseThrow (@target self: OptionalDouble, @Parameterized(["? extends X"]) exceptionSupplier: Supplier): double
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


    fun *.stream (@target self: OptionalDouble): DoubleStream
    {
        action NOT_IMPLEMENTED("no decision");

        /*
        if (this.present)
            result = DoubleStream.of(this.value); // #problem
        else
            result = DoubleStream.empty(); // #problem
        */
    }


    @AnnotatedWith("java.lang.Override", [])
    fun *.toString (@target self: OptionalDouble): String
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
