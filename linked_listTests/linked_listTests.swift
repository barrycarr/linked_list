//
//  linked_listTests.swift
//  linked_listTests
//
//  Created by Barry Carr on 17/08/2026.
//

import Testing
@testable import linked_list

struct BasicFunctionsTests {

    @Test func emptyListHasNoHeadTailLengthAndIsEmpty() {
        let list = LinkedList<Int>.empty

        let listTail = tail(list)

        #expect(head(list) == nil)
        #expect(head(listTail) == nil)
        #expect(length(list) == 0)
        #expect(isEmpty(list))
    }

    @Test func consListHasHeadLengthAndIsNotEmpty() {
        let list = LinkedList.cons(10, LinkedList<Int>.empty)

        #expect(head(list) == 10)
        #expect(length(list) == 1)
        #expect(!isEmpty(list))
    }

    @Test func consAddsValuesToTheHead() {
        let list = LinkedList.cons("second", LinkedList.cons("first", LinkedList<String>.empty))

        #expect(head(list) == "second")
        #expect(length(list) == 2)
    }

    @Test func listCanBePatternMatchedIntoHeadAndTail() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        switch list {
        case .empty:
            Issue.record("Expected cons list")
        case .cons(let value, let rest):
            #expect(value == 2)
            #expect(head(rest) == 1)
        }
    }

    @Test func tailReturnsRemainingListAfterHead() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

        let secondNode = tail(list)
        let thirdNode = tail(secondNode)
        let emptyList = tail(thirdNode)

        #expect(head(secondNode) == 2)
        #expect(head(thirdNode) == 1)
        #expect(head(emptyList) == nil)
        #expect(length(secondNode) == 2)
        #expect(length(thirdNode) == 1)
        #expect(length(emptyList) == 0)
        #expect(isEmpty(emptyList))
    }

    @Test func nthReturnsHeadForZeroIndex() {
        let list = LinkedList.cons("second", LinkedList.cons("first", LinkedList<String>.empty))

        switch nth(0, list) {
        case .success(let value):
            #expect(value == "second")
        case .failure(let error):
            Issue.record("Expected success, got \(error)")
        }
    }

    @Test func nthReturnsValueAtPositiveIndex() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

        switch nth(2, list) {
        case .success(let value):
            #expect(value == 1)
        case .failure(let error):
            Issue.record("Expected success, got \(error)")
        }
    }

    @Test func nthFailsForNegativeIndex() {
        let list = LinkedList.cons(10, LinkedList<Int>.empty)

        switch nth(-1, list) {
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

        switch nth(0, list) {
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

        switch nth(2, list) {
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

        switch nth(3, list) {
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

        #expect(nthOpt(0, list) == "second")
    }

    @Test func nthOptReturnsValueAtPositiveIndex() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

        #expect(nthOpt(2, list) == 1)
    }

    @Test func nthOptReturnsNilForNegativeIndex() {
        let list = LinkedList.cons(10, LinkedList<Int>.empty)

        #expect(nthOpt(-1, list) == nil)
    }

    @Test func nthOptReturnsNilForEmptyList() {
        let list = LinkedList<Int>.empty

        #expect(nthOpt(0, list) == nil)
    }

    @Test func nthOptReturnsNilForIndexEqualToLength() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        #expect(nthOpt(2, list) == nil)
    }

    @Test func nthOptReturnsNilForIndexGreaterThanLength() {
        let list = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        #expect(nthOpt(3, list) == nil)
    }

    @Test func singletonCreatesOneItemList() {
        let list = singleton(42)

        #expect(head(list) == 42)
        #expect(length(list) == 1)
        #expect(head(tail(list)) == nil)
        #expect(isEmpty(tail(list)))
    }

    @Test func reverseReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let reversed = reverse(list)

        #expect(isEmpty(reversed))
        #expect(length(reversed) == 0)
    }

    @Test func reverseReturnsSameSingleItemList() {
        let list = singleton("only")

        let reversed = reverse(list)

        #expect(head(reversed) == "only")
        #expect(length(reversed) == 1)
        #expect(isEmpty(tail(reversed)))
    }

    @Test func reverseReversesMultipleItems() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

        let reversed = reverse(list)

        #expect(length(reversed) == 3)
        #expect(nthOpt(0, reversed) == 1)
        #expect(nthOpt(1, reversed) == 2)
        #expect(nthOpt(2, reversed) == 3)
        #expect(nthOpt(3, reversed) == nil)
    }

    @Test func appendReturnsSecondListWhenFirstListIsEmpty() {
        let first = LinkedList<Int>.empty
        let second = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        let result = append(first, second)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 2)
        #expect(nthOpt(1, result) == 1)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func appendReturnsFirstListWhenSecondListIsEmpty() {
        let first = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))
        let second = LinkedList<Int>.empty

        let result = append(first, second)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 2)
        #expect(nthOpt(1, result) == 1)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func appendReturnsEmptyWhenBothListsAreEmpty() {
        let result = append(LinkedList<Int>.empty, LinkedList<Int>.empty)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func appendPreservesOrderOfBothLists() {
        let first = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))
        let second = LinkedList.cons(4, LinkedList.cons(3, LinkedList<Int>.empty))

        let result = append(first, second)

        #expect(length(result) == 4)
        #expect(nthOpt(0, result) == 2)
        #expect(nthOpt(1, result) == 1)
        #expect(nthOpt(2, result) == 4)
        #expect(nthOpt(3, result) == 3)
        #expect(nthOpt(4, result) == nil)
    }

    @Test func emptyHelperReturnsList() {
        let first = 1 +| 2 +| empty()
        let second = 3 +| 4 +| empty()

        let result = first
            |> appendTo(second)
            |> reverse

        #expect(length(result) == 4)
        #expect(nthOpt(0, result) == 4)
        #expect(nthOpt(1, result) == 3)
        #expect(nthOpt(2, result) == 2)
        #expect(nthOpt(3, result) == 1)
    }

    @Test func revAppendReversesFirstListThenAppendsSecondList() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = revAppend(first, second)

        #expect(length(result) == 5)
        #expect(nthOpt(0, result) == 3)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 1)
        #expect(nthOpt(3, result) == 4)
        #expect(nthOpt(4, result) == 5)
        #expect(nthOpt(5, result) == nil)
    }

    @Test func revAppendReturnsSecondListWhenFirstListIsEmpty() {
        let first = LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = revAppend(first, second)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 4)
        #expect(nthOpt(1, result) == 5)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func revAppendReversesFirstListWhenSecondListIsEmpty() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = LinkedList<Int>.empty

        let result = revAppend(first, second)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 3)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 1)
        #expect(nthOpt(3, result) == nil)
    }

    @Test func revAppendReturnsEmptyWhenBothListsAreEmpty() {
        let result = revAppend(LinkedList<Int>.empty, LinkedList<Int>.empty)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func concatReturnsEmptyForEmptyListOfLists() {
        let lists = LinkedList<LinkedList<Int>>.empty

        let result = concat(lists)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func concatReturnsSingleNestedList() {
        let nested = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let lists = nested +| LinkedList<LinkedList<Int>>.empty

        let result = concat(lists)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 3)
        #expect(nthOpt(3, result) == nil)
    }

    @Test func concatAppendsNestedListsInOrder() {
        let first = 1 +| 2 +| LinkedList<Int>.empty
        let second = 3 +| LinkedList<Int>.empty
        let third = 4 +| 5 +| LinkedList<Int>.empty
        let lists = first +| second +| third +| LinkedList<LinkedList<Int>>.empty

        let result = concat(lists)

        #expect(length(result) == 5)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 3)
        #expect(nthOpt(3, result) == 4)
        #expect(nthOpt(4, result) == 5)
        #expect(nthOpt(5, result) == nil)
    }

    @Test func concatSkipsEmptyNestedLists() {
        let first = LinkedList<Int>.empty
        let second = 1 +| 2 +| LinkedList<Int>.empty
        let third = LinkedList<Int>.empty
        let fourth = 3 +| LinkedList<Int>.empty
        let lists = first +| second +| third +| fourth +| LinkedList<LinkedList<Int>>.empty

        let result = concat(lists)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 3)
        #expect(nthOpt(3, result) == nil)
    }
}
