libsl "1.1.0";

library "std:???"
    version "11"
    language "Java"
    url "-";

// imports

import "java-common.lsl";
import "java/util/HashMap.lsl";

import "list-actions.lsl";


// local semantic types

@TypeMapping(typeVariable=true) typealias K = Object;

@For(automaton="KeyIteratorAutomaton", insteadOf="java.util.HashMap$KeyIterator")
@extends("java.util.HashMap<K, V>$HashIterator")
@implements(["java.util.Iterator<K>"])
@public @final type KeyIterator
{
}


// automata

@public automaton KeyIteratorAutomaton: KeyIterator
(
    var index: int = 0;
    var expectedModCount: int;
    var nextWasCalled: boolean = false;
    val hashMap: map;
    var size;
)
{
    // states and shifts

    initstate Initialized;

    shift Initialized -> this by [
        // read operations
        hasNext,

        // write operations
        next,
        remove,
    ];

    // constructors

    constructor `KeyIterator#KeyIterator` (@target obj: KeyIterator, arg0: HashMap)
    {
        action TODO();
    }


    // utilities

    // static methods

    // methods

    fun hasNext (@target obj: KeyIterator): boolean
    {
        result = this.index < this.size;
    }

    @final fun next (@target obj: KeyIterator): K
    {
        // Problem - change modCount.
        // Before was such: this.parent._checkForModifications(this.expectedModCount).
        // Now we don't have parent.
        // https://docs.google.com/document/d/17fQBVGENeliEInbk80q9V6wO_lTYv-7MjVCuZFaswEM/edit

        val atValidPosition: boolean = this.index < this.size;
        if (!atValidPosition)
        {
            action THROW_NEW("java.util.NoSuchElementException", []);
        }

        val key = engine.makeSymbolic(K);
        val hasKey = action MAP_HAS_KEY(this.hashMap, key);
        result = key;
        // Assume must be always on the bottom of the method body or not ?
        assume(hasKey);

        this.index += 1;
        this.nextWasCalled = true;
    }

    fun remove (): void
    {
        val atValidPosition: boolean = this.index < this.size;
        if (!atValidPosition || !this.nextWasCalled)
        {
            action THROW_NEW("java.lang.IllegalStateException", []);
        }
        this.nextWasCalled = false;

        // Problem - change modCount.
        // Before was such: this.parent._checkForModifications(this.expectedModCount).

        val key = engine.makeSymbolic(K);
        val hasKey = action MAP_HAS_KEY(this.hashMap, key);
        assume(hasKey);
        action MAP_REMOVE(this.hashMap, key);

        // Problem - change modCount.
        // Before was such: this.expectedModCount = this.parent.modCounter.
    }

}