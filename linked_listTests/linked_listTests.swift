//
//  linked_listTests.swift
//  linked_listTests
//
//  Created by Barry Carr on 17/08/2026.
//

import Testing
@testable import linked_list

struct linked_listTests {

    @Test func emptyListHasNoHeadAndEmptyTail() throws {
        let list = LinkedList<Int>()

        #expect(head(list: list) == nil)

        let listTail = try #require(tail(list: list))
        #expect(head(list: listTail) == nil)
    }
    
    @Test func pushWithJustValueCreatesNewList() {
        let list = push(value: 10)
        
        #expect(head(list: list) == 10)
    }

    @Test func pushAddsValuesToTheHead() {
        let list = LinkedList<String>()

        _ = push(value: "first", list: list)
        _ = push(value: "second", list: list)

        #expect(head(list: list) == "second")
    }

    @Test func tailReturnsRemainingListAfterHead() throws {
        let list = LinkedList<Int>()
        _ = push(value: 1, list: list)
        _ = push(value: 2, list: list)
        _ = push(value: 3, list: list)

        let secondNode = try #require(tail(list: list))
        let thirdNode = try #require(tail(list: secondNode))
        let emptyList = try #require(tail(list: thirdNode))

        #expect(head(list: secondNode) == 2)
        #expect(head(list: thirdNode) == 1)
        #expect(head(list: emptyList) == nil)
    }

    @Test func pushReturnsTheMutatedListInstance() {
        let list = LinkedList<Int>()

        let returnedList = push(value:10, list: list)

        #expect(returnedList === list)
        #expect(head(list: returnedList) == 10)
    }
}
