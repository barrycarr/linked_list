//
//  searching.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//

/// A function that optionally maps a value while searching.
///
/// Returning a non-`nil` value stops the search.
public typealias ListFindMap<T, U> = (T) -> U?

/// A function that optionally maps an index and value while searching.
///
/// Returning a non-`nil` value stops the search.
public typealias ListFindMapI<T, U> = (Int, T) -> U?

/// A predicate that tests an index and value.
public typealias ListPredicateI<T> = (Int, T) -> Bool

/// Finds the first value in a list that satisfies a predicate.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to search.
/// - Returns: `.success(value)` for the first matching value, or
///   `.failure(.notFound)` when no value matches.
public func find<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> Result<T, LinkedListError> {
    if let result = findOpt(fn, list) {
        return .success(result)
    }
    return .failure(.notFound)
}

/// Creates a pipe-forward helper for `find`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that finds the first matching value in its input list.
public func findOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Result<T, LinkedListError> {
    { list in
        find(fn, list)
    }
}

/// Finds the first value in a list that satisfies a predicate.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to search.
/// - Returns: The first matching value, or `nil` when no value matches.
public func findOpt<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> T? {
    switch list {
    case .empty: return nil
    case .cons(let val, let rest):
        if fn(val) { return val }
        return findOpt(fn, rest)
    }
}

/// Creates a pipe-forward helper for `findOpt`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that finds the first matching optional value in its
///   input list.
public func findOptOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> T? {
    { list in
        findOpt(fn, list)
    }
}

/// Finds the index of the first value in a list that satisfies a predicate.
///
/// Indexing starts at `0`.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to search.
/// - Returns: The zero-based index of the first matching value, or `nil` when
///   no value matches.
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

/// Creates a pipe-forward helper for `findIndex`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that finds the index of the first matching value in its
///   input list.
public func findIndexOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Int? {
    { list in
        findIndex(fn, list)
    }
}

/// Maps values while searching and returns the first mapped result.
///
/// The search stops at the first value for which `fn` returns a non-`nil`
/// result.
///
/// - Parameters:
///   - fn: The function used to optionally map each value.
///   - list: The list to search.
/// - Returns: The first non-`nil` mapped value, or `nil` when no value produces
///   one.
public func findMap<T, U>(_ fn: ListFindMap<T, U>, _ list: LinkedList<T>) -> U? {
    switch list {
    case .empty: return nil
    case .cons(let val, let rest):
        if let result = fn(val) { return result }
        return findMap(fn, rest)
    }
}

/// Creates a pipe-forward helper for `findMap`.
///
/// - Parameter fn: The function used to optionally map each value.
/// - Returns: A function that returns the first non-`nil` mapped value from its
///   input list.
public func findMapOf<T, U>(_ fn: @escaping ListFindMap<T, U>) -> (LinkedList<T>) -> U? {
    { list in
        findMap(fn, list)
    }
}

/// Maps indexes and values while searching and returns the first mapped result.
///
/// Indexing starts at `0`. The search stops at the first index and value for
/// which `fn` returns a non-`nil` result.
///
/// - Parameters:
///   - fn: The function used to optionally map each index and value.
///   - list: The list to search.
/// - Returns: The first non-`nil` mapped value, or `nil` when no index and value
///   produces one.
public func findMapI<T, U>(_ fn: ListFindMapI<T, U>, _ list: LinkedList<T>) -> U? {
    func doFindMapI(_ list: LinkedList<T>, _ idx: Int) -> U? {
        switch list {
        case .empty: return nil
        case .cons(let val, let rest):
            if let result = fn(idx, val) { return result }
            return doFindMapI(rest, idx + 1)
        }
    }

    return doFindMapI(list, 0)
}

/// Creates a pipe-forward helper for `findMapI`.
///
/// - Parameter fn: The function used to optionally map each index and value.
/// - Returns: A function that returns the first non-`nil` mapped value from its
///   input list.
public func findMapIOf<T, U>(_ fn: @escaping ListFindMapI<T, U>) -> (LinkedList<T>) -> U? {
    { list in
        findMapI(fn, list)
    }
}

/// Keeps values that satisfy a predicate.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to filter.
/// - Returns: A new list containing the values that satisfy `fn`, in their
///   original order.
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

/// Creates a pipe-forward helper for `filter`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that filters its input list.
public func filterOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in
        filter(fn, list)
    }
}

/// Keeps all values that satisfy a predicate.
///
/// `findAll` is an alias for `filter`.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to filter.
/// - Returns: A new list containing the values that satisfy `fn`, in their
///   original order.
public func findAll<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    filter(fn, list)
}

/// Creates a pipe-forward helper for `findAll`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that keeps all matching values from its input list.
public func findAllOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in
        findAll(fn, list)
    }
}

/// Keeps indexes and values that satisfy a predicate.
///
/// Indexing starts at `0`.
///
/// - Parameters:
///   - fn: The predicate used to test each index and value.
///   - list: The list to filter.
/// - Returns: A new list containing the values whose index and value satisfy
///   `fn`, in their original order.
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

/// Creates a pipe-forward helper for `filterI`.
///
/// - Parameter fn: The predicate used to test each index and value.
/// - Returns: A function that filters its input list using indexes and values.
public func filterIOf<T>(_ fn: @escaping ListPredicateI<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in
        filterI(fn, list)
    }
}
