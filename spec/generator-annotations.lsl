libsl "1.1.0";


/// generator-specific aspects

// Stores the result of a function computation as a private field inside of the generated class.
// Something like: `private Set fun_keySet_cached = null;`
annotation CacheOnce ();

// The marked feature is no longer needed or required.
annotation Deprecated (
    hint: string = "";
);

// Specifies expected parent automaton and a class-container.
annotation From (
    parentAutomatonName: string;
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

// General meta-data for a wrapper class generated from this automaton.
annotation WrapperMeta (
    src: string;
    dst: string;
    forceMatchInterfaces: bool = false;
);
