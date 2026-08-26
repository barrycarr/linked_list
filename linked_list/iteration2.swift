//
//  iteration2.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//
public func iter2<T1, T2>(
    _ fn: LinkedListIteration2<T1, T2>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>) -> Result<Void, LinkedListError> {
    switch (l1, l2) {
        case (.empty, .empty): return .success(())
        case (.empty, .cons): return .failure(.list1TooShort)
        case (.cons, .empty): return .failure(.list2TooShort)
        case (.cons(let v1, let r1), .cons(let v2, let r2)):
            fn(v1, v2)
            return iter2(fn, r1, r2)
    }
}

public func revMap2<T1, T2, U>(
    _ fn: LinkedListMap2<T1, T2, U>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>) -> Result<LinkedList<U>, LinkedListError> {
    func doRevMap2(
        _ fn: LinkedListMap2<T1, T2, U>,
        _ l1: LinkedList<T1>,
        _ l2: LinkedList<T2>,
        _ res: LinkedList<U>) -> Result<LinkedList<U>, LinkedListError> {
        switch (l1, l2) {
            case (.empty, .empty): return .success(res)
            case (.empty, .cons): return .failure(.list1TooShort)
            case (.cons, .empty): return .failure(.list2TooShort)
            case (.cons(let v1, let r1), .cons(let v2, let r2)):
                let newVal = fn(v1, v2)
                return doRevMap2(fn, r1, r2, newVal +| res)
        }
    }
    return doRevMap2(fn, l1, l2, LinkedList<U>.empty)
}

public func map2<T1, T2, U>(
    _ fn: LinkedListMap2<T1, T2, U>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>) -> Result<LinkedList<U>, LinkedListError> {
        revMap2(fn, l1, l2).map(reverse)
}

public func foldLeft2<A, T1, T2>(
    _ fn: LinkedListFoldLeft2<A, T1, T2>,
    _ acc: A,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>) -> Result<A, LinkedListError> {
    switch (l1, l2) {
        case (.empty, .empty): return .success(acc)
        case (.empty, .cons): return .failure(.list1TooShort)
        case (.cons, .empty): return .failure(.list2TooShort)
        case (.cons(let v1, let r1), .cons(let v2, let r2)):
            let newAcc = fn(acc, v1, v2)
            return foldLeft2(fn, newAcc, r1, r2)
    }
}

// NOT tail Recursive
public func foldRight2<T1, T2, A>(
    _ fn: LinkedListFoldRight2<T1, T2, A>,
    _ l1: LinkedList<T1>,
    _ l2: LinkedList<T2>,
    _ acc: A) -> Result<A, LinkedListError> {
    switch (l1, l2) {
        case (.empty, .empty): return .success(acc)
        case (.empty, .cons): return .failure(.list1TooShort)
        case (.cons, .empty): return .failure(.list2TooShort)
        case (.cons(let v1, let r1), .cons(let v2, let r2)):
            return foldRight2(fn, r1, r2, acc).map { restAcc in
                fn(v1, v2, restAcc)
            }
    }
}
