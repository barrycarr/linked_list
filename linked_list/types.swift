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
    case notFound
    case negativeCount
}

public indirect enum LinkedList<T> {
    case empty
    case cons(T, LinkedList<T>)
}

public enum Either<L, R> {
    case left(L)
    case right(R)
}
