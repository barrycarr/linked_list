//
//  iteration.swift
//  linked_list
//
//  Created by Barry Carr on 20/08/2026.
//

public typealias LinkedListMap<T, U> = (T) -> U
public typealias ListMapWithIndex<T, U> = (Int, T) -> U
public typealias ListFilter<T, U> = (T) -> U?
public typealias ListFilterIndex<T, U> = (Int, T) -> U?
public typealias ListConcatMap<T, U> = (T) -> LinkedList<U>
public typealias ListFoldLeft<A, T> = (A, T) -> A
public typealias ListFoldLeftMap<A, T, U> = (A, T) -> (A, U)
public typealias ListFoldRight<T, A> = (T, A) -> A

public func iter<T>(_ fn: ListIter<T>, _ list: LinkedList<T>) {
    switch list {
    case .empty: return
    case .cons(let value, let rest):
        fn(value)
        iter(fn, rest)
    }
}

// for use with pipe-forward operator `|>`
public func iterOf<T>(_ fn: @escaping ListIter<T>) -> (LinkedList<T>) -> Void {
    { list in iter(fn, list) }
}

public func iterI<T>(_ fn: ListIterIndex<T>, _ list: LinkedList<T>) {
    func doIter(_ idx: Int, _ fn: ListIterIndex<T>, _ list: LinkedList<T>) {
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
public func iterIOf<T>(_ fn: @escaping ListIterIndex<T>) -> (LinkedList<T>) -> Void {
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

public func mapI<T, U>(_ fn: ListMapWithIndex<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    func doMap(_ idx: Int, _ fn: ListMapWithIndex<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
        switch list {
        case .empty: return .empty
        case .cons(let value, let rest):
            return .cons(fn(idx, value), doMap(idx + 1, fn, rest))
        }
    }

    return doMap(0, fn, list)
}

// for use with the pipe-forward operator `|>`
public func mapIOf<T, U>(_ fn: @escaping ListMapWithIndex<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in mapI(fn, list) }
}

public func reverseMap<T, U>(_ fn: LinkedListMap<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    func reversed(_ remaining: LinkedList<T>, into result: LinkedList<U>) -> LinkedList<U> {
        switch remaining {
        case .empty:
            return result
        case .cons(let value, let rest):
            return reversed(rest, into: .cons(fn(value), result))
        }
    }

    return reversed(list, into: .empty)
}

// for use with the pipe-forward operator `|>`
public func reverseMapOf<T, U>(_ fn: @escaping LinkedListMap<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in reverseMap(fn, list) }
}

public func filterMap<T, U>(_ fn: ListFilter<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    switch list {
    case .empty: return .empty
    case .cons(let value, let rest):
        if let r = fn(value) {
            return .cons(r, filterMap(fn, rest))
        } else {
            return filterMap(fn, rest)
        }
    }
}

// for use with the pipe-forward operator `|>`
public func filterMapOf<T, U>(_ fn: @escaping ListFilter<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in filterMap(fn, list) }
}

public func filterMapI<T, U>(_ fn: ListFilterIndex<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    func doFilter(_ idx: Int,_ list: LinkedList<T>) -> LinkedList<U> {
        switch list {
        case .empty: return .empty
        case .cons(let value, let rest):
            if let r = fn(idx, value) {
                return .cons(r, doFilter(idx + 1, rest))
            } else {
                return doFilter(idx + 1, rest)
            }
        }
    }

    return doFilter(0, list)
}

// for use with pipe-forward operator `|>`
public func filterMapIOf<T, U>(_ fn: @escaping ListFilterIndex<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in filterMapI(fn, list) }
}

public func concatMap<T, U>(_ fn: ListConcatMap<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    switch list {
    case .empty: return .empty
    case .cons(let value, let rest):
        return append(l0: fn(value), l1: concatMap(fn, rest))
    }
}

// for use with pipe-forward operator `|>`
public func concatMapOf<T, U>(_ fn: @escaping ListConcatMap<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in concatMap(fn, list) }
}

public func foldLeft<A, T>(_ fn: ListFoldLeft<A, T>, _ acc: A, _ list: LinkedList<T>) -> A {
    switch list {
    case .empty: return acc
    case .cons(let value, let rest):
        let newAcc = fn(acc, value)
        return foldLeft(fn, newAcc, rest)
    }
}

public func foldLeftOf<A, T>(_ fn: @escaping ListFoldLeft<A, T>, _ acc: A) -> (LinkedList<T>) -> A {
    { list in foldLeft(fn, acc, list) }
}

public func foldLeftMap<A, T, U>(
    _ fn: ListFoldLeftMap<A, T, U>,
    _ acc: A,
    _ list: LinkedList<T>
) -> (A, LinkedList<U>) {
    func doFoldLM(
        _ acc: A,
        _ list: LinkedList<T>,
        _ newList: LinkedList<U>
    ) -> (A, LinkedList<U>) {
        switch list {
        case .empty: return (acc, reverse(newList))
        case .cons(let value, let rest):
            let (newAcc, newValue) = fn(acc, value)
            return doFoldLM(newAcc, rest, newValue +| newList)
        }
    }

    return doFoldLM(acc, list, LinkedList<U>.empty)
}

public func foldLeftMapOf<A, T, U>(_ fn: @escaping ListFoldLeftMap<A, T, U>, _ acc: A) -> (LinkedList<T>) -> (
    A, LinkedList<U>
) {
    { list in foldLeftMap(fn, acc, list) }
}

// NOT tail Recursive
public func foldRight<A, T>(_ fn: ListFoldRight<T, A>, _ list: LinkedList<T>, _ acc: A) -> A {
    switch list {
    case .empty: acc
    case .cons(let value, let rest): fn(value, foldRight(fn, rest, acc))
    }
}

public func foldRightOf<A, T>(_ fn: @escaping ListFoldRight<T, A>, _ acc: A) -> (LinkedList<T>) -> A {
    { list in foldRight(fn, list, acc) }
}
