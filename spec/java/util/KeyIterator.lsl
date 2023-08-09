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
    @static @final var mockedValue: Object = Object;
}


// automata

@public automaton KeyIteratorAutomaton: KeyIterator
(
    var index: int = 0;
    var destMap: map = null;
    var nextWasCalled: boolean = false;
    var expectedModCount: int;
    val sourceMap: map;
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

    constructor KeyIterator (@target obj: KeyIterator, arg0: HashMap)
    {
        this.destMap = action MAP_NEW();
        // Problem - what else we must to do in this constructor ???
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
        val sourceMapHasKey = action MAP_HAS_KEY(this.sourceMap, key);
        result = key;
        // Assume must be always on the bottom of the method body or not ?
        assume(sourceMapHasKey);
        val destMapHasKey = action MAP_HAS_KEY(this.destMap, key);
        assume(!destMapHasKey);

        action MAP_SET(this.destMap, key, mockedValue);
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
        val hasKey = action MAP_HAS_KEY(this.sourceMap, key);
        assume(hasKey);
        action MAP_REMOVE(this.sourceMap, key);

        // Problem - change modCount.
        // Before was such: this.expectedModCount = this.parent.modCounter.
    }

}