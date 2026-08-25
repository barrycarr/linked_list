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
public typealias LinkedListMap<T, U> = (T) -> U
public typealias LinkedListMapWithIndex<T, U> = (Int, T) -> U
public typealias LinkedListFilter<T, U> = (T) -> U?
public typealias LinkedListFilterWithIndex<T, U> = (Int, T) -> U?
public typealias LinkedListConcatMap<T,U> = (T) -> LinkedList<U>
public typealias LinkedListFoldLeft<A, T> = (A, T) -> A
public typealias LinkedListFoldRight<T, A> = (T, A) -> A
