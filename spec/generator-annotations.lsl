libsl "1.1.0";


/// generator-specific aspects

// The marked feature is no longer needed or required.
annotation Deprecated (
    hint: string = "";
);

// The merked method does not return to normal execution.
annotation NoReturn ();

// The marked action stops execution of current control flow by throwing exception or other means.
annotation StopsControlFlow ();

// Associates the type on the LEFT side of typealias with the specified type.
annotation TypeMapping (
    fullClassName: string = null;
    builtin: bool = false;
);

// Specifies expected parent automaton and a class-container.
annotation From (
    parentAutomatonName: string;
);

// General meta-data for a wrapper class generated from this automaton.
annotation WrapperMeta (
    src: string;
    dst: string;
    forceMatchInterfaces: bool = false;
);

// Stores a result of function computation as a private field inside of a generated class.
// Something like: `private Set fun_keySet_cached = null;`
annotation CacheOnce ();

