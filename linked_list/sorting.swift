//
//  sorting.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

/// A comparison function used to order list values.
///
/// Return a negative value when the first argument is smaller, `0` when the
/// arguments compare equal, and a positive value when the first argument is
/// greater.
public typealias ListSort<T> = (T, T) -> Int

/// Merges two sorted lists into a single sorted list.
///
/// Both input lists must already be sorted according to `cmp`. Equal values from
/// `lhs` are kept before equal values from `rhs`.
///
/// - Parameters:
///   - cmp: The comparison function used to order values.
///   - lhs: The first sorted list.
///   - rhs: The second sorted list.
/// - Returns: A sorted list containing all values from `lhs` and `rhs`.
public func merge<T>(_ cmp: ListSort<T>, _ lhs: LinkedList<T>, _ rhs: LinkedList<T>) -> LinkedList<T> {
    func doMerge(_ lhs: LinkedList<T>, _ rhs: LinkedList<T>, _ res: LinkedList<T>) -> LinkedList<T> {
        switch (lhs, rhs) {
        case (.empty, .empty): return res
        case (.empty, .cons): return revAppend(res, rhs)
        case (.cons, .empty): return revAppend(res, lhs)
        case (.cons(let lVal, let lRest), .cons(let rVal, let rRest)):
            if cmp(lVal, rVal) <= 0 {
                return doMerge(lRest, rhs, lVal +| res)
            }
            return doMerge(lhs, rRest, rVal +| res)
        }
    }

    return doMerge(lhs, rhs, .empty)
}

/// Creates a pipe-forward helper for `merge`.
///
/// - Parameters:
///   - cmp: The comparison function used to order values.
///   - lhs: The sorted list to merge with the piped list.
/// - Returns: A function that merges its input sorted list with `lhs`.
public func mergeOf<T>(
    _ cmp: @escaping ListSort<T>,
    _ lhs: LinkedList<T>
) -> (LinkedList<T>) -> LinkedList<T> {
    { rhs in merge(cmp, lhs, rhs) }
}

/// Splits a list into two contiguous halves.
///
/// This helper uses slow and fast traversal to avoid calculating the list length
/// first. Keeping the split contiguous preserves stable sort behavior.
///
/// - Parameter list: The list to split.
/// - Returns: A tuple containing the first half and second half of `list`.
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

/// Sorts a list using a stable merge sort.
///
/// - Parameters:
///   - cmp: The comparison function used to order values.
///   - list: The list to sort.
/// - Returns: A sorted list containing the values from `list`.
public func sort<T>(_ cmp: ListSort<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    switch list {
    case .empty: return .empty
    case .cons(_, .empty): return list
    case .cons:
        let (lhs, rhs) = halve(list)
        return merge(cmp, sort(cmp, lhs), sort(cmp, rhs))
    }
}

/// Creates a pipe-forward helper for `sort`.
///
/// - Parameter cmp: The comparison function used to order values.
/// - Returns: A function that sorts its input list.
public func sortOf<T>(_ cmp: @escaping ListSort<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in sort(cmp, list) }
}

/// Sorts a list using the same stable merge-sort implementation as `sort`.
///
/// - Parameters:
///   - cmp: The comparison function used to order values.
///   - list: The list to sort.
/// - Returns: A sorted list containing the values from `list`.
public func stableSort<T>(_ cmp: ListSort<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    sort(cmp, list)
}

/// Creates a pipe-forward helper for `stableSort`.
///
/// - Parameter cmp: The comparison function used to order values.
/// - Returns: A function that stable-sorts its input list.
public func stableSortOf<T>(_ cmp: @escaping ListSort<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in stableSort(cmp, list) }
}

/// Sorts a list using the same stable merge-sort implementation as `sort`.
///
/// `fastSort` is provided as an OCaml-style API alias.
///
/// - Parameters:
///   - cmp: The comparison function used to order values.
///   - list: The list to sort.
/// - Returns: A sorted list containing the values from `list`.
public func fastSort<T>(_ cmp: ListSort<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    sort(cmp, list)
}

/// Creates a pipe-forward helper for `fastSort`.
///
/// - Parameter cmp: The comparison function used to order values.
/// - Returns: A function that fast-sorts its input list.
public func fastSortOf<T>(_ cmp: @escaping ListSort<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { list in fastSort(cmp, list) }
}
