//
//  operators.swift
//
//
//  Created by Barry Carr on 19/08/2026.
//

/// Precedence for the cons operator.
///
/// `+|` is right-associative so expressions such as
/// `1 +| 2 +| LinkedList.empty` build lists in natural left-to-right order.
precedencegroup ConsPrecedence {
    associativity: right
    higherThan: AdditionPrecedence
}

/// Conses a value onto the front of a linked list.
infix operator +| : ConsPrecedence

/// Conses a value onto the front of a linked list.
///
/// - Parameters:
///   - value: The value to place at the front of the list.
///   - list: The list that becomes the tail.
/// - Returns: A new list whose head is `value` and whose tail is `list`.
public func +| <T>(value: T, list: LinkedList<T>) -> LinkedList<T> {
    .cons(value, list)
}

/// Precedence for the pipe-forward operator.
///
/// `|>` is left-associative so chained calls read from left to right.
precedencegroup ForwardApplication {
    associativity: left
    higherThan: AssignmentPrecedence
}

/// Applies a value to a function.
infix operator |> : ForwardApplication

/// Applies a value to a function.
///
/// - Parameters:
///   - value: The value to pass to `function`.
///   - function: The function to apply.
/// - Returns: The result of calling `function(value)`.
public func |> <T, R>(value: T, function: (T) -> R) -> R {
    function(value)
}

/// Appends two linked lists.
infix operator <> : AdditionPrecedence

/// Appends two linked lists.
///
/// - Parameters:
///   - lhs: The list whose values appear first.
///   - rhs: The list whose values appear after `lhs`.
/// - Returns: A new list containing all values from `lhs` followed by all values
///   from `rhs`.
public func <> <T>(lhs: LinkedList<T>, rhs: LinkedList<T>) -> LinkedList<T> {
    append(lhs, rhs)
}
