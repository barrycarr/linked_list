//
//  pairs.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

public typealias ListSplitMap<T,U,V> = (T) -> (U, V)

public func split<T,U>(_ list: LinkedList<(T,U)>) -> (LinkedList<T>, LinkedList<U>) {
    func doSplit( _ list: LinkedList<(T,U)>, _ t: LinkedList<T>, _ u: LinkedList<U>) -> (LinkedList<T>, LinkedList<U>) {
        switch list {
            case .empty: return (reverse(t), reverse(u))
            case .cons(let val, let rest):
                return doSplit(rest, val.0 +| t, val.1 +| u)
        }
    }
    
    return doSplit(list, LinkedList<T>.empty, LinkedList<U>.empty)
}

public func splitMap<T,U,V>(_ fn: ListSplitMap<T,U,V>, _ list: LinkedList<T>) -> (LinkedList<U>, LinkedList<V>) {
    func doSplitMap(_ list: LinkedList<T>, _ u: LinkedList<U>, _ v: LinkedList<V>) -> (LinkedList<U>, LinkedList<V>) {
        switch list {
            case .empty: return (reverse(u), reverse(v))
            case .cons(let val, let rest):
                let (u1, v1) = fn(val)
                return doSplitMap(rest, u1 +| u, v1 +| v)
        }
    }
    
    return doSplitMap(list, LinkedList<U>.empty, LinkedList<V>.empty)
}

public func splitMapOf<T,U,V>(_ fn: @escaping ListSplitMap<T,U,V>) -> (LinkedList<T>) -> (LinkedList<U>, LinkedList<V>) {
    {list in splitMap(fn, list)}
}

public func combine<T,U>(_ t: LinkedList<T>, _ u: LinkedList<U>) -> Result<LinkedList<(T,U)>, LinkedListError> {
    func doCombine(
        _ t: LinkedList<T>,
        _ u: LinkedList<U>,
        _ res: LinkedList<(T,U)>) -> Result<LinkedList<(T,U)>, LinkedListError> {
        switch (t, u) {
            case (.empty, .empty): return .success(reverse(res))
            case (.empty, .cons): return .failure(.list1TooShort)
            case (.cons, .empty): return .failure(.list2TooShort)
            case (.cons(let tVal, let tRest), .cons(let uVal, let uRest)):
                let newVal = (tVal, uVal)
                return doCombine(tRest, uRest, newVal +| res)
        }
    }
    
    return doCombine(t, u, .empty)
}
