//
//  sequences.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

extension LinkedList: Sequence {
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

public func ofArray<T>(_ values: [T]) -> LinkedList<T> {
    values.reversed().reduce(.empty) { list, value in
        value +| list
    }
}

public func toArray<T>(_ list: LinkedList<T>) -> [T] {
    Array(list)
}

public func ofCollection<C: Collection>(_ values: C) -> LinkedList<C.Element> {
    values.reversed().reduce(.empty) { list, value in
        value +| list
    }
}

public func ofSeq<S: Sequence>(_ values: S) -> LinkedList<S.Element> {
    var result = LinkedList<S.Element>.empty

    for value in values {
        result = value +| result
    }

    return reverse(result)
}
