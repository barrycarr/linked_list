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
    case list1TooShort
    case list2TooShort
}

public indirect enum LinkedList<T> {
    case empty
    case cons(T, LinkedList<T>)
}

// Comparison
public typealias LinkedListElementEq<T> = (T, T) -> Bool
public typealias LinkedListElementCmp<T> = (T, T) -> Int
public typealias LinkedListIteration<T> = (T) -> Void
public typealias LinkedListIterationWithIndex<T> = (Int, T) -> Void

// Iteration
public typealias LinkedListMap<T, U> = (T) -> U
public typealias LinkedListMapWithIndex<T, U> = (Int, T) -> U
public typealias LinkedListFilter<T, U> = (T) -> U?
public typealias LinkedListFilterWithIndex<T, U> = (Int, T) -> U?
public typealias LinkedListConcatMap<T,U> = (T) -> LinkedList<U>
public typealias LinkedListFoldLeft<A, T> = (A, T) -> A
public typealias LinkedListFoldLeftMap<A, T, U> = (A, T) -> (A, U)
public typealias LinkedListFoldRight<T, A> = (T, A) -> A

// Iteration2
public typealias LinkedListIteration2<T1, T2> = (T1, T2) -> Void
public typealias LinkedListMap2<T1, T2, U> = (T1, T2) -> U
public typealias LinkedListFoldLeft2<A, T1, T2> = (A, T1, T2) -> A
public typealias LinkedListFoldRight2<T1, T2, A> = (T1, T2, A) -> A
