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
        let list = LinkedList<Int>.empty

        let listTail = tail(list: list)

        #expect(head(list: list) == nil)
        #expect(head(list: listTail) == nil)
        #expect(length(list: list) == 0)
        #expect(isEmpty(list: list))
    }

    @Test func consListHasHeadLengthAndIsNotEmpty() {
        let list = LinkedList.cons(10, LinkedList<Int>.empty)

        #expect(head(list: list) == 10)
        #expect(length(list: list) == 1)
        #expect(!isEmpty(list: list))
    }

    @Test func consAddsValuesToTheHead() {
        let list = LinkedList.cons("second", LinkedList.cons("first", LinkedList<String>.empty))

        #expect(head(list: list) == "second")
        #expect(length(list: list) == 2)
    }

    @Test func listCanBePatternMatchedIntoHeadAndTail() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        switch list {
        case .empty:
            Issue.record("Expected cons list")
        case .cons(let value, let rest):
            #expect(value == 2)
            #expect(head(list: rest) == 1)
        }
    }

    @Test func tailReturnsRemainingListAfterHead() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

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

    @Test func nthReturnsHeadForZeroIndex() {
        let list = LinkedList.cons("second", LinkedList.cons("first", LinkedList<String>.empty))

        switch nth(n: 0, list: list) {
        case .success(let value):
            #expect(value == "second")
        case .failure(let error):
            Issue.record("Expected success, got \(error)")
        }
    }

    @Test func nthReturnsValueAtPositiveIndex() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

        switch nth(n: 2, list: list) {
        case .success(let value):
            #expect(value == 1)
        case .failure(let error):
            Issue.record("Expected success, got \(error)")
        }
    }

    @Test func nthFailsForNegativeIndex() {
        let list = LinkedList.cons(10, LinkedList<Int>.empty)

        switch nth(n: -1, list: list) {
        case .success:
            Issue.record("Expected negativeIndex failure")
        case .failure(.negativeIndex):
            break
        case .failure(let error):
            Issue.record("Expected negativeIndex failure, got \(error)")
        }
    }

    @Test func nthFailsForEmptyList() {
        let list = LinkedList<Int>.empty

        switch nth(n: 0, list: list) {
        case .success:
            Issue.record("Expected listEmpty failure")
        case .failure(.listEmpty):
            break
        case .failure(let error):
            Issue.record("Expected listEmpty failure, got \(error)")
        }
    }

    @Test func nthFailsForIndexEqualToLength() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        switch nth(n: 2, list: list) {
        case .success:
            Issue.record("Expected listTooShort failure")
        case .failure(.listTooShort):
            break
        case .failure(let error):
            Issue.record("Expected listTooShort failure, got \(error)")
        }
    }

    @Test func nthFailsForIndexGreaterThanLength() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        switch nth(n: 3, list: list) {
        case .success:
            Issue.record("Expected listTooShort failure")
        case .failure(.listTooShort):
            break
        case .failure(let error):
            Issue.record("Expected listTooShort failure, got \(error)")
        }
    }

    @Test func nthOptReturnsHeadForZeroIndex() {
        let list = LinkedList.cons("second", LinkedList.cons("first", LinkedList<String>.empty))

        #expect(nthOpt(n: 0, list: list) == "second")
    }

    @Test func nthOptReturnsValueAtPositiveIndex() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

        #expect(nthOpt(n: 2, list: list) == 1)
    }

    @Test func nthOptReturnsNilForNegativeIndex() {
        let list = LinkedList.cons(10, LinkedList<Int>.empty)

        #expect(nthOpt(n: -1, list: list) == nil)
    }

    @Test func nthOptReturnsNilForEmptyList() {
        let list = LinkedList<Int>.empty

        #expect(nthOpt(n: 0, list: list) == nil)
    }

    @Test func nthOptReturnsNilForIndexEqualToLength() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        #expect(nthOpt(n: 2, list: list) == nil)
    }

    @Test func nthOptReturnsNilForIndexGreaterThanLength() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        #expect(nthOpt(n: 3, list: list) == nil)
    }
}
