//
//  linked_list.swift
//  linked_list
//
//  Created by Barry Carr on 17/08/2026.
//

import Foundation

enum LinkedListError: Error {
    case listTooShort
    case negativeIndex
    case listEmpty
}

indirect enum LinkedList<T> {
    case empty
    case cons(T, LinkedList<T>)
}

func head<T>(list: LinkedList<T>) -> T? {
    switch list {
    case .empty: return nil
    case let .cons(value, _): return value
    }
}

func tail<T>(list: LinkedList<T>) -> LinkedList<T> {
    switch list {
    case .empty: return .empty
    case .cons(_, let rest): return rest
    }
}

func length<T>(list: LinkedList<T>) -> Int {
    switch list {
    case .empty: return 0
    case let .cons(_, rest): return 1 + length(list: rest)
    }
}

func isEmpty<T>(list: LinkedList<T>) -> Bool {
    switch list {
    case .cons: return false
    case .empty: return true
    }
}

func nth<T>(n: Int, list: LinkedList<T>) -> Result<T?, LinkedListError> {
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

func nthOpt<T>(n: Int, list: LinkedList<T>) -> T? {
    switch nth(n: n, list: list) {
    case .success(let value): return value
    case .failure: return nil
    }
}

func singleton<T>(_ value: T) -> LinkedList<T> {
    .cons(value, .empty)
}

func reverse<T>(_ list: LinkedList<T>) -> LinkedList<T> {
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
