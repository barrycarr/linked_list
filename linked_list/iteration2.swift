//
//  iteration2.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//

/// A function called for each pair of values from two lists.
public typealias ListIteration2<T1, T2> = (T1, T2) -> Void

/// A function that transforms a pair of values from two lists into one value.
public typealias ListMap2<T1, T2, U> = (T1, T2) -> U

/// A left-fold function over two lists.
///
/// The first argument is the current accumulator, followed by one value from
/// each list.
public typealias ListFoldLeft2<A, T1, T2> = (A, T1, T2) -> A

/// A right-fold function over two lists.
///
/// The first two arguments are one value from each list, followed by the folded
/// result of the remaining lists.
public typealias ListFoldRight2<T1, T2, A> = (T1, T2, A) -> A

/// Calls a function for each pair of values from two lists.
///
/// Iteration proceeds from left to right and stops with an error if the lists
/// have different lengths.
///
/// - Parameters:
///   - fn: The function to call with each pair of values.
///   - l1: The first list.
///   - l2: The second list.
/// - Returns: `.success(())` when both lists have the same length,
///   `.failure(.list1TooShort)` when `l1` ends first, or
///   `.failure(.list2TooShort)` when `l2` ends first.
public func iter2<T1, T2>(
    _ fn: ListIteration2<T1, T2>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<Void, LinkedListError> {
    switch (l1, l2) {
    case (.empty, .empty): return .success(())
    case (.empty, .cons): return .failure(.list1TooShort)
    case (.cons, .empty): return .failure(.list2TooShort)
    case (.cons(let v1, let r1), .cons(let v2, let r2)):
        fn(v1, v2)
        return iter2(fn, r1, r2)
    }
}

/// Maps pairs of values from two lists and returns the results in reverse order.
///
/// - Parameters:
///   - fn: The function used to transform each pair of values.
///   - l1: The first list.
///   - l2: The second list.
/// - Returns: `.success(list)` with the mapped values in reverse order when both
///   lists have the same length, `.failure(.list1TooShort)` when `l1` ends
///   first, or `.failure(.list2TooShort)` when `l2` ends first.
public func revMap2<T1, T2, U>(
    _ fn: ListMap2<T1, T2, U>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<LinkedList<U>, LinkedListError> {
    func doRevMap2(
        _ l1: LinkedList<T1>,
        _ l2: LinkedList<T2>,
        _ res: LinkedList<U>
    ) -> Result<LinkedList<U>, LinkedListError> {
        switch (l1, l2) {
        case (.empty, .empty): return .success(res)
        case (.empty, .cons): return .failure(.list1TooShort)
        case (.cons, .empty): return .failure(.list2TooShort)
        case (.cons(let v1, let r1), .cons(let v2, let r2)):
            let newVal = fn(v1, v2)
            return doRevMap2(r1, r2, newVal +| res)
        }
    }
    return doRevMap2(l1, l2, LinkedList<U>.empty)
}

/// Maps pairs of values from two lists.
///
/// - Parameters:
///   - fn: The function used to transform each pair of values.
///   - l1: The first list.
///   - l2: The second list.
/// - Returns: `.success(list)` with the mapped values in order when both lists
///   have the same length, `.failure(.list1TooShort)` when `l1` ends first, or
///   `.failure(.list2TooShort)` when `l2` ends first.
public func map2<T1, T2, U>(
    _ fn: ListMap2<T1, T2, U>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<LinkedList<U>, LinkedListError> {
    revMap2(fn, l1, l2).map(reverse)
}

/// Folds two lists from left to right.
///
/// - Parameters:
///   - fn: The function used to combine the accumulator and each pair of values.
///   - acc: The initial accumulator.
///   - l1: The first list.
///   - l2: The second list.
/// - Returns: `.success(accumulator)` when both lists have the same length,
///   `.failure(.list1TooShort)` when `l1` ends first, or
///   `.failure(.list2TooShort)` when `l2` ends first.
public func foldLeft2<A, T1, T2>(
    _ fn: ListFoldLeft2<A, T1, T2>,
    _ acc: A,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<A, LinkedListError> {
    switch (l1, l2) {
    case (.empty, .empty): return .success(acc)
    case (.empty, .cons): return .failure(.list1TooShort)
    case (.cons, .empty): return .failure(.list2TooShort)
    case (.cons(let v1, let r1), .cons(let v2, let r2)):
        let newAcc = fn(acc, v1, v2)
        return foldLeft2(fn, newAcc, r1, r2)
    }
}

/// Folds two lists from right to left.
///
/// This function is not tail-recursive.
///
/// - Parameters:
///   - fn: The function used to combine each pair of values with the folded rest.
///   - l1: The first list.
///   - l2: The second list.
///   - acc: The initial accumulator used at the end of the lists.
/// - Returns: `.success(accumulator)` when both lists have the same length,
///   `.failure(.list1TooShort)` when `l1` ends first, or
///   `.failure(.list2TooShort)` when `l2` ends first.
public func foldRight2<T1, T2, A>(
    _ fn: ListFoldRight2<T1, T2, A>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>,
    _ acc: A
) -> Result<A, LinkedListError> {
    switch (l1, l2) {
    case (.empty, .empty): return .success(acc)
    case (.empty, .cons): return .failure(.list1TooShort)
    case (.cons, .empty): return .failure(.list2TooShort)
    case (.cons(let v1, let r1), .cons(let v2, let r2)):
        return foldRight2(fn, r1, r2, acc).map { restAcc in
            fn(v1, v2, restAcc)
        }
    }
}
