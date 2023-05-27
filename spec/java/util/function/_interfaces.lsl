//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:collections`
    version "11"
    language "Java"
    url "-";

// import java-common;


@TypeMapping("java.util.function.BiConsumer")
typealias BiConsumer = Object;    // #problem

@TypeMapping("java.util.function.BiFunction")
typealias BiFunction = Object;    // #problem

@TypeMapping("java.util.function.BinaryOperator")
typealias BinaryOperator = Object;    // #problem

@TypeMapping("java.util.function.BiPredicate")
typealias BiPredicate = Object;    // #problem

@TypeMapping("java.util.function.BooleanSupplier")
typealias BooleanSupplier = Object;    // #problem

@TypeMapping("java.util.function.Consumer")
typealias Consumer = Object;    // #problem

@TypeMapping("java.util.function.DoubleBinaryOperator")
typealias DoubleBinaryOperator = Object;    // #problem


type DoubleConsumer is java.util.function.DoubleConsumer for Object {
    fun accept (x: double): void;
}


@TypeMapping("java.util.function.DoubleFunction")
typealias DoubleFunction = Object;    // #problem

@TypeMapping("java.util.function.DoublePredicate")
typealias DoublePredicate = Object;    // #problem


type DoubleSupplier is java.util.function.DoubleSupplier for Object {
    fun get (): double;
}


@TypeMapping("java.util.function.DoubleToIntFunction")
typealias DoubleToIntFunction = Object;    // #problem

@TypeMapping("java.util.function.DoubleToLongFunction")
typealias DoubleToLongFunction = Object;    // #problem

@TypeMapping("java.util.function.DoubleUnaryOperator")
typealias DoubleUnaryOperator = Object;    // #problem

@TypeMapping("java.util.function.Function")
typealias Function = Object;    // #problem

@TypeMapping("java.util.function.IntBinaryOperator")
typealias IntBinaryOperator = Object;    // #problem

@TypeMapping("java.util.function.IntConsumer")
typealias IntConsumer = Object;    // #problem

@TypeMapping("java.util.function.IntFunction")
typealias IntFunction = Object;    // #problem

@TypeMapping("java.util.function.IntPredicate")
typealias IntPredicate = Object;    // #problem

@TypeMapping("java.util.function.IntSupplier")
typealias IntSupplier = Object;    // #problem

@TypeMapping("java.util.function.IntToDoubleFunction")
typealias IntToDoubleFunction = Object;    // #problem

@TypeMapping("java.util.function.IntToLongFunction")
typealias IntToLongFunction = Object;    // #problem

@TypeMapping("java.util.function.IntUnaryOperator")
typealias IntUnaryOperator = Object;    // #problem

@TypeMapping("java.util.function.LongBinaryOperator")
typealias LongBinaryOperator = Object;    // #problem

@TypeMapping("java.util.function.LongConsumer")
typealias LongConsumer = Object;    // #problem

@TypeMapping("java.util.function.LongFunction")
typealias LongFunction = Object;    // #problem

@TypeMapping("java.util.function.LongPredicate")
typealias LongPredicate = Object;    // #problem

@TypeMapping("java.util.function.LongSupplier")
typealias LongSupplier = Object;    // #problem

@TypeMapping("java.util.function.LongToDoubleFunction")
typealias LongToDoubleFunction = Object;    // #problem

@TypeMapping("java.util.function.LongToIntFunction")
typealias LongToIntFunction = Object;    // #problem

@TypeMapping("java.util.function.LongUnaryOperator")
typealias LongUnaryOperator = Object;    // #problem

@TypeMapping("java.util.function.ObjDoubleConsumer")
typealias ObjDoubleConsumer = Object;    // #problem

@TypeMapping("java.util.function.ObjIntConsumer")
typealias ObjIntConsumer = Object;    // #problem

@TypeMapping("java.util.function.ObjLongConsumer")
typealias ObjLongConsumer = Object;    // #problem

@TypeMapping("java.util.function.Predicate")
typealias Predicate = Object;    // #problem


@Parametrized(["T"])
type Supplier is java.util.function.Supplier for Object {
    fun get (): Object;
}


@TypeMapping("java.util.function.ToDoubleBiFunction")
typealias ToDoubleBiFunction = Object;    // #problem

@TypeMapping("java.util.function.ToDoubleFunction")
typealias ToDoubleFunction = Object;    // #problem

@TypeMapping("java.util.function.ToIntBiFunction")
typealias ToIntBiFunction = Object;    // #problem

@TypeMapping("java.util.function.ToIntFunction")
typealias ToIntFunction = Object;    // #problem

@TypeMapping("java.util.function.ToLongBiFunction")
typealias ToLongBiFunction = Object;    // #problem

@TypeMapping("java.util.function.ToLongFunction")
typealias ToLongFunction = Object;    // #problem

@TypeMapping("java.util.function.UnaryOperator")
typealias UnaryOperator = Object;    // #problem
