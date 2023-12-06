libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap$KeyIterator.java";

// imports

import java/lang/Object;
import java/util/HashMap;
import java/util/Iterator;
import java/util/function/Consumer;


// automata

automaton HashMapKeyIteratorAutomaton
(
    var parent: HashMap,
    var storageCopy: map<Object, Object>
)
: HashMapKeyIterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        HashMapKeyIterator,
    ];

    shift Initialized -> self by [
        // instance methods
        forEachRemaining,
        hasNext,
        next,
        remove,
    ];

    // internal variables

    var expectedModCount: int;
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

    @private constructor *.HashMapKeyIterator (@target self: HashMapKeyIterator, _this: HashMap)
    {
        this.expectedModCount = HashMapAutomaton(this.parent).modCount;
    }


    // static methods

    // methods

    // within java.util.Iterator
    fun *.forEachRemaining (@target self: HashMapKeyIterator, _action: Consumer): void
    {
        if (_action == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var size: int = action MAP_SIZE(this.storageCopy);

        if (size != 0)
        {
            val parentStorage: map<Object, Object> = HashMapAutomaton(this.parent).storage;

            action LOOP_WHILE(
                size != 0 && HashMapAutomaton(this.parent).modCount == this.expectedModCount,
                forEachRemaining_loop(_action, parentStorage, size)
            );

            _checkForComodification();
        }
    }


    @Phantom proc forEachRemaining_loop (_action: Consumer, parentStorage: map<Object, Object>, size: int): void
    {
        val key: Object = action MAP_GET_ANY_KEY(this.storageCopy);
        action CALL(_action, [key]);
        action MAP_REMOVE(this.storageCopy, key);
        size -= 1;
    }


    // within java.util.HashMap.HashIterator
    @final fun *.hasNext (@target self: HashMapKeyIterator): boolean
    {
        result = action MAP_SIZE(this.storageCopy) != 0;
    }


    @final fun *.next (@target self: HashMapKeyIterator): Object
    {
        _checkForComodification();

        val key: Object = action MAP_GET_ANY_KEY(this.storageCopy);
        action MAP_REMOVE(this.storageCopy, key);
        result = key;
        this.currentKey = key;
    }


    // within java.util.HashMap.HashIterator
    @final fun *.remove (@target self: HashMapKeyIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.currentKey == null)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        action MAP_REMOVE(this.storageCopy, this.currentKey);
        val parentStorage: map<Object, Object> = HashMapAutomaton(this.parent).storage;
        action MAP_REMOVE(parentStorage, this.currentKey);
        HashMapAutomaton(this.parent).modCount += 1;

        this.expectedModCount = HashMapAutomaton(this.parent).modCount;
        this.currentKey = null;
    }

}