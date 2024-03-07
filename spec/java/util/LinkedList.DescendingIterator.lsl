//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedList.java#L996";

// imports

import java/lang/Object;

import java/util/LinkedList;


// automata

automaton LinkedList_DescendingIteratorAutomaton
(
    var parent: LinkedList,
    var cursor: int,
    var expectedModCount: int
)
: LinkedList_DescendingIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       forEachRemaining,
       hasNext,
       next,
       remove,
    ];


    // local variables

    var lastRet: int = -1;


    // utilities

    @AutoInline @Phantom proc _throwCME (): void
    {
        action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    @AutoInline @Phantom proc _checkForComodification (): void
    {
        if (LinkedListAutomaton(this.parent).modCount != this.expectedModCount)
            _throwCME();
    }


    // methods

    fun *.hasNext (@target self: LinkedList_DescendingIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != 0;
    }


    fun *.next (@target self: LinkedList_DescendingIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val parentStorage: list<Object> = LinkedListAutomaton(this.parent).storage;

        val i: int = this.cursor - 1;
        if (i < 0)
            action THROW_NEW("java.util.NoSuchElementException", []);

        // iterrator validity check
        if (i >= action LIST_SIZE(parentStorage))
            _throwCME();

        this.cursor = i;
        this.lastRet = i;

        result = action LIST_GET(parentStorage, i);
    }


    fun *.remove (@target self: LinkedList_DescendingIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        val pStorage: list<Object> = LinkedListAutomaton(this.parent).storage;
        if (this.lastRet >= action LIST_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            LinkedListAutomaton(this.parent).modCount += 1;

            action LIST_REMOVE(pStorage, this.lastRet);
        }

        this.cursor = this.lastRet;
        this.lastRet = -1;
        this.expectedModCount = LinkedListAutomaton(this.parent).modCount;
    }


    fun *.forEachRemaining (@target self: LinkedList_DescendingIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        val es: list<Object> = LinkedListAutomaton(this.parent).storage;
        val size: int = action LIST_SIZE(es);

        if (i < size)
        {
            // using this exact loop form here due to complex termination expression
            action LOOP_WHILE(
                i < size && LinkedListAutomaton(this.parent).modCount == this.expectedModCount,
                forEachRemaining_loop(userAction, es, i)
            );

            // JDK NOTE: "update once at end to reduce heap write traffic"
            this.cursor = i;
            this.lastRet = i - 1;
            _checkForComodification();
        }
    }

    @Phantom proc forEachRemaining_loop (userAction: Consumer, es: list<Object>, i: int): void
    {
        val item: Object = action LIST_GET(es, i);
        action CALL(userAction, [item]);

        i += 1;
    }

}
