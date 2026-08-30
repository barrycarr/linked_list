//
//  comparison.swift
//  linked_list
//
//  Created by Barry Carr on 19/08/2026.
//

/// A predicate that tests two values for equality.
public typealias ListEq<T> = (T, T) -> Bool

/// A comparison function.
///
/// Return a negative value when the first argument is smaller, `0` when the
/// arguments compare equal, and a positive value when the first argument is
/// greater.
public typealias ListCmp<T> = (T, T) -> Int

/// A function called for each value in a list.
public typealias ListIter<T> = (T) -> Void

/// A function called for each index and value in a list.
public typealias ListIterIndex<T> = (Int, T) -> Void

/// Compares the lengths of two lists.
///
/// The comparison stops as soon as the end of either list is reached, so it does
/// not need to fully count both lists when their lengths differ.
///
/// - Parameters:
///   - lhs: The first list.
///   - rhs: The second list.
/// - Returns: `0` when the lists have the same length, a negative value when
///   `lhs` is shorter, or a positive value when `lhs` is longer.
public func compareLengths<T>(_ lhs: LinkedList<T>, _ rhs: LinkedList<T>) -> Int {
    switch (lhs, rhs) {
    case (.empty, .empty): return 0
    case (.empty, .cons): return -1
    case (.cons, .empty): return 1
    case (.cons(_, let lhsRest), .cons(_, let rhsRest)):
        return compareLengths(lhsRest, rhsRest)
    }
}

/// Compares a list's length with an integer.
///
/// The comparison stops once either the list ends or the requested length has
/// been reached.
///
/// - Parameters:
///   - list: The list to compare.
///   - len: The length to compare against.
/// - Returns: `0` when `list` has length `len`, a negative value when `list` is
///   shorter than `len`, or a positive value when `list` is longer than `len`.
public func compareLengthWith<T>(_ list: LinkedList<T>, len: Int) -> Int {
    switch (list, len) {
    case (.empty, 0): return 0
    case (.empty, let n): return n > 0 ? -1 : 1
    case (.cons, let n) where n <= 0: return 1
    case (.cons(_, let rest), let n): return compareLengthWith(rest, len: n - 1)
    }
}

/// Tests whether two lists are equal using a supplied equality predicate.
///
/// Lists are equal when they have the same length and every pair of values at
/// the same position satisfies `eqFn`.
///
/// - Parameters:
///   - eqFn: The predicate used to compare values.
///   - lhs: The first list.
///   - rhs: The second list.
/// - Returns: `true` when both lists contain equal values in the same order;
///   otherwise, `false`.
public func equal<T>(_ eqFn: ListEq<T>, _ lhs: LinkedList<T>, _ rhs: LinkedList<T>) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty): return true
    case (.empty, .cons): return false
    case (.cons, .empty): return false
    case (.cons(let l, let lhsRest), .cons(let r, let rhsRest)):
        return eqFn(l, r) && equal(eqFn, lhsRest, rhsRest)
    }
}

/// Lexicographically compares two lists using a supplied comparison function.
///
/// The first non-zero element comparison is returned. If all shared elements
/// compare equal, the shorter list is ordered before the longer list.
///
/// - Parameters:
///   - cmpFn: The function used to compare values.
///   - lhs: The first list.
///   - rhs: The second list.
/// - Returns: `0` when both lists compare equal, a negative value when `lhs`
///   sorts before `rhs`, or a positive value when `lhs` sorts after `rhs`.
public func compare<T>(_ cmpFn: ListCmp<T>, _ lhs: LinkedList<T>, _ rhs: LinkedList<T>) -> Int {
    switch (lhs, rhs) {
    case (.empty, .empty): return 0
    case (.empty, .cons): return -1
    case (.cons, .empty): return 1
    case (.cons(let l, let lhsRest), .cons(let r, let rhsRest)):
        let cmp = cmpFn(l, r)
        return cmp != 0 ? cmp : compare(cmpFn, lhsRest, rhsRest)
    }
}
