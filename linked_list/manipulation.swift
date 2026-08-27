//
//  manipulation.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

public typealias ListPartitionMap<T, L, R> = (T) -> Either<L, R>

public func take<T>(_ n: Int, _ list: LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    guard n >= 0 else {
        return .failure(.negativeCount)
    }
    
    func doTake(_ list: LinkedList<T>, _ res: LinkedList<T>, _ count: Int) -> Result<LinkedList<T>, LinkedListError> {
        switch list {
            case .empty: return .success(reverse(res))
            case .cons(let val, let rest):
                if count == n {
                    return .success(reverse(res))
                }
                return doTake(rest, val +| res, count + 1)
        }
    }
    
    return doTake(list, LinkedList<T>.empty, 0)
}

public func takeOf<T>(_ n: Int) -> (LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    { take(n, $0) }
}


public func drop<T>(_ n: Int, _ list: LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    guard n >= 0 else {
        return .failure(.negativeCount)
    }
    
    func doDrop(_ list: LinkedList<T>, _ count: Int) -> Result<LinkedList<T>, LinkedListError> {
        if count == 0 {
            return .success(list)
        }
        
        switch list {
            case .empty: return .success(.empty)
            case .cons(_, let rest): return doDrop(rest, count - 1)
        }
    }
    
    return doDrop(list, n)
}

public func dropOf<T>(_ n: Int) -> (LinkedList<T>) -> Result<LinkedList<T>, LinkedListError> {
    { drop(n, $0) }
}

public func takeWhile<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    func doTakeWhile(_ list: LinkedList<T>, _ res: LinkedList<T>) -> LinkedList<T> {
        switch list {
            case .empty: return reverse(res)
            case .cons(let val, let rest):
                if fn(val) {
                    return doTakeWhile(rest, val +| res)
                }
                return reverse(res)
        }
    }
    
    return doTakeWhile(list, LinkedList<T>.empty)
}

public func takeWhileOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { takeWhile(fn, $0) }
}

public func dropWhile<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> LinkedList<T> {
    switch list {
        case .empty: return .empty
        case .cons(let val, let rest):
            if !fn(val) {
               return list
            }
            return dropWhile(fn, rest)
    }
}

public func dropWhileOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> LinkedList<T> {
    { dropWhile(fn, $0)}
}

public func partition<T>(_ fn: ListPredicate<T>, _ list: LinkedList<T>) -> (LinkedList<T>, LinkedList<T>) {
    func doPartition(_ list: LinkedList<T>, _ a: LinkedList<T>, _ b: LinkedList<T>) -> (LinkedList<T>, LinkedList<T>) {
        switch list {
            case .empty: return (reverse(a), reverse(b))
            case .cons(let val, let rest):
                if fn(val) {
                    return doPartition(rest, val +| a, b)
                }
                return doPartition(rest, a, val +| b)
        }
    }
    
    return doPartition(list, LinkedList<T>.empty, LinkedList<T>.empty)
}

public func partitionOf<T>(_ fn: @escaping ListPredicate<T>) -> (LinkedList<T>) -> (LinkedList<T>, LinkedList<T>) {
    { partition(fn, $0) }
}

public func partitionMap<T, L, R>(
    _ fn: ListPartitionMap<T, L, R>,
    _ list: LinkedList<T>) -> (LinkedList<L>, LinkedList<R>) {
    func doPartitionMap(_ list: LinkedList<T>, _ l: LinkedList<L>, _ r: LinkedList<R>) -> (LinkedList<L>, LinkedList<R>) {
        switch list {
            case .empty: return (reverse(l), reverse(r))
            case .cons(let val, let rest):
                switch fn(val) {
                    case .left(let lval) : return doPartitionMap(rest, lval +| l, r)
                    case .right(let rval) : return doPartitionMap(rest, l, rval +| r)
                }
        }
    }
        
    return doPartitionMap(list, LinkedList<L>.empty, LinkedList<R>.empty)
}

public func partitionMapOf<T, L, R>(
    _ fn: @escaping ListPartitionMap<T, L, R>
) -> (LinkedList<T>) -> (LinkedList<L>, LinkedList<R>) {
    { partitionMap(fn, $0) }
}
