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

// for use with pipe operator `|>`
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

// for use with pip operator `|>`
public func iterIOf<T>(_ fn: @escaping LinkedListIterationWithIndex<T>) -> (LinkedList<T>) -> Void {
    { list in iterI(fn, list) }
}
