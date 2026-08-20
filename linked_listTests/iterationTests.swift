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
}
