//#! pragma: non-synthesizable
libsl "1.1.0";

library `std:io`
    version "11"
    language "Java"
    url "-";

// imports

import java.common;
import java/lang/_interfaces;


// local semantic types

type ObjectInputStream is java.io.ObjectInputStream for Object {
}


type ObjectOutputStream is java.io.ObjectOutputStream for Object {
}
