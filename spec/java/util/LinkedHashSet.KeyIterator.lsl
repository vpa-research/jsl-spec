///#! pragma: non-synthesizable
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedHashSet.java";

// imports

import java/util/LinkedHashSet;
import java/lang/Object;
import java/util/HashMap;
import java/util/function/Consumer;


// automata

automaton LinkedHashSet_KeyIteratorAutomaton
(
    var expectedModCount: int,
    var unseenKeys: map<Object, Object>,
    var parent: LinkedHashSet
)
: LinkedHashSet_KeyIterator
{

    var index: int = 0;
    var currentKey: Object = 0;
    var nextWasCalled: boolean = false;

    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,
    ];

    shift Initialized -> self by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
        forEachRemaining,
    ];


    // utilities

    proc _checkForComodification (): void
    {
        val modCount: int = LinkedHashSetAutomaton(this.parent).modCount;
        if (this.expectedModCount != modCount)
            action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    // constructors

    @private constructor *.`<init>` (@target self: LinkedHashSet_KeyIterator, source: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // methods

    fun *.hasNext (@target self: LinkedHashSet_KeyIterator): boolean
    {
        action ASSUME(this.parent != null);

        val parentStorage: map<Object, Object> = LinkedHashSetAutomaton(this.parent).storage;

        result = this.index < action MAP_SIZE(parentStorage);
    }


    @final fun *.next (@target self: LinkedHashSet_KeyIterator): Object
    {
        action ASSUME(this.parent != null);
        _checkForComodification();

        val parentStorage: map<Object, Object> = LinkedHashSetAutomaton(this.parent).storage;

        val atValidPosition: boolean = this.index < action MAP_SIZE(parentStorage);
        if (!atValidPosition)
            action THROW_NEW("java.util.NoSuchElementException", []);

        val key: Object = action MAP_GET_ANY_KEY(this.unseenKeys);
        action MAP_REMOVE(this.unseenKeys, key);
        action ASSUME(key != this.currentKey);

        this.currentKey = key;
        result = key;

        this.index += 1;
        this.nextWasCalled = true;
    }


    fun *.remove (@target self: LinkedHashSet_KeyIterator): void
    {
        action ASSUME(this.parent != null);

        val parentStorage: map<Object, Object> = LinkedHashSetAutomaton(this.parent).storage;

        val atValidPosition: boolean = this.index < action MAP_SIZE(parentStorage);
        if (!atValidPosition || !this.nextWasCalled)
            action THROW_NEW("java.lang.IllegalStateException", []);

        this.nextWasCalled = false;

        _checkForComodification();

        action MAP_REMOVE(parentStorage, this.currentKey);

        this.expectedModCount = LinkedHashSetAutomaton(this.parent).modCount;
    }


    fun *.forEachRemaining (@target self: LinkedHashSet_KeyIterator, userAction: Consumer): void
    {
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        val parentStorage: map<Object, Object> = LinkedHashSetAutomaton(this.parent).storage;
        val length: int = action MAP_SIZE(parentStorage);
        var i: int = this.index;

        action LOOP_WHILE(
            i < length,
            forEachRemaining_loop(userAction, i)
        );

        this.index = i;
        this.nextWasCalled = true;
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, i: int): void
    {
        _checkForComodification();

        val key: Object = action MAP_GET_ANY_KEY(this.unseenKeys);
        action MAP_REMOVE(this.unseenKeys, key);
        action ASSUME(key != this.currentKey);

        this.currentKey = key;

        action CALL(userAction, [key]);
        i += 1;
    }
}