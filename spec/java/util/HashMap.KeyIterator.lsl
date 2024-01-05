libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java#L1514";

// imports

import java/lang/Object;
import java/util/Iterator;
import java/util/function/Consumer;

import java/util/HashMap;


// automata

automaton HashMap_KeyIteratorAutomaton
(
    var parent: HashMap,
    var unseen: map<Object, Map_Entry<Object, Object>>,
    var expectedModCount: int
)
: HashMap_KeyIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
        // instance methods
        forEachRemaining,
        hasNext,
        next,
        remove,
    ];

    // internal variables

    var currentKey: Object = null;


    // utilities

    @AutoInline @Phantom proc _throwCME (): void
    {
        action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    @AutoInline @Phantom proc _checkForComodification (): void
    {
        if (HashMapAutomaton(this.parent).modCount != this.expectedModCount)
            _throwCME();
    }


    // constructors

    // static methods

    // methods

    // within java.util.Iterator
    fun *.forEachRemaining (@target self: HashMap_KeyIterator, userAction: Consumer): void
    {
        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var size: int = action MAP_SIZE(this.unseen);

        if (size != 0)
            action LOOP_WHILE(
                size != 0 && HashMapAutomaton(this.parent).modCount == this.expectedModCount,
                forEachRemaining_loop(userAction, size)
            );
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, size: int): void
    {
        _checkForComodification();

        val key: Object = action MAP_GET_ANY_KEY(this.unseen);

        action CALL(userAction, [key]);

        action MAP_REMOVE(this.unseen, key);
        size -= 1;
    }


    // within java.util.HashMap.HashIterator
    @final fun *.hasNext (@target self: HashMap_KeyIterator): boolean
    {
        result = action MAP_SIZE(this.unseen) != 0;
    }


    @final fun *.next (@target self: HashMap_KeyIterator): Object
    {
        _checkForComodification();

        if (action MAP_SIZE(this.unseen) == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        result = action MAP_GET_ANY_KEY(this.unseen);

        action MAP_REMOVE(this.unseen, result);
        this.currentKey = result;
    }


    // within java.util.HashMap.HashIterator
    @final fun *.remove (@target self: HashMap_KeyIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val key: Object = this.currentKey;
        if (key == null)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        action MAP_REMOVE(this.unseen, key);
        action MAP_REMOVE(HashMapAutomaton(this.parent).storage, key);
        HashMapAutomaton(this.parent).modCount += 1;

        this.expectedModCount = HashMapAutomaton(this.parent).modCount;
        this.currentKey = null;
    }

}
