//#! pragma: non-synthesizable
libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";

@TypeMapping("java.util.Collection")
typealias Collection = Object;    // #problem

@TypeMapping("java.util.Comparator")
typealias Comparator = Object;    // #problem

@TypeMapping("java.util.Deque")
typealias Deque = Object;    // #problem

@TypeMapping("java.util.Iterator")
typealias Iterator = Object;    // #problem

@TypeMapping("java.util.List")
typealias List = Object;    // #problem

@TypeMapping("java.util.ListIterator")
typealias ListIterator = Object;    // #problem

@TypeMapping("java.util.Map")
typealias Map = Object;    // #problem

@TypeMapping("java.util.Queue")
typealias Queue = Object;    // #problem

@TypeMapping("java.util.Set")
typealias Set = Object;    // #problem

@TypeMapping("java.util.Spliterator")
typealias Spliterator = Object;    // #problem
