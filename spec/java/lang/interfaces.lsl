libsl "1.1.0";

library "std:collections" language "Java" version "11" url "-";

import "java-common.lsl";


@TypeMapping("java.lang.Runnable")
typealias Runnable = Object;    // #problem
