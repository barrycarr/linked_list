//
//  linked_list.swift
//  linked_list
//
//  Created by Barry Carr on 17/08/2026.
//

import Foundation

class LinkedList<T> {
    fileprivate var head: Node<T>?
    init() {
        self.head = nil
    }

    fileprivate init(head: Node<T>?) {
        self.head = head
    }
}

fileprivate class Node<T> {
    let value: T
    var next: Node?
    init(value: T) {
        self.value = value
        self.next = nil
    }
}

func push<T>(value: T) -> LinkedList<T> {
    let node = Node(value: value)
    return LinkedList<T>(head: node)
}

func push<T>(value: T, list: LinkedList<T>) -> LinkedList<T> {
    let node = Node(value: value)
    node.next = list.head
    list.head = node
    return list
}

func head<T>(list: LinkedList<T>) -> T? {
    if let head = list.head {
        return head.value
    }
    return nil
}

func tail<T>(list: LinkedList<T>) -> LinkedList<T> {
    if list.head == nil {
        return LinkedList<T>()
    }
    return LinkedList<T>(head: list.head?.next)
}

func length<T>(list: LinkedList<T>) -> Int {
    if list.head == nil {
        return 0
    }
    return 1 + length(list: tail(list: list))
}

func isEmpty<T>(list: LinkedList<T>) -> Bool {
    return list.head == nil
}
