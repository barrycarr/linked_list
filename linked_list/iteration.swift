//
//  iteration.swift
//  linked_list
//
//  Created by Barry Carr on 20/08/2026.
//

/// A function that transforms one list value into another value.
public typealias LinkedListMap<T, U> = (T) -> U

/// A function that transforms an index and list value into another value.
public typealias ListMapWithIndex<T, U> = (Int, T) -> U

/// A function that optionally transforms a list value.
///
/// Returning `nil` drops the value from the output list.
public typealias ListFilter<T, U> = (T) -> U?

/// A function that optionally transforms an index and list value.
///
/// Returning `nil` drops the value from the output list.
public typealias ListFilterIndex<T, U> = (Int, T) -> U?

/// A function that transforms one list value into a list of values.
public typealias ListConcatMap<T, U> = (T) -> LinkedList<U>

/// A left-fold function.
///
/// The first argument is the current accumulator and the second argument is the
/// current list value.
public typealias ListFoldLeft<A, T> = (A, T) -> A

/// A left-fold function that also maps each list value.
///
/// The returned tuple contains the next accumulator and the mapped value to add
/// to the output list.
public typealias ListFoldLeftMap<A, T, U> = (A, T) -> (A, U)

/// A right-fold function.
///
/// The first argument is the current list value and the second argument is the
/// folded result of the remaining list.
public typealias ListFoldRight<T, A> = (T, A) -> A

/// Calls a function for each value in a list, from left to right.
///
/// Use this for side effects such as logging or appending to external state.
///
/// - Parameters:
///   - fn: The function to call for each value.
///   - list: The list to iterate over.
public func iter<T>(_ fn: ListIter<T>, _ list: LinkedList<T>) {
    switch list {
    case .empty: return
    case .cons(let value, let rest):
        fn(value)
        iter(fn, rest)
    }
}

/// Creates a pipe-forward helper for `iter`.
///
/// - Parameter fn: The function to call for each value.
/// - Returns: A function that iterates over its input list.
public func iterOf<T>(_ fn: @escaping ListIter<T>) -> (LinkedList<T>) -> Void {
    { list in iter(fn, list) }
}

/// Calls a function for each index and value in a list, from left to right.
///
/// Indexing starts at `0`.
///
/// - Parameters:
///   - fn: The function to call with each index and value.
///   - list: The list to iterate over.
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

/// Creates a pipe-forward helper for `iterI`.
///
/// - Parameter fn: The function to call with each index and value.
/// - Returns: A function that iterates over its input list.
public func iterIOf<T>(_ fn: @escaping ListIterIndex<T>) -> (LinkedList<T>) -> Void {
    { list in iterI(fn, list) }
}

/// Transforms each value in a list.
///
/// - Parameters:
///   - fn: The function used to transform each value.
///   - list: The list to map over.
/// - Returns: A new list containing each transformed value in order.
public func map<T, U>(_ fn: LinkedListMap<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    switch list {
    case .empty: return .empty
    case .cons(let value, let rest):
        return .cons(fn(value), map(fn, rest))
    }
}

/// Creates a pipe-forward helper for `map`.
///
/// - Parameter fn: The function used to transform each value.
/// - Returns: A function that maps over its input list.
public func mapOf<T, U>(_ fn: @escaping LinkedListMap<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in map(fn, list) }
}

/// Transforms each index and value in a list.
///
/// Indexing starts at `0`.
///
/// - Parameters:
///   - fn: The function used to transform each index and value.
///   - list: The list to map over.
/// - Returns: A new list containing each transformed value in order.
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

/// Creates a pipe-forward helper for `mapI`.
///
/// - Parameter fn: The function used to transform each index and value.
/// - Returns: A function that maps over its input list.
public func mapIOf<T, U>(_ fn: @escaping ListMapWithIndex<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in mapI(fn, list) }
}

/// Transforms each value in a list and returns the results in reverse order.
///
/// - Parameters:
///   - fn: The function used to transform each value.
///   - list: The list to map over.
/// - Returns: A new list containing each transformed value in reverse order.
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

/// Creates a pipe-forward helper for `reverseMap`.
///
/// - Parameter fn: The function used to transform each value.
/// - Returns: A function that reverse-maps over its input list.
public func reverseMapOf<T, U>(_ fn: @escaping LinkedListMap<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in reverseMap(fn, list) }
}

/// Transforms and filters a list in one pass.
///
/// Values for which `fn` returns `nil` are not included in the result.
///
/// - Parameters:
///   - fn: The function used to optionally transform each value.
///   - list: The list to filter and map.
/// - Returns: A new list containing each non-`nil` transformed value in order.
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

/// Creates a pipe-forward helper for `filterMap`.
///
/// - Parameter fn: The function used to optionally transform each value.
/// - Returns: A function that filter-maps over its input list.
public func filterMapOf<T, U>(_ fn: @escaping ListFilter<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in filterMap(fn, list) }
}

/// Transforms and filters each index and value in a list.
///
/// Indexing starts at `0`. Values for which `fn` returns `nil` are not included
/// in the result.
///
/// - Parameters:
///   - fn: The function used to optionally transform each index and value.
///   - list: The list to filter and map.
/// - Returns: A new list containing each non-`nil` transformed value in order.
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

/// Creates a pipe-forward helper for `filterMapI`.
///
/// - Parameter fn: The function used to optionally transform each index and value.
/// - Returns: A function that indexed filter-maps over its input list.
public func filterMapIOf<T, U>(_ fn: @escaping ListFilterIndex<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in filterMapI(fn, list) }
}

/// Maps each value to a list and concatenates the results.
///
/// - Parameters:
///   - fn: The function used to transform each value into a list.
///   - list: The list to map over.
/// - Returns: A list containing the concatenated mapped lists in order.
public func concatMap<T, U>(_ fn: ListConcatMap<T, U>, _ list: LinkedList<T>) -> LinkedList<U> {
    switch list {
    case .empty: return .empty
    case .cons(let value, let rest):
        return append(fn(value), concatMap(fn, rest))
    }
}

/// Creates a pipe-forward helper for `concatMap`.
///
/// - Parameter fn: The function used to transform each value into a list.
/// - Returns: A function that concat-maps over its input list.
public func concatMapOf<T, U>(_ fn: @escaping ListConcatMap<T, U>) -> (LinkedList<T>) -> LinkedList<U> {
    { list in concatMap(fn, list) }
}

/// Folds a list from left to right.
///
/// - Parameters:
///   - fn: The function used to combine the accumulator and each value.
///   - acc: The initial accumulator.
///   - list: The list to fold.
/// - Returns: The final accumulator.
public func foldLeft<A, T>(_ fn: ListFoldLeft<A, T>, _ acc: A, _ list: LinkedList<T>) -> A {
    switch list {
    case .empty: return acc
    case .cons(let value, let rest):
        let newAcc = fn(acc, value)
        return foldLeft(fn, newAcc, rest)
    }
}

/// Creates a pipe-forward helper for `foldLeft`.
///
/// - Parameters:
///   - fn: The function used to combine the accumulator and each value.
///   - acc: The initial accumulator.
/// - Returns: A function that folds its input list from left to right.
public func foldLeftOf<A, T>(_ fn: @escaping ListFoldLeft<A, T>, _ acc: A) -> (LinkedList<T>) -> A {
    { list in foldLeft(fn, acc, list) }
}

/// Folds a list from left to right while mapping each value.
///
/// This is useful when mapping depends on state that is threaded through the
/// traversal.
///
/// - Parameters:
///   - fn: The function that returns the next accumulator and mapped value.
///   - acc: The initial accumulator.
///   - list: The list to fold and map.
/// - Returns: A tuple containing the final accumulator and the mapped list.
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

/// Creates a pipe-forward helper for `foldLeftMap`.
///
/// - Parameters:
///   - fn: The function that returns the next accumulator and mapped value.
///   - acc: The initial accumulator.
/// - Returns: A function that folds and maps its input list from left to right.
public func foldLeftMapOf<A, T, U>(_ fn: @escaping ListFoldLeftMap<A, T, U>, _ acc: A) -> (LinkedList<T>) -> (
    A, LinkedList<U>
) {
    { list in foldLeftMap(fn, acc, list) }
}

/// Folds a list from right to left.
///
/// This function is not tail-recursive.
///
/// - Parameters:
///   - fn: The function used to combine each value with the folded rest of the list.
///   - list: The list to fold.
///   - acc: The initial accumulator used at the end of the list.
/// - Returns: The final accumulator.
public func foldRight<A, T>(_ fn: ListFoldRight<T, A>, _ list: LinkedList<T>, _ acc: A) -> A {
    switch list {
    case .empty: acc
    case .cons(let value, let rest): fn(value, foldRight(fn, rest, acc))
    }
}

/// Creates a pipe-forward helper for `foldRight`.
///
/// - Parameters:
///   - fn: The function used to combine each value with the folded rest of the list.
///   - acc: The initial accumulator used at the end of the list.
/// - Returns: A function that folds its input list from right to left.
public func foldRightOf<A, T>(_ fn: @escaping ListFoldRight<T, A>, _ acc: A) -> (LinkedList<T>) -> A {
    { list in foldRight(fn, list, acc) }
}
