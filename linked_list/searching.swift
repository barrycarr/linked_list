//
//  searching.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//

public typealias ListFindMap<T, U> = (T) -> U?
public typealias ListFindMapI<T, U> = (Int, T) -> U?
public typealias ListPredicateI<T> = (Int, T) -> Bool

public func find<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> Result<T, LinkedListError> {
    if let result = findOpt(fn, list) {
        return .success(result)
    }
    return .failure(.notFound)
}

public func findOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Result<T, LinkedListError> {
    { list in
        find(fn, list)
    }
}

public func findOpt<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> T? {
    switch list {
        case .empty: return nil
        case .cons(let val, let rest):
            if fn(val) { return val }
            return findOpt(fn, rest)
    }
}

public func findOptOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> T? {
    { list in
        findOpt(fn, list)
    }
}

public func findIndex<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> Int? {
    func doFindIndex(_ list: LinkedList<T>, _ index: Int) -> Int? {
        switch list {
            case .empty: return nil
            case .cons(let val, let rest):
                if fn(val) { return index }
                return doFindIndex(rest, index + 1)
        }
    }
    return doFindIndex(list, 0)
}

public func findIndexOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Int? {
    { list in
        findIndex(fn, list) 
    }
}

public func findMap<T, U>(_ fn: ListFindMap<T,U>, _ list: LinkedList<T>) -> U? {
    switch list {
        case .empty: return nil
        case .cons(let val, let rest):
            if let result = fn(val) { return result }
            return findMap(fn, rest)
    }
}

public func findMapOf<T, U>(_ fn: @escaping ListFindMap<T,U>) -> (LinkedList<T>) -> U? {
    { list in
        findMap(fn, list)
    }
}

public func findMapI<T, U>(_ fn: ListFindMapI<T, U>, _ list: LinkedList<T>) -> U? {
    func doFindMapI(_ list: LinkedList<T>, _ idx: Int) -> U? {
        switch list {
            case .empty: return nil
            case .cons(let val, let rest):
                if let result = fn(idx, val) {return result}
                return doFindMapI(rest, idx + 1)
        }
    }
    
    return doFindMapI(list, 0)
}

public func findMapIOf<T, U>(_ fn: @escaping ListFindMapI<T, U>) -> (LinkedList<T>) -> U? {
    { list in
        findMapI(fn, list)
    }
}

public func filter<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    func doFilter(_ list: LinkedList<T>, _ res: LinkedList<T>) -> LinkedList<T> {
        switch list {
            case .empty: return reverse(res)
            case .cons(let val, let rest):
                if fn(val) {
                    return doFilter(rest, val +| res)
                }
                return doFilter(rest, res)
        }
    }
    
    return doFilter(list, LinkedList<T>.empty)
}

public func filterOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in
        filter(fn, list)
    }
}

public func findAll<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    filter(fn, list)
}

public func findAllOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in
        findAll(fn, list)
    }
}

public func filterI<T>(_ fn: ListPredicateI<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    func doFilterI(_ list: LinkedList<T>, _ res: LinkedList<T>, _ idx: Int) -> LinkedList<T> {
        switch list {
            case .empty: return reverse(res)
            case .cons(let val, let rest):
                if fn(idx, val) {
                    return doFilterI(rest, val +| res, idx + 1)
                }
                return doFilterI(rest, res, idx + 1)
        }
    }
    
    return doFilterI(list, LinkedList<T>.empty, 0)
}

public func filterIOf<T>(_ fn: @escaping ListPredicateI<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in
        filterI(fn, list)
    }
}
