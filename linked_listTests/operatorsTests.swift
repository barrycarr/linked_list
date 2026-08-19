//
//  operatorsTests.swift
//  linked_listTests
//
//  Created by Barry Carr on 19/08/2026.
//

import Testing
@testable import linked_list

struct OperatorsTests {

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
