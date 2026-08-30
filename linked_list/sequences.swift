//
//  sequences.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

/// Adds standard Swift sequence iteration to `LinkedList`.
extension LinkedList: Sequence {
    /// Creates an iterator over the values in the list.
    ///
    /// Values are yielded from head to tail.
    ///
    /// - Returns: An iterator that produces each value in list order.
    public func makeIterator() -> AnyIterator<T> {
        var current = self

        return AnyIterator {
            switch current {
            case .empty:
                return nil
            case .cons(let value, let rest):
                current = rest
                return value
            }
        }
    }
}

/// Creates a linked list from an array.
///
/// - Parameter values: The array whose values should be copied into a list.
/// - Returns: A linked list containing the array values in the same order.
public func ofArray<T>(_ values: [T]) -> LinkedList<T> {
    values.reversed().reduce(.empty) { list, value in
        value +| list
    }
}

/// Converts a linked list to an array.
///
/// - Parameter list: The list to convert.
/// - Returns: An array containing the list values in order.
public func toArray<T>(_ list: LinkedList<T>) -> [T] {
    Array(list)
}

/// Creates a linked list from a collection.
///
/// This can consume collection types such as arrays, array slices, sets, and
/// ranges.
///
/// - Parameter values: The collection whose values should be copied into a list.
/// - Returns: A linked list containing the collection values in iteration order.
public func ofCollection<C: Collection>(_ values: C) -> LinkedList<C.Element> {
    values.reversed().reduce(.empty) { list, value in
        value +| list
    }
}

/// Creates a linked list from a sequence.
///
/// Unlike `ofCollection`, this accepts any `Sequence`, including single-pass
/// sequences.
///
/// - Parameter values: The sequence whose values should be copied into a list.
/// - Returns: A linked list containing the sequence values in iteration order.
public func ofSeq<S: Sequence>(_ values: S) -> LinkedList<S.Element> {
    var result = LinkedList<S.Element>.empty

    for value in values {
        result = value +| result
    }

    return reverse(result)
}
