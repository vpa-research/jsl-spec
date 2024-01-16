libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java#L1524";

// imports

import java/lang/Object;
import java/util/Iterator;
import java/util/function/Consumer;

import java/util/HashMap;


// automata

automaton HashMap_EntryIteratorAutomaton
(
    var parent: HashMap,
    var unseen: map<Object, Map_Entry<Object, Object>>,
    var expectedModCount: int
)
: HashMap_EntryIterator
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


    proc _checkForComodification (): void
    {
        val modCount: int = HashMapAutomaton(this.parent).modCount;
        if (modCount != this.expectedModCount)
            _throwCME();
    }


    // constructors

    // static methods

    // methods

    // within java.util.Iterator
    fun *.forEachRemaining (@target self: HashMap_EntryIterator, userAction: Consumer): void
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

        val curKey: Object = action MAP_GET_ANY_KEY(this.unseen);

        action CALL(userAction, [action MAP_GET(this.unseen, curKey)]);

        action MAP_REMOVE(this.unseen, curKey);
        size -= 1;
    }


    // within java.util.HashMap.HashIterator
    @final fun *.hasNext (@target self: HashMap_EntryIterator): boolean
    {
        result = action MAP_SIZE(this.unseen) != 0;
    }


    @final fun *.next (@target self: HashMap_EntryIterator): Map_Entry
    {
        _checkForComodification();

        if (action MAP_SIZE(this.unseen) == 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        val curKey: Object = action MAP_GET_ANY_KEY(this.unseen);

        result = action MAP_GET(this.unseen, curKey);

        action MAP_REMOVE(this.unseen, curKey);
        this.currentKey = curKey;
    }


    // within java.util.HashMap.HashIterator
    @final fun *.remove (@target self: HashMap_EntryIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val key: Object = this.currentKey;
        if (key == null)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        action MAP_REMOVE(HashMapAutomaton(this.parent).storage, key);
        HashMapAutomaton(this.parent).modCount += 1;
        action MAP_REMOVE(this.unseen, key);

        this.expectedModCount = HashMapAutomaton(this.parent).modCount;
        this.currentKey = null;
    }

}
