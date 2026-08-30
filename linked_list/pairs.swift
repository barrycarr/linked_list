//
//  pairs.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

/// A function that maps one value into a pair of values.
public typealias ListSplitMap<T, U, V> = (T) -> (U, V)

/// Splits a list of pairs into a pair of lists.
///
/// - Parameter list: The list of pairs to split.
/// - Returns: A tuple containing a list of first components and a list of
///   second components, both in their original order.
public func split<T, U>(_ list: LinkedList<(T, U)>) -> (LinkedList<T>, LinkedList<U>) {
    func doSplit(_ list: LinkedList<(T, U)>, _ t: LinkedList<T>, _ u: LinkedList<U>) -> (LinkedList<T>, LinkedList<U>) {
        switch list {
        case .empty: return (reverse(t), reverse(u))
        case .cons(let val, let rest):
            return doSplit(rest, val.0 +| t, val.1 +| u)
        }
    }

    return doSplit(list, LinkedList<T>.empty, LinkedList<U>.empty)
}

/// Maps each value into a pair, then splits the mapped pairs into two lists.
///
/// - Parameters:
///   - fn: The function used to map each value into a pair.
///   - list: The list to map and split.
/// - Returns: A tuple containing the mapped first components and mapped second
///   components, both in their original order.
public func splitMap<T, U, V>(_ fn: ListSplitMap<T, U, V>, _ list: LinkedList<T>) -> (LinkedList<U>, LinkedList<V>) {
    func doSplitMap(_ list: LinkedList<T>, _ u: LinkedList<U>, _ v: LinkedList<V>) -> (LinkedList<U>, LinkedList<V>) {
        switch list {
        case .empty: return (reverse(u), reverse(v))
        case .cons(let val, let rest):
            let (u1, v1) = fn(val)
            return doSplitMap(rest, u1 +| u, v1 +| v)
        }
    }

    return doSplitMap(list, LinkedList<U>.empty, LinkedList<V>.empty)
}

/// Creates a pipe-forward helper for `splitMap`.
///
/// - Parameter fn: The function used to map each value into a pair.
/// - Returns: A function that split-maps its input list.
public func splitMapOf<T, U, V>(_ fn: @escaping ListSplitMap<T, U, V>) -> (LinkedList<T>) -> (
    LinkedList<U>, LinkedList<V>
) {
    { list in splitMap(fn, list) }
}

/// Combines two lists into a list of pairs.
///
/// Values are paired by position. The operation fails when the input lists have
/// different lengths.
///
/// - Parameters:
///   - t: The first list.
///   - u: The second list.
/// - Returns: `.success(list)` containing paired values when both lists have the
///   same length, `.failure(.list1TooShort)` when `t` ends first, or
///   `.failure(.list2TooShort)` when `u` ends first.
public func combine<T, U>(_ t: LinkedList<T>, _ u: LinkedList<U>) -> Result<LinkedList<(T, U)>, LinkedListError> {
    func doCombine(
        _ t: LinkedList<T>,
        _ u: LinkedList<U>,
        _ res: LinkedList<(T, U)>
    ) -> Result<LinkedList<(T, U)>, LinkedListError> {
        switch (t, u) {
        case (.empty, .empty): return .success(reverse(res))
        case (.empty, .cons): return .failure(.list1TooShort)
        case (.cons, .empty): return .failure(.list2TooShort)
        case (.cons(let tVal, let tRest), .cons(let uVal, let uRest)):
            let newVal = (tVal, uVal)
            return doCombine(tRest, uRest, newVal +| res)
        }
    }

    return doCombine(t, u, .empty)
}
