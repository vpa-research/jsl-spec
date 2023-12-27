libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/HashMap.java#L1524";

// imports

import java/lang/Object;
import java/util/HashMap;
import java/util/Iterator;
import java/util/function/Consumer;


// automata

automaton HashMap_EntryIteratorAutomaton
(
    var parent: HashMap,
    var unseen: map<Object, Map_Entry<Object, Object>>
)
: HashMap_EntryIterator
{
    // states and shifts

    initstate Allocated;
    state Initialized;

    shift Allocated -> Initialized by [
        // constructors
        `<init>`,
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

    @private constructor *.`<init>` (@target self: HashMap_EntryIterator, _this: HashMap)
    {
        action ERROR("Private constructor call");
    }


    // static methods

    // methods

    // within java.util.Iterator
    fun *.forEachRemaining (@target self: HashMap_EntryIterator, userAction: Consumer): void
    {
        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var size: int = action MAP_SIZE(this.unseen);

        if (size != 0)
        {
            val parentStorage: map<Object, Map_Entry<Object, Object>> = HashMapAutomaton(this.parent).storage;

            action LOOP_WHILE(
                size != 0 && HashMapAutomaton(this.parent).modCount == this.expectedModCount,
                forEachRemaining_loop(userAction, parentStorage, size)
            );

            _checkForComodification();
        }
    }


    @Phantom proc forEachRemaining_loop (userAction: Consumer, parentStorage: map<Object, Map_Entry<Object, Object>>, size: int): void
    {
        val curKey: Object = action MAP_GET_ANY_KEY(this.unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(this.unseen, curKey);
        action CALL(userAction, [entry]);
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

        val curKey: Object = action MAP_GET_ANY_KEY(this.unseen);
        val entry: Map_Entry<Object, Object> = action MAP_GET(this.unseen, curKey);
        action MAP_REMOVE(this.unseen, curKey);
        result = entry;
        this.currentKey = curKey;
    }


    // within java.util.HashMap.HashIterator
    @final fun *.remove (@target self: HashMap_EntryIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.currentKey == null)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        // #question: this is right ? Or not ?
        action MAP_REMOVE(this.unseen, this.currentKey);
        val parentStorage: map<Object, Map_Entry<Object, Object>> = HashMapAutomaton(this.parent).storage;
        action MAP_REMOVE(parentStorage, this.currentKey);
        HashMapAutomaton(this.parent).modCount += 1;

        this.expectedModCount = HashMapAutomaton(this.parent).modCount;
        this.currentKey = null;
    }

}