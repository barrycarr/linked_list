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
