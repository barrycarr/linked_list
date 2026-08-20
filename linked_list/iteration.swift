//
//  iteration.swift
//  linked_list
//
//  Created by Barry Carr on 20/08/2026.
//
public func iter<T>(_ fn: (T) -> Void, _ list: LinkedList<T>) -> Void {
    switch list {
        case .empty: return
        case .cons(let value, let rest):
            fn(value)
            iter(fn, rest)
    }
}
