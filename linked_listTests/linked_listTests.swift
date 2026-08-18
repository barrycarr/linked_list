//
//  linked_listTests.swift
//  linked_listTests
//
//  Created by Barry Carr on 17/08/2026.
//

import Testing
@testable import linked_list

struct linked_listTests {

    @Test func emptyListHasNoHeadTailLengthAndIsEmpty() {
        let list = LinkedList<Int>()

        let listTail = tail(list: list)

        #expect(head(list: list) == nil)
        #expect(head(list: listTail) == nil)
        #expect(length(list: list) == 0)
        #expect(isEmpty(list: list))
    }

    @Test func pushWithJustValueCreatesSingleItemList() {
        let list = push(value: 10)

        #expect(head(list: list) == 10)
        #expect(length(list: list) == 1)
        #expect(!isEmpty(list: list))
    }

    @Test func pushWithListAddsValuesToTheHead() {
        let list = LinkedList<String>()

        _ = push(value: "first", list: list)
        _ = push(value: "second", list: list)

        #expect(head(list: list) == "second")
        #expect(length(list: list) == 2)
    }

    @Test func tailReturnsRemainingListAfterHead() {
        let list = LinkedList<Int>()
        _ = push(value: 1, list: list)
        _ = push(value: 2, list: list)
        _ = push(value: 3, list: list)

        let secondNode = tail(list: list)
        let thirdNode = tail(list: secondNode)
        let emptyList = tail(list: thirdNode)

        #expect(head(list: secondNode) == 2)
        #expect(head(list: thirdNode) == 1)
        #expect(head(list: emptyList) == nil)
        #expect(length(list: secondNode) == 2)
        #expect(length(list: thirdNode) == 1)
        #expect(length(list: emptyList) == 0)
        #expect(isEmpty(list: emptyList))
    }

    @Test func pushWithListReturnsTheMutatedListInstance() {
        let list = LinkedList<Int>()

        let returnedList = push(value: 10, list: list)

        #expect(returnedList === list)
        #expect(head(list: returnedList) == 10)
        #expect(!isEmpty(list: returnedList))
    }
}
