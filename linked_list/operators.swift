//
//  operators.swift
//
//
//  Created by Barry Carr on 19/08/2026.
//

precedencegroup ConsPrecedence {
    associativity: right
    higherThan: AdditionPrecedence
}

infix operator +| : ConsPrecedence

public func +| <T>(value: T, list: LinkedList<T>) -> LinkedList<T> {
    .cons(value, list)
}

precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |> : ForwardApplication

public func |> <T, R>(value: T, function: (T) -> R) -> R {
    function(value)
}

infix operator <> : AdditionPrecedence

public func <> <T>(lhs: LinkedList<T>, rhs: LinkedList<T>) -> LinkedList<T> {
    append(l0: lhs, l1: rhs)
}
