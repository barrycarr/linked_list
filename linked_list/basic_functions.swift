//
//  linked_list.swift
//  linked_list
//
//  Created by Barry Carr on 17/08/2026.
//

/// Creates an empty linked list.
///
/// Use an explicit type annotation when Swift cannot infer the element type.
///
/// - Returns: An empty `LinkedList`.
public func empty<T>() -> LinkedList<T> {
    return .empty
}

/// Returns the first value in a list.
///
/// - Parameter list: The list to inspect.
/// - Returns: The first value, or `nil` when the list is empty.
public func head<T>(_ list: LinkedList<T>) -> T? {
    switch list {
    case .empty: return nil
    case .cons(let value, _): return value
    }
}

/// Returns the list without its first value.
///
/// - Parameter list: The list to inspect.
/// - Returns: The tail of the list, or `.empty` when the list is empty.
public func tail<T>(_ list: LinkedList<T>) -> LinkedList<T> {
    switch list {
    case .empty: return .empty
    case .cons(_, let rest): return rest
    }
}

/// Counts the number of values in a list.
///
/// - Parameter list: The list to count.
/// - Returns: The number of values in `list`.
public func length<T>(_ list: LinkedList<T>) -> Int {
    switch list {
    case .empty: return 0
    case .cons(_, let rest): return 1 + length(rest)
    }
}

/// Checks whether a list contains no values.
///
/// - Parameter list: The list to inspect.
/// - Returns: `true` when `list` is `.empty`; otherwise, `false`.
public func isEmpty<T>(_ list: LinkedList<T>) -> Bool {
    switch list {
    case .cons: return false
    case .empty: return true
    }
}

/// Returns the value at a zero-based index.
///
/// - Parameters:
///   - n: The zero-based index to retrieve.
///   - list: The list to inspect.
/// - Returns: `.success(value)` when the index exists, `.failure(.negativeIndex)`
///   for a negative index, `.failure(.listEmpty)` for an empty list, or
///   `.failure(.listTooShort)` when the index is beyond the end of the list.
public func nth<T>(_ n: Int, _ list: LinkedList<T>) -> Result<T, LinkedListError> {
    guard n >= 0 else {
        return .failure(.negativeIndex)
    }
    guard !isEmpty(list) else {
        return .failure(.listEmpty)
    }

    func getNth(_ index: Int, _ list: LinkedList<T>) -> Result<T, LinkedListError> {
        switch (index, list) {
        case (0, .cons(let value, _)): return .success(value)
        case (_, .empty): return .failure(.listTooShort)
        case (let index, .cons(_, let rest)): return getNth(index - 1, rest)
        }
    }

    return getNth(n, list)
}

/// Creates a pipe-forward helper for `nth`.
///
/// - Parameter list: The list to inspect.
/// - Returns: A function that accepts an index and returns the matching `nth` result.
public func nthOf<T>(_ list: LinkedList<T>) -> (Int) -> Result<T, LinkedListError> {
    { index in nth(index, list) }
}

/// Returns the value at a zero-based index, if it exists.
///
/// - Parameters:
///   - n: The zero-based index to retrieve.
///   - list: The list to inspect.
/// - Returns: The value at `n`, or `nil` when the index is invalid or outside the list.
public func nthOpt<T>(_ n: Int, _ list: LinkedList<T>) -> T? {
    switch nth(n, list) {
    case .success(let value): return value
    case .failure: return nil
    }
}

/// Creates a pipe-forward helper for `nthOpt`.
///
/// - Parameter list: The list to inspect.
/// - Returns: A function that accepts an index and returns the matching optional value.
public func nthOfOpt<T>(_ list: LinkedList<T>) -> (Int) -> T? {
    { index in nthOpt(index, list) }
}

/// Creates a list containing exactly one value.
///
/// - Parameter value: The value to store in the list.
/// - Returns: A single-value linked list.
public func singleton<T>(_ value: T) -> LinkedList<T> {
    .cons(value, .empty)
}

/// Reverses a list.
///
/// - Parameter list: The list to reverse.
/// - Returns: A new list containing the same values in reverse order.
public func reverse<T>(_ list: LinkedList<T>) -> LinkedList<T> {
    func reversed(_ remaining: LinkedList<T>, _ result: LinkedList<T>) -> LinkedList<T> {
        switch remaining {
        case .empty:
            return result
        case .cons(let value, let rest):
            return reversed(rest, .cons(value, result))
        }
    }

    return reversed(list, .empty)
}

/// Appends one list to another.
///
/// - Parameters:
///   - l0: The first list. Its values appear first in the result.
///   - l1: The second list. Its values appear after the values from `l0`.
/// - Returns: A new list containing all values from the first list followed by all values from the second list.
public func append<T>(_ l0: LinkedList<T>, _ l1: LinkedList<T>) -> LinkedList<T> {
    switch l0 {
    case .empty: return l1
    case .cons(let value, let rest): return .cons(value, append(rest,l1))
    }
}

/// Creates a pipe-forward helper for `append`.
///
/// - Parameter second: The list to append after the piped list.
/// - Returns: A function that appends `second` to its input list.
public func appendTo<T>(_ second: LinkedList<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { first in append(first, second) }
}

/// Reverses one list and appends another list to it.
///
/// - Parameters:
///   - l0: The first list. Its values are reversed before appending.
///   - l1: The second list. Its values appear after the reversed values from `l0`.
/// - Returns: The reversed first list followed by the second list.
public func revAppend<T>(_ l0: LinkedList<T>, _ l1: LinkedList<T>) -> LinkedList<T> {
    reverse(l0) |> appendTo(l1)
}

/// Creates a pipe-forward helper for `revAppend`.
///
/// - Parameter second: The list to append after the reversed piped list.
/// - Returns: A function that reverses its input list and appends `second`.
public func revAppendTo<T>(_ second: LinkedList<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { first in revAppend(first, second) }
}

/// Concatenates a list of lists into a single list.
///
/// - Parameter lists: The linked list of linked lists to concatenate.
/// - Returns: A list containing all values from each nested list in order.
public func concat<T>(_ lists: LinkedList<LinkedList<T>>) -> LinkedList<T> {
    switch lists {
    case .empty: return .empty
    case .cons(let first, let rest): return append(first, concat(rest))
    }
}

/// Flattens a list of lists into a single list.
///
/// `flatten` is an alias for `concat`.
///
/// - Parameter lists: The linked list of linked lists to flatten.
/// - Returns: A list containing all values from each nested list in order.
public func flatten<T>(_ lists: LinkedList<LinkedList<T>>) -> LinkedList<T> {
    concat(lists)
}
