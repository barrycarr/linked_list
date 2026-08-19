//
//  linked_list.swift
//  linked_list
//
//  Created by Barry Carr on 17/08/2026.
//

public func empty<T>() -> LinkedList<T> {
    return .empty
}

public func head<T>(list: LinkedList<T>) -> T? {
    switch list {
    case .empty: return nil
    case let .cons(value, _): return value
    }
}

public func tail<T>(list: LinkedList<T>) -> LinkedList<T> {
    switch list {
    case .empty: return .empty
    case .cons(_, let rest): return rest
    }
}

public func length<T>(list: LinkedList<T>) -> Int {
    switch list {
    case .empty: return 0
    case let .cons(_, rest): return 1 + length(list: rest)
    }
}

public func isEmpty<T>(list: LinkedList<T>) -> Bool {
    switch list {
    case .cons: return false
    case .empty: return true
    }
}

public func nth<T>(n: Int, list: LinkedList<T>) -> Result<T?, LinkedListError> {
    guard n >= 0 else {
        return .failure(.negativeIndex)
    }
    guard !isEmpty(list: list) else {
        return .failure(.listEmpty)
    }
    
    func getNth(index: Int, list: LinkedList<T>) -> Result<T?, LinkedListError> {
        switch (index, list) {
        case (0, .cons(let value, _)): return .success(value)
        case (_, .empty): return .failure(.listTooShort)
        case (let index, .cons(_, let rest)): return getNth(index: index - 1, list: rest)
        }
    }
    
    return getNth(index: n, list: list)
}

public func nthOf<T>(_ list: LinkedList<T>) -> (Int) -> Result<T?, LinkedListError> {
    { index in nth(n: index, list: list) }
}

public func nthOpt<T>(n: Int, list: LinkedList<T>) -> T? {
    switch nth(n: n, list: list) {
    case .success(let value): return value
    case .failure: return nil
    }
}

public func nthOfOpt<T>(_ list: LinkedList<T>) -> (Int) -> T? {
    { index in nthOpt(n: index, list: list) }
}

public func singleton<T>(_ value: T) -> LinkedList<T> {
    .cons(value, .empty)
}

public func reverse<T>(_ list: LinkedList<T>) -> LinkedList<T> {
    func reversed(_ remaining: LinkedList<T>, into result: LinkedList<T>) -> LinkedList<T> {
        switch remaining {
        case .empty:
            return result
        case .cons(let value, let rest):
            return reversed(rest, into: .cons(value, result))
        }
    }

    return reversed(list, into: .empty)
}

public func append<T>(l0: LinkedList<T>, l1: LinkedList<T>) -> LinkedList<T> {
    switch l0 {
    case .empty: return l1
    case .cons(let value, let rest): return .cons(value, append(l0: rest, l1: l1))
    }
}

public func appendTo<T>(_ second: LinkedList<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { first in append(l0: first, l1: second) }
}

public func revAppend<T>(l0: LinkedList<T>, l1: LinkedList<T>) -> LinkedList<T> {
    reverse(l0) |> appendTo(l1)
}

public func revAppendTo<T>(_ second: LinkedList<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { first in revAppend(l0: first, l1: second) }
}

public func concat<T>(_ lists: LinkedList<LinkedList<T>>) -> LinkedList<T> {
    switch lists {
    case .empty: return .empty
    case .cons(let first, let rest): return append(l0: first, l1: concat(rest))
    }
}

public func flatten<T>(_ lists: LinkedList<LinkedList<T>>) -> LinkedList<T> {
    concat(lists)
}
