//
//  comparison.swift
//  linked_list
//
//  Created by Barry Carr on 19/08/2026.
//
public func compareLengths<T>(_ lhs: LinkedList<T>, _ rhs: LinkedList<T>) -> Int {
    switch (lhs, rhs) {
        case (.empty, .empty): return 0
        case (.empty, .cons): return -1
        case (.cons, .empty): return 1
        case (.cons(_, let lhsRest), .cons(_, let rhsRest)):
            return compareLengths(lhsRest, rhsRest)
    }
}

public func compareLengthWith<T>(_ list: LinkedList<T>, len: Int) -> Int {
    switch (list, len) {
        case (.empty, 0): return 0
        case (.empty, let n): return n > 0 ? -1 : 1
        case (.cons, let n) where n <= 0: return 1
        case (.cons(_, let rest), let n): return compareLengthWith(rest, len: n - 1)
    }
}

public func equal<T>(_ compareFn: LinkedListElementComparison<T>, _ lhs: LinkedList<T>, _ rhs: LinkedList<T>) -> Bool {
    switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.empty, .cons): return false
        case (.cons, .empty): return false
        case (.cons(let l, let lhsRest), .cons(let r, let rhsRest)):
            return compareFn(l, r) && equal(compareFn, lhsRest, rhsRest)
    }
}
