//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/List.java";

// imports

import java/lang/Object;
import java/util/ArrayList;
import java/util/Collection;
import java/util/Comparator;
import java/util/List;
import java/util/function/UnaryOperator;


// automata

automaton ListAutomaton
(
)
: LSLList
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
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
        replaceAll,
        sort,
        spliterator,
    ];

    // internal variables

    // utilities

    // constructors

    // static methods

    @static fun *.copyOf (coll: Collection): List
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
        );
    }

    @Phantom proc copyOf_loop (iter: Iterator, data: list<Object>, size: int): void
    {
        val item: Object = action CALL_METHOD(iter, "next", []);
        action LIST_INSERT_AT(data, size, item);
        size += 1;
    }


    @static fun *.of (): List
    {
        result = new ArrayListAutomaton(state = Initialized,
            storage = action LIST_NEW(),
        );
    }


    @static fun *.of (e1: Object): List
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
        );
    }


    @static fun *.of (e1: Object, e2: Object): List
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object): List
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object): List
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object): List
    {
        val data: list<Object> = action LIST_NEW();

        action LIST_INSERT_AT(data, 0, e1);
        action LIST_INSERT_AT(data, 1, e2);
        action LIST_INSERT_AT(data, 2, e3);
        action LIST_INSERT_AT(data, 3, e4);
        action LIST_INSERT_AT(data, 4, e5);

        result = new ArrayListAutomaton(state = Initialized,
            storage = data,
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object): List
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
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object): List
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
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object, e8: Object): List
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
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object, e8: Object, e9: Object): List
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
        );
    }


    @static fun *.of (e1: Object, e2: Object, e3: Object, e4: Object, e5: Object, e6: Object, e7: Object, e8: Object, e9: Object, e10: Object): List
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
        );
    }


    @static @varargs fun *.of (elements: array<Object>): List
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
        );
    }

    @Phantom proc of_loop (i: int, elements: array<Object>, data: list<Object>): void
    {
        action LIST_INSERT_AT(data, i, elements[i]);
    }


    // methods

    @Phantom fun *.replaceAll (@target self: LSLList, operator: UnaryOperator): void
    {
        // NOTE: using the original method
    }


    @Phantom fun *.sort (@target self: LSLList, c: Comparator): void
    {
        // NOTE: using the original method
    }


    @Phantom fun *.spliterator (@target self: LSLList): Spliterator
    {
        // NOTE: using the original method
    }

}
