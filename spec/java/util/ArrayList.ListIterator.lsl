libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/ArrayList.java";

// imports

import java/util/ArrayList;


// automata

automaton ArrayList_ListIteratorAutomaton
(
    var parent: ArrayList,
    var cursor: int,
    var expectedModCount: int
)
: ArrayList_ListIterator
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> self by [
       add,
       forEachRemaining,
       hasNext,
       hasPrevious,
       next,
       nextIndex,
       previous,
       previousIndex,
       remove,
       set,
    ];


    // local variables

    var lastRet: int = -1;


    // utilities

    @AutoInline @Phantom proc _throwCME (): void
    {
        action THROW_NEW("java.util.ConcurrentModificationException", []);
    }


    proc _checkForComodification (): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        val modCount: int = ArrayListAutomaton(this.parent).modCount;
        if (modCount != this.expectedModCount)
            _throwCME();
    }


    // methods

    fun *.hasPrevious (@target self: ArrayList_ListIterator): boolean
    {
        result = this.cursor != 0;
    }


    fun *.nextIndex (@target self: ArrayList_ListIterator): int
    {
        result = this.cursor;
    }


    fun *.previousIndex (@target self: ArrayList_ListIterator): int
    {
        result = this.cursor - 1;
    }


    fun *.hasNext (@target self: ArrayList_ListIterator): boolean
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        result = this.cursor != ArrayListAutomaton(this.parent).length;
    }


    fun *.next (@target self: ArrayList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val parentStorage: list<Object> = ArrayListAutomaton(this.parent).storage;

        val i: int = this.cursor;
        if (i >= ArrayListAutomaton(this.parent).length)
            action THROW_NEW("java.util.NoSuchElementException", []);

        // iterrator validity check
        if (i >= action LIST_SIZE(parentStorage))
            _throwCME();

        this.cursor = i + 1;
        this.lastRet = i;

        result = action LIST_GET(parentStorage, i);
    }


    fun *.previous (@target self: ArrayList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val parentStorage: list<Object> = ArrayListAutomaton(this.parent).storage;

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


    fun *.remove (@target self: ArrayList_ListIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        val pStorage: list<Object> = ArrayListAutomaton(this.parent).storage;
        if (this.lastRet >= action LIST_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            ArrayListAutomaton(this.parent).modCount += 1;

            action LIST_REMOVE(pStorage, this.lastRet);

            ArrayListAutomaton(this.parent).length -= 1;
        }

        this.cursor = this.lastRet;
        this.lastRet = -1;
        this.expectedModCount = ArrayListAutomaton(this.parent).modCount;
    }


    fun *.set (@target self: ArrayList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        val pStorage: list<Object> = ArrayListAutomaton(this.parent).storage;
        if (this.lastRet >= action LIST_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            action LIST_SET(pStorage, this.lastRet, e);
        }
    }


    fun *.add (@target self: ArrayList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        _checkForComodification();

        val i: int = this.cursor;

        val pStorage: list<Object> = ArrayListAutomaton(this.parent).storage;
        if (this.lastRet > action LIST_SIZE(pStorage))
        {
            _throwCME();
        }
        else
        {
            ArrayListAutomaton(this.parent).modCount += 1;

            action LIST_INSERT_AT(pStorage, i, e);

            ArrayListAutomaton(this.parent).length += 1;
        }

        this.cursor = i + 1;
        this.lastRet = -1;
        this.expectedModCount = ArrayListAutomaton(this.parent).modCount;
    }


    fun *.forEachRemaining (@target self: ArrayList_ListIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.parent != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        val size: int = ArrayListAutomaton(this.parent).length;

        if (i < size)
        {
            val es: list<Object> = ArrayListAutomaton(this.parent).storage;

            if (i >= action LIST_SIZE(es))
                _throwCME();

            // using this exact loop form here due to coplex termination expression
            action LOOP_WHILE(
                i < size && ArrayListAutomaton(this.parent).modCount == this.expectedModCount,
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
