//
//  scanning.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//

public typealias ListPredicate<T> = (T) -> Bool
public typealias ListPredicate2<T1, T2> = (T1, T2) -> Bool

public func forAll<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> Bool {
    switch list {
    case .empty: return true
    case .cons(let value, let rest):
        if !fn(value) { return false }
        return forAll(fn, rest)
    }
}

public func forAllOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Bool {
    { list in forAll(fn, list) }
}

public func forAll2<T1, T2>(
    _ fn: ListPredicate2<T1, T2>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<Bool, LinkedListError> {
    switch (l1, l2) {
    case (.empty, .empty): return .success(true)
    case (.empty, .cons): return .failure(.list1TooShort)
    case (.cons, .empty): return .failure(.list2TooShort)
    case (.cons(let v1, let r1), .cons(let v2, let r2)):
        if !fn(v1, v2) { return .success(false) }
        return forAll2(fn, r1, r2)
    }
}

public func exists<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> Bool {
    switch list {
    case .empty: return false
    case .cons(let value, let rest):
        if fn(value) { return true }
        return exists(fn, rest)
    }
}

public func existsOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> Bool {
    { list in exists(fn, list) }
}

public func exists2<T1, T2>(
    _ fn: ListPredicate2<T1, T2>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>
) -> Result<Bool, LinkedListError> {
    switch (l1, l2) {
    case (.empty, .empty): return .success(false)
    case (.empty, .cons): return .failure(.list1TooShort)
    case (.cons, .empty): return .failure(.list2TooShort)
    case (.cons(let v1, let r1), .cons(let v2, let r2)):
        if fn(v1, v2) { return .success(true) }
        return exists2(fn, r1, r2)
    }
}

public func mem<T: Equatable>(_ value: T, _ list: LinkedList<T>) -> Bool {
    exists({ element in element == value }, list)
}

public func memOf<T: Equatable>(_ value: T) -> (LinkedList<T>) -> Bool {
    { list in mem(value, list) }
}

public func memQ<T: AnyObject>(_ value: T, _ list: LinkedList<T>) -> Bool {
    exists({ element in element === value }, list)
}

public func memQOf<T: AnyObject>(_ value: T) -> (LinkedList<T>) -> Bool {
    { list in memQ(value, list) }
}

public func memBy<T>(
    _ eq: ListEq<T>,
    _ value: T,
    _ list: LinkedList<T>
) -> Bool {
    exists({ element in eq(element, value) }, list)
}

public func memByOf<T>(_ eq: @escaping ListEq<T>, _ value: T) -> (LinkedList<T>) -> Bool {
    { list in memBy(eq, value, list) }
}
