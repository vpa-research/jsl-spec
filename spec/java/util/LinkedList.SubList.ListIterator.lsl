//#! pragma: target=java
libsl "1.1.0";

library std
    version "11"
    language "Java"
    url "https://github.com/openjdk/jdk11/blob/master/src/java.base/share/classes/java/util/LinkedList.java";

// imports

import java/util/LinkedList;


// automata

automaton LinkedList_SubList_ListIteratorAutomaton
(
    var root: LinkedList,
    var sublist: LinkedList_SubList,
    var cursor: int,
    var expectedModCount: int,
    var offset: int,
    var size: int,
)
: LinkedList_SubList_ListIterator
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
        val modCount: int = LinkedListAutomaton(this.root).modCount;
        if (modCount != this.expectedModCount)
            _throwCME();
    }


    // methods

    fun *.hasPrevious (@target self: LinkedList_SubList_ListIterator): boolean
    {
        result = this.cursor != 0;
    }


    fun *.nextIndex (@target self: LinkedList_SubList_ListIterator): int
    {
        result = this.cursor;
    }


    fun *.previousIndex (@target self: LinkedList_SubList_ListIterator): int
    {
        result = this.cursor - 1;
    }


    fun *.hasNext (@target self: LinkedList_SubList_ListIterator): boolean
    {
        result = this.cursor != this.size;
    }


    fun *.next (@target self: LinkedList_SubList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.root != null);

        _checkForComodification();

        val rootStorage: list<Object> = LinkedListAutomaton(this.root).storage;
        val i: int = this.offset + this.cursor;
        // iterrator validity check
        if (i >= action LIST_SIZE(rootStorage))
            action THROW_NEW("java.util.NoSuchElementException", []);

        this.lastRet = this.cursor;
        this.cursor += 1;

        result = action LIST_GET(rootStorage, i);
    }


    fun *.previous (@target self: LinkedList_SubList_ListIterator): Object
    {
        // relax state/error discovery process
        action ASSUME(this.root != null);

        _checkForComodification();

        val i: int = this.offset + this.cursor - 1;
        if (i < this.offset)
            action THROW_NEW("java.util.NoSuchElementException", []);

        // iterrator validity check
        val rootStorage: list<Object> = LinkedListAutomaton(this.root).storage;
        if (i >= action LIST_SIZE(rootStorage))
            _throwCME();

        this.cursor -= 1;
        this.lastRet = this.cursor;

        result = action LIST_GET(rootStorage, i);
    }


    fun *.remove (@target self: LinkedList_SubList_ListIterator): void
    {
        // relax state/error discovery process
        action ASSUME(this.root != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        if (this.lastRet >= this.size)
        {
            _throwCME();
        }
        else
        {
            LinkedListAutomaton(this.root)._unlinkAny(this.offset + this.lastRet);

            LinkedList_SubListAutomaton(this.sublist)._updateSizeAndModCount(-1);
            this.expectedModCount = LinkedListAutomaton(this.root).modCount;
            this.size -= 1;
        }

        this.cursor = this.lastRet;
        this.lastRet = -1;
    }


    fun *.set (@target self: LinkedList_SubList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.root != null);

        if (this.lastRet < 0)
            action THROW_NEW("java.lang.IllegalStateException", []);

        _checkForComodification();

        val rootStorage: list<Object> = LinkedListAutomaton(this.root).storage;

        val index: int = this.offset + this.lastRet;
        if (index >= action LIST_SIZE(rootStorage))
            _throwCME();
        else
            action LIST_SET(rootStorage, index, e);
    }


    fun *.add (@target self: LinkedList_SubList_ListIterator, e: Object): void
    {
        // relax state/error discovery process
        action ASSUME(this.root != null);

        _checkForComodification();

        val i: int = this.offset + this.cursor;

        if (this.offset + this.lastRet > action LIST_SIZE(LinkedListAutomaton(this.root).storage))
        {
            _throwCME();
        }
        else
        {
            LinkedListAutomaton(this.root)._linkAny(i, e);

            LinkedList_SubListAutomaton(this.sublist)._updateSizeAndModCount(+1);
            this.expectedModCount = LinkedListAutomaton(this.root).modCount;
            this.size += 1;
        }

        this.cursor += 1;
        this.lastRet = -1;
    }


    fun *.forEachRemaining (@target self: LinkedList_SubList_ListIterator, userAction: Consumer): void
    {
        // relax state/error discovery process
        action ASSUME(this.root != null);

        if (userAction == null)
            action THROW_NEW("java.lang.NullPointerException", []);

        var i: int = this.cursor;
        if (i < this.size)
        {
            i += this.offset;
            val es: list<Object> = LinkedListAutomaton(this.root).storage;

            if (i >= action LIST_SIZE(es))
                _throwCME();

            val end: int = this.offset + this.size;

            action LOOP_FOR(
                i, i, end, +1,
                forEachRemaining_loop(userAction, es, i)
            );

            // JDK NOTE: "update once at end to reduce heap write traffic"
            this.cursor = i - this.offset;
            this.lastRet = this.cursor - 1;
            _checkForComodification();
        }
    }

    @Phantom proc forEachRemaining_loop (userAction: Consumer, es: list<Object>, i: int): void
    {
        val item: Object = action LIST_GET(es, i);
        action CALL(userAction, [item]);
    }

}
