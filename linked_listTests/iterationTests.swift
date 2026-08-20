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
}
