libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/List.java";

// imports

import java.common;
import java/lang/_interfaces;
import java/util/_interfaces;
import java/util/ArrayList;
import java/util/function/_interfaces;
import java/util/stream/_interfaces;


// local semantic types

@implements("java.util.List")
@public type CustomList
    is java.util.List
    for List
{
    //@private @static val serialVersionUID: long = 1; // #problem: should be 3905348978240129619
}


// automata

automaton CustomListAutomaton
(
)
: CustomList
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // static operations
        copyOf,
        of (),
        of (Object),
        of (Object, Object),
        of (Object, Object, Object),
        of (Object, Object, Object, Object),
        of (Object, Object, Object, Object, Object),
        of (Object, Object, Object, Object, Object, Object),
        of (Object, Object, Object, Object, Object, Object, Object),
        of (Object, Object, Object, Object, Object, Object, Object, Object),
        of (Object, Object, Object, Object, Object, Object, Object, Object, Object),
        of (Object, Object, Object, Object, Object, Object, Object, Object, Object, Object),
        of (array<Object>),
    ];

    shift Initialized -> self by [
        // instance methods
        add (CustomList, Object),
        add (CustomList, int, Object),
        addAll (CustomList, Collection),
        addAll (CustomList, int, Collection),
        clear,
        contains,
        containsAll,
        equals,
        forEach,
        get,
        hashCode,
        indexOf,
        isEmpty,
        iterator,
        lastIndexOf,
        listIterator (CustomList),
        listIterator (CustomList, int),
        parallelStream,
        remove (CustomList, Object),
        remove (CustomList, int),
        removeAll,
        removeIf,
        replaceAll,
        retainAll,
        set,
        size,
        sort,
        spliterator,
        stream,
        subList,
        toArray (CustomList),
        toArray (CustomList, IntFunction),
        toArray (CustomList, array<Object>),
    ];

    // internal variables

    // utilities

    // constructors

    // static methods

    @static fun *.copyOf (coll: Collection): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        var size: int = 0;
        val iter: Iterator = action CALL_METHOD(coll, "iterator", []);
        action LOOP_WHILE(
            action CALL_METHOD(iter, "hasNext", []),
            copyOf_loop(iter, data, size)
        );

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = size,
        );
    }

    @Phantom proc copyOf_loop (iter: Iterator, data: list<Object>, size: int): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        action LIST_INSERT_AT(data, size, item);
        size += 1;
    }


    @static fun *.of (): CustomList
    {
        result = new ArrayListAutomaton(state = Initialized,
            storage = action LIST_NEW(),
            length = 0,
        );
    }


    @static fun *.of (e1: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 1,
        );
    }


    @static fun *.of (e1: Object, e2: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 2,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 3,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 4,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);
        action LIST_INSERT_AT(data, 4, e5);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 5,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);
        action LIST_INSERT_AT(data, 4, e5);
        action LIST_INSERT_AT(data, 5, e6);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 6,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);
        action LIST_INSERT_AT(data, 4, e5);
        action LIST_INSERT_AT(data, 5, e6);
        action LIST_INSERT_AT(data, 6, e7);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 7,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object, e8: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);
        action LIST_INSERT_AT(data, 4, e5);
        action LIST_INSERT_AT(data, 5, e6);
        action LIST_INSERT_AT(data, 6, e7);
        action LIST_INSERT_AT(data, 7, e8);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 8,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object, e8: Object, e9: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);
        action LIST_INSERT_AT(data, 4, e5);
        action LIST_INSERT_AT(data, 5, e6);
        action LIST_INSERT_AT(data, 6, e7);
        action LIST_INSERT_AT(data, 7, e8);
        action LIST_INSERT_AT(data, 8, e9);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 9,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object, e8: Object, e9: Object, e10: Object): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);
        action LIST_INSERT_AT(data, 4, e5);
        action LIST_INSERT_AT(data, 5, e6);
        action LIST_INSERT_AT(data, 6, e7);
        action LIST_INSERT_AT(data, 7, e8);
        action LIST_INSERT_AT(data, 8, e9);
        action LIST_INSERT_AT(data, 9, e10);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = 10,
        );
    }


    @static @varargs fun *.of (elements: array<Object>): CustomList
    {
        val data: list<Object> = action LIST_NEW();

        val size: int = action ARRAY_SIZE(elements);
        action ASSUME(size >= 0);
        if (size != 0)
        {
            var i: int = 0;
            action LOOP_FOR(
                i, 0, size, +1,
                of_loop(i, elements, data)
            );
        }

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
            length = size,
        );
    }

    @Phantom proc of_loop (i: int, elements: array<Object>, data: list<Object>): void
    {
        action LIST_INSERT_AT(data, i, elements[i]);
    }


    // methods

    @Phantom fun *.add (@target self: CustomList, arg0: Object): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.add (@target self: CustomList, arg0: int, arg1: Object): void
    {
        // NOTE: using the original method
    }


    @Phantom fun *.addAll (@target self: CustomList, arg0: Collection): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.addAll (@target self: CustomList, arg0: int, arg1: Collection): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.clear (@target self: CustomList): void
    {
        // NOTE: using the original method
    }


    @Phantom fun *.contains (@target self: CustomList, arg0: Object): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.containsAll (@target self: CustomList, arg0: Collection): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.equals (@target self: CustomList, arg0: Object): boolean
    {
        // NOTE: using the original method
    }


    // within java.lang.Iterable
    @Phantom fun *.forEach (@target self: CustomList, _action: Consumer): void
    {
        // NOTE: using the original method
    }


    @Phantom fun *.get (@target self: CustomList, arg0: int): Object
    {
        // NOTE: using the original method
    }


    @Phantom fun *.hashCode (@target self: CustomList): int
    {
        // NOTE: using the original method
    }


    @Phantom fun *.indexOf (@target self: CustomList, arg0: Object): int
    {
        // NOTE: using the original method
    }


    @Phantom fun *.isEmpty (@target self: CustomList): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.iterator (@target self: CustomList): Iterator
    {
        // NOTE: using the original method
    }


    @Phantom fun *.lastIndexOf (@target self: CustomList, arg0: Object): int
    {
        // NOTE: using the original method
    }


    @Phantom fun *.listIterator (@target self: CustomList): ListIterator
    {
        // NOTE: using the original method
    }


    @Phantom fun *.listIterator (@target self: CustomList, arg0: int): ListIterator
    {
        // NOTE: using the original method
    }


    // within java.util.Collection
    @Phantom fun *.parallelStream (@target self: CustomList): Stream
    {
        // NOTE: using the original method
    }


    @Phantom fun *.remove (@target self: CustomList, arg0: Object): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.remove (@target self: CustomList, arg0: int): Object
    {
        // NOTE: using the original method
    }


    @Phantom fun *.removeAll (@target self: CustomList, arg0: Collection): boolean
    {
        // NOTE: using the original method
    }


    // within java.util.Collection
    @Phantom fun *.removeIf (@target self: CustomList, filter: Predicate): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.replaceAll (@target self: CustomList, operator: UnaryOperator): void
    {
        // NOTE: using the original method
    }


    @Phantom fun *.retainAll (@target self: CustomList, arg0: Collection): boolean
    {
        // NOTE: using the original method
    }


    @Phantom fun *.set (@target self: CustomList, arg0: int, arg1: Object): Object
    {
        // NOTE: using the original method
    }


    @Phantom fun *.size (@target self: CustomList): int
    {
        // NOTE: using the original method
    }


    @Phantom fun *.sort (@target self: CustomList, c: Comparator): void
    {
        // NOTE: using the original method
    }


    @Phantom fun *.spliterator (@target self: CustomList): Spliterator
    {
        // NOTE: using the original method
    }


    // within java.util.Collection
    @Phantom fun *.stream (@target self: CustomList): Stream
    {
        // NOTE: using the original method
    }


    @Phantom fun *.subList (@target self: CustomList, arg0: int, arg1: int): CustomList
    {
        // NOTE: using the original method
    }


    @Phantom fun *.toArray (@target self: CustomList): array<Object>
    {
        // NOTE: using the original method
    }


    // within java.util.Collection
    @Phantom fun *.toArray (@target self: CustomList, generator: IntFunction): array<Object>
    {
        // NOTE: using the original method
    }


    @Phantom fun *.toArray (@target self: CustomList, arg0: array<Object>): array<Object>
    {
        // NOTE: using the original method
    }

}
