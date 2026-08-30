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

        #expect(length(list) == 3)
        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
        #expect(nthOpt(3, list) == nil)
    }

    @Test func appendOperatorCombinesListsInOrder() {
        let first = 1 +| 2 +| LinkedList<Int>.empty
        let second = 3 +| 4 +| LinkedList<Int>.empty

        let result = first <> second

        #expect(length(result) == 4)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 3)
        #expect(nthOpt(3, result) == 4)
        #expect(nthOpt(4, result) == nil)
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
            |> { length($0) }

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

        #expect(length(result) == 4)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 3)
        #expect(nthOpt(3, result) == 4)
    }

    @Test func appendToCanBeUsedWithPipeForward() {
        let first = 1 +| 2 +| LinkedList<Int>.empty
        let second = 3 +| 4 +| LinkedList<Int>.empty

        let result = first
            |> appendTo(second)
            |> reverse

        #expect(length(result) == 4)
        #expect(nthOpt(0, result) == 4)
        #expect(nthOpt(1, result) == 3)
        #expect(nthOpt(2, result) == 2)
        #expect(nthOpt(3, result) == 1)
    }

    @Test func revAppendToReturnsFunctionThatReverseAppendsSecondList() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = revAppendTo(second)(first)

        #expect(length(result) == 5)
        #expect(nthOpt(0, result) == 3)
        #expect(nthOpt(1, result) == 2)
        #expect(nthOpt(2, result) == 1)
        #expect(nthOpt(3, result) == 4)
        #expect(nthOpt(4, result) == 5)
    }

    @Test func revAppendToCanBeUsedWithPipeForward() {
        let first = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let second = 4 +| 5 +| LinkedList<Int>.empty

        let result = first
            |> revAppendTo(second)
            |> { length($0) }

        #expect(result == 5)
    }
}
