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

    @Test func singletonCreatesOneItemList() {
        let list = singleton(42)

        #expect(head(list: list) == 42)
        #expect(length(list: list) == 1)
        #expect(head(list: tail(list: list)) == nil)
        #expect(isEmpty(list: tail(list: list)))
    }

    @Test func reverseReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let reversed = reverse(list)

        #expect(isEmpty(list: reversed))
        #expect(length(list: reversed) == 0)
    }

    @Test func reverseReturnsSameSingleItemList() {
        let list = singleton("only")

        let reversed = reverse(list)

        #expect(head(list: reversed) == "only")
        #expect(length(list: reversed) == 1)
        #expect(isEmpty(list: tail(list: reversed)))
    }

    @Test func reverseReversesMultipleItems() {
        let list = LinkedList.cons(3, LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty)))

        let reversed = reverse(list)

        #expect(length(list: reversed) == 3)
        #expect(nthOpt(n: 0, list: reversed) == 1)
        #expect(nthOpt(n: 1, list: reversed) == 2)
        #expect(nthOpt(n: 2, list: reversed) == 3)
        #expect(nthOpt(n: 3, list: reversed) == nil)
    }

    @Test func appendReturnsSecondListWhenFirstListIsEmpty() {
        let first = LinkedList<Int>.empty
        let second = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))

        let result = append(l0: first, l1: second)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 1)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func appendReturnsFirstListWhenSecondListIsEmpty() {
        let first = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))
        let second = LinkedList<Int>.empty

        let result = append(l0: first, l1: second)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 1)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func appendReturnsEmptyWhenBothListsAreEmpty() {
        let result = append(l0: LinkedList<Int>.empty, l1: LinkedList<Int>.empty)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func appendPreservesOrderOfBothLists() {
        let first = LinkedList.cons(2, LinkedList.cons(1, LinkedList<Int>.empty))
        let second = LinkedList.cons(4, LinkedList.cons(3, LinkedList<Int>.empty))

        let result = append(l0: first, l1: second)

        #expect(length(list: result) == 4)
        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 1)
        #expect(nthOpt(n: 2, list: result) == 4)
        #expect(nthOpt(n: 3, list: result) == 3)
        #expect(nthOpt(n: 4, list: result) == nil)
    }

    @Test func consOperatorCreatesListWithRightAssociativity() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        #expect(length(list: list) == 3)
        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
        #expect(nthOpt(n: 3, list: list) == nil)
    }

    @Test func appendOperatorCombinesListsInOrder() {
        let first = 1 +| 2 +| LinkedList<Int>.empty
        let second = 3 +| 4 +| LinkedList<Int>.empty

        let result = first <> second

        #expect(length(list: result) == 4)
        #expect(nthOpt(n: 0, list: result) == 1)
        #expect(nthOpt(n: 1, list: result) == 2)
        #expect(nthOpt(n: 2, list: result) == 3)
        #expect(nthOpt(n: 3, list: result) == 4)
        #expect(nthOpt(n: 4, list: result) == nil)
    }

    @Test func pipeForwardPassesValueToUnaryFunction() {
        let result = 10
            |> { $0 + 1 }
            |> { $0 * 2 }

        #expect(result == 22)
    }

    @Test func pipeForwardCanChainListHelpers() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = list
            |> reverse
            |> { length(list: $0) }

        #expect(result == 3)
    }

    @Test func nthOfReturnsCurriedNthFunctionForList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let nthInList = nthOf(list)

        switch nthInList(1) {
        case .success(let value):
            #expect(value == 2)
        case .failure(let error):
            Issue.record("Expected success, got \(error)")
        }
    }

    @Test func nthOfOptReturnsCurriedOptionalNthFunctionForList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let nthInList = nthOfOpt(list)

        #expect(nthInList(0) == 1)
        #expect(nthInList(2) == 3)
        #expect(nthInList(3) == nil)
    }

    @Test func appendToReturnsFunctionThatAppendsSecondList() {
        let first = 1 +| 2 +| LinkedList<Int>.empty
        let second = 3 +| 4 +| LinkedList<Int>.empty

        let result = appendTo(second)(first)

        #expect(length(list: result) == 4)
        #expect(nthOpt(n: 0, list: result) == 1)
        #expect(nthOpt(n: 1, list: result) == 2)
        #expect(nthOpt(n: 2, list: result) == 3)
        #expect(nthOpt(n: 3, list: result) == 4)
    }

    @Test func appendToCanBeUsedWithPipeForward() {
        let first = 1 +| 2 +| LinkedList<Int>.empty
        let second = 3 +| 4 +| LinkedList<Int>.empty

        let result = first
            |> appendTo(second)
            |> reverse

        #expect(length(list: result) == 4)
        #expect(nthOpt(n: 0, list: result) == 4)
        #expect(nthOpt(n: 1, list: result) == 3)
        #expect(nthOpt(n: 2, list: result) == 2)
        #expect(nthOpt(n: 3, list: result) == 1)
    }
    
    @Test func emptyHelperReturnsList() {
        let first = 1 +| 2 +| empty()
        let second = 3 +| 4 +| empty()

        let result = first
            |> appendTo(second)
            |> reverse

        #expect(length(list: result) == 4)
        #expect(nthOpt(n: 0, list: result) == 4)
        #expect(nthOpt(n: 1, list: result) == 3)
        #expect(nthOpt(n: 2, list: result) == 2)
        #expect(nthOpt(n: 3, list: result) == 1)
    }

    @Test func revAppendReversesFirstListThenAppendsSecondList() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = revAppend(l0: first, l1: second)

        #expect(length(list: result) == 5)
        #expect(nthOpt(n: 0, list: result) == 3)
        #expect(nthOpt(n: 1, list: result) == 2)
        #expect(nthOpt(n: 2, list: result) == 1)
        #expect(nthOpt(n: 3, list: result) == 4)
        #expect(nthOpt(n: 4, list: result) == 5)
        #expect(nthOpt(n: 5, list: result) == nil)
    }

    @Test func revAppendReturnsSecondListWhenFirstListIsEmpty() {
        let first = LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = revAppend(l0: first, l1: second)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 4)
        #expect(nthOpt(n: 1, list: result) == 5)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func revAppendReversesFirstListWhenSecondListIsEmpty() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = LinkedList<Int>.empty

        let result = revAppend(l0: first, l1: second)

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == 3)
        #expect(nthOpt(n: 1, list: result) == 2)
        #expect(nthOpt(n: 2, list: result) == 1)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func revAppendReturnsEmptyWhenBothListsAreEmpty() {
        let result = revAppend(l0: LinkedList<Int>.empty, l1: LinkedList<Int>.empty)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func revAppendToReturnsFunctionThatReverseAppendsSecondList() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = revAppendTo(second)(first)

        #expect(length(list: result) == 5)
        #expect(nthOpt(n: 0, list: result) == 3)
        #expect(nthOpt(n: 1, list: result) == 2)
        #expect(nthOpt(n: 2, list: result) == 1)
        #expect(nthOpt(n: 3, list: result) == 4)
        #expect(nthOpt(n: 4, list: result) == 5)
    }

    @Test func revAppendToCanBeUsedWithPipeForward() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = first
            |> revAppendTo(second)
            |> { length(list: $0) }

        #expect(result == 5)
    }

}
