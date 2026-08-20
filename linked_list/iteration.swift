//
//  iteration.swift
//  linked_list
//
//  Created by Barry Carr on 20/08/2026.
//
public func iter<T>(_ fn: LinkedListIteration<T>, _ list: LinkedList<T>) -> Void {
    switch list {
        case .empty: return
        case .cons(let value, let rest):
            fn(value)
            iter(fn, rest)
    }
}

// for use with pipe-forward operator `|>`
public func iterOf<T>(_ fn: @escaping LinkedListIteration<T>) -> (LinkedList<T>) -> Void {
    { list in iter(fn, list) }
}

public func iterI<T>(_ fn: LinkedListIterationWithIndex<T>, _ list: LinkedList<T>) -> Void {
    func doIter( _ idx: Int, _ fn: LinkedListIterationWithIndex<T>, _ list: LinkedList<T>) -> Void {
        switch list {
            case .empty: return
            case .cons(let value, let rest):
                fn(idx, value)
                doIter(idx + 1, fn, rest)
        }
    }
    
    doIter(0, fn, list)
}

// for use with pipe-forward operator `|>`
public func iterIOf<T>(_ fn: @escaping LinkedListIterationWithIndex<T>) -> (LinkedList<T>) -> Void {
    { list in iterI(fn, list) }
}

public func map<T, U>(_ fn: LinkedListMap<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    switch list {
        case .empty: return .empty
        case .cons(let value, let rest):
            return .cons(fn(value), map(fn, rest))
    }
}

// for use with the pipe-forward operator `|>`
public func mapOf<T, U>(_ fn: @escaping LinkedListMap<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in map(fn, list) }
}


public func mapI<T,U>(_ fn: LinkedListMapWithIndex<T,U>, _ list: LinkedList<T>) -> LinkedList<U> {
    func doMap( _ idx: Int, _ fn: LinkedListMapWithIndex<T,U>, _ list: LinkedList<T>) -> LinkedList<U> {
        switch list {
            case .empty: return .empty
            case .cons(let value, let rest):
                return .cons(fn(idx, value), doMap(idx + 1, fn, rest))
        }
    }
    
    return doMap(0, fn, list)
}

// for use with the pipe-forward operator `|>`
public func mapIOf<T,U>(_ fn: @escaping LinkedListMapWithIndex<T,U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in mapI(fn, list) }
}

