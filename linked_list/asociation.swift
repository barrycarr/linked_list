//
//  asociation.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//
public func assocOpt<K: Equatable,V>(_ key: K, _ list: LinkedList<(K,V)>) -> V? {
    switch list {
        case .empty: return nil
        case .cons(let val, let rest):
            if val.0 == key {
                return val.1
            } else {
                return assocOpt(key, rest)
            }
    }
}

public func assocOptOf<K: Equatable, V>(_ key: K) -> (LinkedList<(K,V)>) -> V? {
    { list in assocOpt(key, list) }
}

public func assoc<K: Equatable, V>(_ key: K, _ list: LinkedList<(K,V)>) -> Result<V, LinkedListError> {
    if let val = assocOpt(key, list) {
        return .success(val)
    }
    return .failure(.notFound)
}

public func assocOf<K: Equatable, V>(_ key: K) -> (LinkedList<(K,V)>) -> Result<V, LinkedListError> {
    { list in assoc(key, list) }
}

public func assqOpt<K: AnyObject, V>(_ key: K, _ list: LinkedList<(K,V)>) -> V? {
    switch list {
        case .empty: return nil
        case .cons(let val, let rest):
            if val.0 === key {
                return val.1
            } else {
                return assqOpt(key, rest)
            }
    }
}

public func assqOptOf<K: AnyObject, V>(_ key: K) -> (LinkedList<(K,V)>) -> V? {
    { list in assqOpt(key, list) }
}

public func assq<K: AnyObject, V>(_ key: K, _ list: LinkedList<(K,V)>) -> Result<V, LinkedListError> {
    if let val = assqOpt(key, list) {
        return .success(val)
    }
    return .failure(.notFound)
}

public func assqOf<K: AnyObject, V>(_ key: K) -> (LinkedList<(K,V)>) -> Result<V, LinkedListError> {
    { list in assq(key, list) }
}

public func memAssoc<K: Equatable,V>(_ key: K, _ list: LinkedList<(K,V)>) -> Bool {
    (assocOpt(key, list) != nil)
}

public func memAssocOf<K: Equatable, V>(_ key: K) -> (LinkedList<(K,V)>) -> Bool {
    { list in memAssoc(key, list) }
}

public func memAssq<K: AnyObject,V>(_ key: K, _ list: LinkedList<(K,V)>) -> Bool {
    (assqOpt(key, list) != nil)
}

public func memAssqOf<K: AnyObject, V>(_ key: K) -> (LinkedList<(K,V)>) -> Bool {
    {list in memAssq(key, list)}
}

public func removeAssoc<K: Equatable,V>(_ key: K, _ list: LinkedList<(K,V)>) -> LinkedList<(K,V)> {
    func doRemoveAssoc(_ list: LinkedList<(K,V)>, _ res: LinkedList<(K,V)>) -> LinkedList<(K,V)> {
        switch list {
            case .empty: return reverse(res)
            case .cons(let val, let rest):
                if val.0 == key {
                    return revAppend(l0: res, l1: rest)
                }
                return doRemoveAssoc(rest, val +| res)
        }
    }
        
    return doRemoveAssoc(list, LinkedList<(K,V)>.empty)
}

public func removeAssocOf<K: Equatable, V>(_ key: K) -> (LinkedList<(K,V)>) -> LinkedList<(K,V)> {
    { list in removeAssoc(key, list) }
}

public func removeAssq<K: AnyObject,V>(_ key: K, _ list: LinkedList<(K,V)>) -> LinkedList<(K,V)> {
    func doRemoveAssq(_ list: LinkedList<(K,V)>, _ res: LinkedList<(K,V)>) -> LinkedList<(K,V)> {
        switch list {
            case .empty: return reverse(res)
            case .cons(let val, let rest):
                if val.0 === key {
                    return revAppend(l0: res, l1: rest)
                }
                return doRemoveAssq(rest, val +| res)
        }
    }
        
    return doRemoveAssq(list, LinkedList<(K,V)>.empty)
}

public func removeAssqOf<K: AnyObject, V>(_ key: K) -> (LinkedList<(K,V)>) -> LinkedList<(K,V)> {
    { list in removeAssq(key, list) }
}
