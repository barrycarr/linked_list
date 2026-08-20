//
//  types.swift
//  
//
//  Created by Barry Carr on 19/08/2026.
//

public enum LinkedListError: Error {
    case listTooShort
    case negativeIndex
    case listEmpty
}

public indirect enum LinkedList<T> {
    case empty
    case cons(T, LinkedList<T>)
}

public typealias LinkedListElementEq<T> = (T, T) -> Bool
public typealias LinkedListElementCmp<T> = (T, T) -> Int
public typealias LinkedListIteration<T> = (T) -> Void
public typealias LinkedListIterationWithIndex<T> = (Int, T) -> Void
