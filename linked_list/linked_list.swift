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

precedencegroup ConsPrecendence {
    associativity: right
    higherThan: AdditionPrecedence
}

infix operator +|: ConsPrecendence

func +| <T>(value: T, list: LinkedList<T>) -> LinkedList<T> {
    .cons(value, list)
}

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: ForwardApplication

func |> <T, R>(value: T, function: (T) -> R) -> R {
    function(value)
}

func empty<T>() -> LinkedList<T> {
    return .empty
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

func nthOf<T>(_ list: LinkedList<T>) -> (Int) -> Result<T?, LinkedListError> {
    { index in nth(n: index, list: list) }
}

func nthOpt<T>(n: Int, list: LinkedList<T>) -> T? {
    switch nth(n: n, list: list) {
    case .success(let value): return value
    case .failure: return nil
    }
}

func nthOfOpt<T>(_ list: LinkedList<T>) -> (Int) -> T? {
    { index in nthOpt(n: index, list: list) }
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

infix operator <>: AdditionPrecedence

func <> <T>(lhs: LinkedList<T>, rhs: LinkedList<T>) -> LinkedList<T> {
    append(l0: lhs, l1: rhs)
}

func append<T>(l0: LinkedList<T>, l1: LinkedList<T>) -> LinkedList<T> {
    switch l0 {
    case .empty: return l1
    case .cons(let value, let rest): return .cons(value, append(l0: rest, l1: l1))
    }
}

func appendTo<T>(_ second: LinkedList<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { first in append(l0: first, l1: second) }
}

func revAppend<T>(l0: LinkedList<T>, l1: LinkedList<T>) -> LinkedList<T> {
    reverse(l0) |> appendTo(l1)
}

func revAppendTo<T>(_ second: LinkedList<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { first in revAppend(l0: first, l1: second) }
}

func concat<T>(_ lists: LinkedList<LinkedList<T>>) -> LinkedList<T> {
    switch lists {
    case .empty: return .empty
    case .cons(let first, let rest): return append(l0: first, l1: concat(rest))
    }
}

func flatten<T>(_ lists: LinkedList<LinkedList<T>>) -> LinkedList<T> {
    concat(lists)
}
