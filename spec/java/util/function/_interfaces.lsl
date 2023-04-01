libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";


@TypeMapping("java.util.function.BiConsumer")
typealias BiConsumer = Object;    // #problem

@TypeMapping("java.util.function.BiFunction")
typealias BiFunction = Object;    // #problem

@TypeMapping("java.util.function.Function")
typealias Function = Object;    // #problem

@TypeMapping("java.util.function.IntConsumer")
typealias IntConsumer = Object;    // #problem

@TypeMapping("java.util.function.IntSupplier")
typealias IntSupplier = Object;    // #problem

@TypeMapping("java.util.function.Predicate")
typealias Predicate = Object;    // #problem

@TypeMapping("java.util.function.Supplier")
typealias Supplier = Object;    // #problem
