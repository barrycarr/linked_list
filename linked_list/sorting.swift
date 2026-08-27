//
//  sorting.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

public typealias ListSort<T> = (T, T) -> Int

// assumes lists are already sorted
public func merge<T>(_ cmp: ListSort<T>, _ lhs: LinkedList<T>, _ rhs: LinkedList<T>) -> LinkedList<T> {
    func doMerge(_ lhs: LinkedList<T>, _ rhs: LinkedList<T>, _ res: LinkedList<T>) -> LinkedList<T> {
        switch (lhs, rhs) {
            case (.empty, .empty): return res
            case (.empty, .cons): return revAppend(l0: res, l1: rhs)
            case (.cons, .empty): return revAppend(l0: res, l1: lhs)
            case (.cons(let lVal, let lRest), .cons(let rVal, let rRest)):
                if cmp(lVal, rVal) <= 0 {
                    return doMerge(lRest, rhs, lVal +| res )
                }
                return doMerge(lhs, rRest, rVal +| res)
        }
    }
    
    return doMerge(lhs, rhs, .empty)
}

public func mergeOf<T>(
    _ cmp: @escaping ListSort<T>,
    _ lhs: LinkedList<T>
) -> (LinkedList<T>) -> LinkedList<T> {
    { rhs in merge(cmp, lhs, rhs) }
}

internal func halve<T>(_ list: LinkedList<T>) -> (LinkedList<T>, LinkedList<T>) {
    func doHalve(
        _ slow: LinkedList<T>,
        _ fast: LinkedList<T>,
        _ left: LinkedList<T>,
    ) -> (LinkedList<T>, LinkedList<T>) {
        switch (slow, fast) {
            case (.empty, _): return (reverse(left), .empty)
            case (_, .empty): return (reverse(left), slow)
            case (_, .cons(_, .empty)): return (reverse(left), slow)
            case (.cons(let val, let slowRest), .cons(_, .cons(_, let fastRest))):
                return doHalve(slowRest, fastRest, val +| left)
        }
    }
    
    switch list {
        case .empty: return (.empty, .empty)
        case .cons(_, .empty): return (list, .empty)
        case .cons: return doHalve(list, list, .empty)
    }
}

public func sort<T>(_ cmp: ListSort<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    switch list {
        case .empty: return .empty
        case .cons(_, .empty): return list
        case .cons:
            let (lhs, rhs) = halve(list)
            return merge(cmp, sort(cmp, lhs), sort(cmp, rhs))
    }
}

public func sortOf<T>(_ cmp: @escaping ListSort<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in sort(cmp, list) }
}

public func stableSort<T>(_ cmp: ListSort<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    sort(cmp, list)
}

public func stableSortOf<T>(_ cmp: @escaping ListSort<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in stableSort(cmp, list) }
}

public func fastSort<T>(_ cmp: ListSort<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    sort(cmp, list)
}

public func fastSortOf<T>(_ cmp: @escaping ListSort<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in fastSort(cmp, list) }
}
