libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";

@TypeMapping("java.util.Collection")
typealias Collection = Object;    // #problem

@TypeMapping("java.util.Map")
typealias Map = Object;    // #problem

@TypeMapping("java.util.Set")
typealias Set = Object;    // #problem
