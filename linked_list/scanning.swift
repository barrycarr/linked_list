//
//  scanning.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//

/// A predicate that tests a single value.
public typealias ListPredicate<T> = (T) -> Bool

/// A predicate that tests one value from each of two lists.
public typealias ListPredicate2<T1, T2> = (T1, T2) -> Bool

/// Tests whether every value in a list satisfies a predicate.
///
/// The function short-circuits and returns `false` at the first value that does
/// not satisfy `fn`. The empty list returns `true`.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to scan.
/// - Returns: `true` when every value satisfies `fn`; otherwise, `false`.
public func forAll<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> Bool {
    switch list {
    case .empty: return true
    case .cons(let value, let rest):
        if !fn(value) { return false }
        return forAll(fn, rest)
    }
}

/// Creates a pipe-forward helper for `forAll`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that tests every value in its input list.
public func forAllOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Bool {
    { list in forAll(fn, list) }
}

/// Tests whether every pair of values from two lists satisfies a predicate.
///
/// The function short-circuits and returns `.success(false)` at the first pair
/// that does not satisfy `fn`. The operation fails if the lists have different
/// lengths.
///
/// - Parameters:
///   - fn: The predicate used to test each pair of values.
///   - l1: The first list.
///   - l2: The second list.
/// - Returns: `.success(true)` when every pair satisfies `fn`,
///   `.success(false)` when any pair does not satisfy `fn`,
///   `.failure(.list1TooShort)` when `l1` ends first, or
///   `.failure(.list2TooShort)` when `l2` ends first.
public func forAll2<T1, T2>(
    _ fn: ListPredicate2<T1, T2>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<Bool, LinkedListError> {
    switch (l1, l2) {
    case (.empty, .empty): return .success(true)
    case (.empty, .cons): return .failure(.list1TooShort)
    case (.cons, .empty): return .failure(.list2TooShort)
    case (.cons(let v1, let r1), .cons(let v2, let r2)):
        if !fn(v1, v2) { return .success(false) }
        return forAll2(fn, r1, r2)
    }
}

/// Tests whether any value in a list satisfies a predicate.
///
/// The function short-circuits and returns `true` at the first value that
/// satisfies `fn`. The empty list returns `false`.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to scan.
/// - Returns: `true` when any value satisfies `fn`; otherwise, `false`.
public func exists<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> Bool {
    switch list {
    case .empty: return false
    case .cons(let value, let rest):
        if fn(value) { return true }
        return exists(fn, rest)
    }
}

/// Creates a pipe-forward helper for `exists`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that tests whether any value in its input list
///   satisfies `fn`.
public func existsOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Bool {
    { list in exists(fn, list) }
}

/// Tests whether any pair of values from two lists satisfies a predicate.
///
/// The function short-circuits and returns `.success(true)` at the first pair
/// that satisfies `fn`. The operation fails if the lists have different lengths.
///
/// - Parameters:
///   - fn: The predicate used to test each pair of values.
///   - l1: The first list.
///   - l2: The second list.
/// - Returns: `.success(true)` when any pair satisfies `fn`,
///   `.success(false)` when no pair satisfies `fn`,
///   `.failure(.list1TooShort)` when `l1` ends first, or
///   `.failure(.list2TooShort)` when `l2` ends first.
public func exists2<T1, T2>(
    _ fn: ListPredicate2<T1, T2>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<Bool, LinkedListError> {
    switch (l1, l2) {
    case (.empty, .empty): return .success(false)
    case (.empty, .cons): return .failure(.list1TooShort)
    case (.cons, .empty): return .failure(.list2TooShort)
    case (.cons(let v1, let r1), .cons(let v2, let r2)):
        if fn(v1, v2) { return .success(true) }
        return exists2(fn, r1, r2)
    }
}

/// Tests whether a list contains a value using `Equatable` equality.
///
/// - Parameters:
///   - value: The value to search for.
///   - list: The list to scan.
/// - Returns: `true` when `list` contains a value equal to `value`; otherwise,
///   `false`.
public func mem<T: Equatable>(_ value: T, _ list: LinkedList<T>) -> Bool {
    exists({ element in element == value }, list)
}

/// Creates a pipe-forward helper for `mem`.
///
/// - Parameter value: The value to search for.
/// - Returns: A function that tests whether its input list contains `value`.
public func memOf<T: Equatable>(_ value: T) -> (LinkedList<T>) -> Bool {
    { list in mem(value, list) }
}

/// Tests whether a list contains an object using identity equality.
///
/// - Parameters:
///   - value: The object instance to search for.
///   - list: The list to scan.
/// - Returns: `true` when `list` contains the identical object instance;
///   otherwise, `false`.
public func memQ<T: AnyObject>(_ value: T, _ list: LinkedList<T>) -> Bool {
    exists({ element in element === value }, list)
}

/// Creates a pipe-forward helper for `memQ`.
///
/// - Parameter value: The object instance to search for.
/// - Returns: A function that tests whether its input list contains the
///   identical object instance.
public func memQOf<T: AnyObject>(_ value: T) -> (LinkedList<T>) -> Bool {
    { list in memQ(value, list) }
}

/// Tests whether a list contains a value using a supplied equality predicate.
///
/// - Parameters:
///   - eq: The equality predicate used to compare list values with `value`.
///   - value: The value to search for.
///   - list: The list to scan.
/// - Returns: `true` when any value in `list` is equal to `value` according to
///   `eq`; otherwise, `false`.
public func memBy<T>(
    _ eq: ListEq<T>,
    _ value: T,
    _ list: LinkedList<T>
) -> Bool {
    exists({ element in eq(element, value) }, list)
}

/// Creates a pipe-forward helper for `memBy`.
///
/// - Parameters:
///   - eq: The equality predicate used to compare list values with `value`.
///   - value: The value to search for.
/// - Returns: A function that tests whether its input list contains `value`
///   according to `eq`.
public func memByOf<T>(_ eq: @escaping ListEq<T>, _ value: T) -> (LinkedList<T>) -> Bool {
    { list in memBy(eq, value, list) }
}
