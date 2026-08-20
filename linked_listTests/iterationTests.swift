//
//  iterationTests.swift
//  linked_listTests
//
//  Created by Barry Carr on 20/08/2026.
//

import Testing
@testable import linked_list

struct IterationTests {

    @Test func iterDoesNotCallFunctionForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        iter({ _ in callCount += 1 }, list)

        #expect(callCount == 0)
    }

    @Test func iterCallsFunctionForSingleElementList() {
        let list = singleton(42)
        var values: [Int] = []

        iter({ values.append($0) }, list)

        #expect(values == [42])
    }

    @Test func iterCallsFunctionForEachElementInOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var values: [Int] = []

        iter({ values.append($0) }, list)

        #expect(values == [1, 2, 3])
    }

    @Test func iterCanPerformSideEffectsWithNonIntegerValues() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty
        var result = ""

        iter({ result += $0 }, list)

        #expect(result == "abc")
    }

    @Test func iterOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var values: [Int] = []

        list |> iterOf { values.append($0) }

        #expect(values == [1, 2, 3])
    }

    @Test func iterIDoesNotCallFunctionForEmptyList() {
        let list = LinkedList<String>.empty
        var callCount = 0

        iterI({ _, _ in callCount += 1 }, list)

        #expect(callCount == 0)
    }

    @Test func iterICallsFunctionWithIndexAndValueInOrder() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty
        var pairs: [(Int, String)] = []

        iterI({ index, value in pairs.append((index, value)) }, list)

        #expect(pairs.count == 3)
        #expect(pairs[0].0 == 0)
        #expect(pairs[0].1 == "a")
        #expect(pairs[1].0 == 1)
        #expect(pairs[1].1 == "b")
        #expect(pairs[2].0 == 2)
        #expect(pairs[2].1 == "c")
    }

    @Test func iterIOfCanBeUsedWithPipeForward() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty
        var weightedSum = 0

        list |> iterIOf { index, value in
            weightedSum += index * value
        }

        #expect(weightedSum == 80)
    }

    @Test func mapReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = map({ $0 * 2 }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func mapTransformsEachElementInOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = map({ $0 * 2 }, list)

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 4)
        #expect(nthOpt(n: 2, list: result) == 6)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func mapCanTransformElementType() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = map({ "value-\($0)" }, list)

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == "value-1")
        #expect(nthOpt(n: 1, list: result) == "value-2")
        #expect(nthOpt(n: 2, list: result) == "value-3")
    }

    @Test func mapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = map({ $0 * 10 }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func mapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = list |> mapOf { $0 + 1 }

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 3)
        #expect(nthOpt(n: 2, list: result) == 4)
    }

    @Test func mapIReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = mapI({ index, value in index + value }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func mapITransformsEachElementWithIndexInOrder() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = mapI({ index, value in index + value }, list)

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == 10)
        #expect(nthOpt(n: 1, list: result) == 21)
        #expect(nthOpt(n: 2, list: result) == 32)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func mapICanTransformElementType() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty

        let result = mapI({ index, value in "\(index):\(value)" }, list)

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == "0:a")
        #expect(nthOpt(n: 1, list: result) == "1:b")
        #expect(nthOpt(n: 2, list: result) == "2:c")
    }

    @Test func mapIDoesNotChangeOriginalList() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        _ = mapI({ index, value in index + value }, list)

        #expect(nthOpt(n: 0, list: list) == 10)
        #expect(nthOpt(n: 1, list: list) == 20)
        #expect(nthOpt(n: 2, list: list) == 30)
    }

    @Test func mapIOfCanBeUsedWithPipeForward() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = list |> mapIOf { index, value in index * value }

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == 0)
        #expect(nthOpt(n: 1, list: result) == 20)
        #expect(nthOpt(n: 2, list: result) == 60)
    }
}
