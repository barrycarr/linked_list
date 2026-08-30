//
//  types.swift
//
//
//  Created by Barry Carr on 19/08/2026.
//

/// Errors returned by linked-list functions that can fail.
public enum LinkedListError: Error {
    /// The list does not contain enough elements for the requested operation.
    case listTooShort

    /// A negative index was supplied to an indexed operation.
    case negativeIndex

    /// The operation requires a non-empty list, but the list was empty.
    case listEmpty

    /// The first list ended before the operation could complete.
    case list1TooShort

    /// The second list ended before the operation could complete.
    case list2TooShort

    /// No matching element was found.
    case notFound

    /// A negative count was supplied to a count-based operation.
    case negativeCount
}

/// An immutable singly linked list.
///
/// `LinkedList` is represented as either an empty list or a value followed by
/// the rest of the list. The enum is `indirect` so that it can recursively
/// contain another `LinkedList`.
public indirect enum LinkedList<T> {
    /// An empty list.
    case empty

    /// A value followed by the remaining list.
    ///
    /// - Parameters:
    ///   - head: The value at the front of the list.
    ///   - tail: The remaining list after `head`.
    case cons(T, LinkedList<T>)
}

/// A value that can be one of two possible types.
///
/// This is useful for functions such as `partitionMap`, where each input value
/// is mapped into one of two output lists.
public enum Either<L, R> {
    /// A value belonging to the left side.
    case left(L)

    /// A value belonging to the right side.
    case right(R)
}
