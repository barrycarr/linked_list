//
//  manipulation.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

/// A function that maps a value into one of two partition outputs.
public typealias ListPartitionMap<T, L, R> = (T) -> Either<L, R>

/// Returns the first `n` values from a list.
///
/// If `n` is greater than the length of the list, the whole list is returned.
///
/// - Parameters:
///   - n: The maximum number of values to take.
///   - list: The list to take values from.
/// - Returns: `.success(list)` containing at most the first `n` values, or
///   `.failure(.negativeCount)` when `n` is negative.
public func take<T>(_ n: Int, _ list: LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    guard n >= 0 else {
        return .failure(.negativeCount)
    }

    func doTake(_ list: LinkedList<T>, _ res: LinkedList<T>, _ count: Int) -> Result<LinkedList<T>, LinkedListError> {
        switch list {
        case .empty: return .success(reverse(res))
        case .cons(let val, let rest):
            if count == n {
                return .success(reverse(res))
            }
            return doTake(rest, val +| res, count + 1)
        }
    }

    return doTake(list, LinkedList<T>.empty, 0)
}

/// Creates a pipe-forward helper for `take`.
///
/// - Parameter n: The maximum number of values to take.
/// - Returns: A function that takes values from its input list.
public func takeOf<T>(_ n: Int) -> (LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    { take(n, $0) }
}

/// Drops the first `n` values from a list.
///
/// If `n` is greater than the length of the list, an empty list is returned.
///
/// - Parameters:
///   - n: The number of values to drop.
///   - list: The list to drop values from.
/// - Returns: `.success(list)` without the first `n` values, or
///   `.failure(.negativeCount)` when `n` is negative.
public func drop<T>(_ n: Int, _ list: LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    guard n >= 0 else {
        return .failure(.negativeCount)
    }

    func doDrop(_ list: LinkedList<T>, _ count: Int) -> Result<LinkedList<T>, LinkedListError> {
        if count == 0 {
            return .success(list)
        }

        switch list {
        case .empty: return .success(.empty)
        case .cons(_, let rest): return doDrop(rest, count - 1)
        }
    }

    return doDrop(list, n)
}

/// Creates a pipe-forward helper for `drop`.
///
/// - Parameter n: The number of values to drop.
/// - Returns: A function that drops values from its input list.
public func dropOf<T>(_ n: Int) -> (LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    { drop(n, $0) }
}

/// Takes values from the front of a list while a predicate is true.
///
/// Traversal stops at the first value for which `fn` returns `false`.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to take values from.
/// - Returns: A list containing the leading values that satisfy `fn`.
public func takeWhile<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    func doTakeWhile(_ list: LinkedList<T>, _ res: LinkedList<T>) -> LinkedList<T> {
        switch list {
        case .empty: return reverse(res)
        case .cons(let val, let rest):
            if fn(val) {
                return doTakeWhile(rest, val +| res)
            }
            return reverse(res)
        }
    }

    return doTakeWhile(list, LinkedList<T>.empty)
}

/// Creates a pipe-forward helper for `takeWhile`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that takes leading values from its input list while
///   `fn` returns `true`.
public func takeWhileOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { takeWhile(fn, $0) }
}

/// Drops values from the front of a list while a predicate is true.
///
/// Traversal stops at the first value for which `fn` returns `false`; that value
/// and the remaining list are returned.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to drop values from.
/// - Returns: The remaining list after dropping the leading values that satisfy
///   `fn`.
public func dropWhile<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    switch list {
    case .empty: return .empty
    case .cons(let val, let rest):
        if !fn(val) {
            return list
        }
        return dropWhile(fn, rest)
    }
}

/// Creates a pipe-forward helper for `dropWhile`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that drops leading values from its input list while
///   `fn` returns `true`.
public func dropWhileOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { dropWhile(fn, $0) }
}

/// Splits a list into values that satisfy a predicate and values that do not.
///
/// - Parameters:
///   - fn: The predicate used to test each value.
///   - list: The list to partition.
/// - Returns: A tuple whose first list contains values where `fn` returned
///   `true`, and whose second list contains values where `fn` returned `false`.
public func partition<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> (LinkedList<T>, LinkedList<T>) {
    func doPartition(_ list: LinkedList<T>, _ a: LinkedList<T>, _ b: LinkedList<T>) -> (LinkedList<T>, LinkedList<T>) {
        switch list {
        case .empty: return (reverse(a), reverse(b))
        case .cons(let val, let rest):
            if fn(val) {
                return doPartition(rest, val +| a, b)
            }
            return doPartition(rest, a, val +| b)
        }
    }

    return doPartition(list, LinkedList<T>.empty, LinkedList<T>.empty)
}

/// Creates a pipe-forward helper for `partition`.
///
/// - Parameter fn: The predicate used to test each value.
/// - Returns: A function that partitions its input list.
public func partitionOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> (LinkedList<T>, LinkedList<T>) {
    { partition(fn, $0) }
}

/// Maps each value into one of two output lists.
///
/// Values mapped to `.left` are added to the first result list. Values mapped to
/// `.right` are added to the second result list.
///
/// - Parameters:
///   - fn: The function used to map each value into either output partition.
///   - list: The list to partition and map.
/// - Returns: A tuple containing the left mapped values and right mapped values,
///   both in their original relative order.
public func partitionMap<T, L, R>(
    _ fn: ListPartitionMap<T, L, R>,
    _ list: LinkedList<T>
) -> (LinkedList<L>, LinkedList<R>) {
    func doPartitionMap(_ list: LinkedList<T>, _ l: LinkedList<L>, _ r: LinkedList<R>) -> (LinkedList<L>, LinkedList<R>)
    {
        switch list {
        case .empty: return (reverse(l), reverse(r))
        case .cons(let val, let rest):
            switch fn(val) {
            case .left(let lval): return doPartitionMap(rest, lval +| l, r)
            case .right(let rval): return doPartitionMap(rest, l, rval +| r)
            }
        }
    }

    return doPartitionMap(list, LinkedList<L>.empty, LinkedList<R>.empty)
}

/// Creates a pipe-forward helper for `partitionMap`.
///
/// - Parameter fn: The function used to map each value into either output partition.
/// - Returns: A function that partition-maps its input list.
public func partitionMapOf<T, L, R>(
    _ fn: @escaping ListPartitionMap<T, L, R>
) -> (LinkedList<T>) -> (LinkedList<L>, LinkedList<R>) {
    { partitionMap(fn, $0) }
}
