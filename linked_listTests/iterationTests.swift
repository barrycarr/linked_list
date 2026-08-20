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

    @Test func reverseMapReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = reverseMap({ $0 * 2 }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func reverseMapTransformsEachElementInReverseOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = reverseMap({ $0 * 2 }, list)

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == 6)
        #expect(nthOpt(n: 1, list: result) == 4)
        #expect(nthOpt(n: 2, list: result) == 2)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func reverseMapCanTransformElementType() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = reverseMap({ "value-\($0)" }, list)

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == "value-3")
        #expect(nthOpt(n: 1, list: result) == "value-2")
        #expect(nthOpt(n: 2, list: result) == "value-1")
    }

    @Test func reverseMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = reverseMap({ $0 * 10 }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func reverseMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = list |> reverseMapOf { $0 + 1 }

        #expect(length(list: result) == 3)
        #expect(nthOpt(n: 0, list: result) == 4)
        #expect(nthOpt(n: 1, list: result) == 3)
        #expect(nthOpt(n: 2, list: result) == 2)
    }

    @Test func filterMapReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = filterMap({ value in value * 2 }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func filterMapReturnsEmptyListWhenAllValuesReturnNil() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = filterMap({ value in
            value.isMultiple(of: 2) ? value : nil
        }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func filterMapKeepsMappedValuesAndDropsNilValuesInOrder() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = filterMap({ value in
            value.isMultiple(of: 2) ? value * 10 : nil
        }, list)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 20)
        #expect(nthOpt(n: 1, list: result) == 40)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterMapCanTransformElementType() {
        let list = "1" +| "two" +| "3" +| LinkedList<String>.empty

        let result = filterMap({ Int($0) }, list)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 1)
        #expect(nthOpt(n: 1, list: result) == 3)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = filterMap({ value in
            value.isMultiple(of: 2) ? value : nil
        }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func filterMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = list |> filterMapOf { value in
            value > 2 ? "value-\(value)" : nil
        }

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == "value-3")
        #expect(nthOpt(n: 1, list: result) == "value-4")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterMapIReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = filterMapI({ index, value in index + value }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func filterMapIReturnsEmptyListWhenAllValuesReturnNil() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = filterMapI({ _, _ in nil as Int? }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func filterMapIKeepsMappedValuesAndDropsNilValuesInOrder() {
        let list = 10 +| 20 +| 30 +| 40 +| LinkedList<Int>.empty

        let result = filterMapI({ index, value in
            index.isMultiple(of: 2) ? index + value : nil
        }, list)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 10)
        #expect(nthOpt(n: 1, list: result) == 32)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterMapIIncrementsIndexWhenValuesAreDropped() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = filterMapI({ index, value in
            value.isMultiple(of: 2) ? index : nil
        }, list)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 1)
        #expect(nthOpt(n: 1, list: result) == 3)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterMapICanTransformElementType() {
        let list = "a" +| "" +| "c" +| LinkedList<String>.empty

        let result = filterMapI({ index, value in
            value.isEmpty ? nil : "\(index):\(value)"
        }, list)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == "0:a")
        #expect(nthOpt(n: 1, list: result) == "2:c")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterMapIDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = filterMapI({ index, value in
            index.isMultiple(of: 2) ? value : nil
        }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func filterMapIOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = list |> filterMapIOF { index, value in
            value > 2 ? "value-\(index)-\(value)" : nil
        }

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == "value-2-3")
        #expect(nthOpt(n: 1, list: result) == "value-3-4")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func concatMapReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = concatMap({ value in value +| LinkedList<Int>.empty }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func concatMapReturnsEmptyListWhenAllMappedListsAreEmpty() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = concatMap({ _ in LinkedList<Int>.empty }, list)

        #expect(isEmpty(list: result))
        #expect(length(list: result) == 0)
    }

    @Test func concatMapConcatenatesMappedListsInOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = concatMap({ value in
            value +| (value * 10) +| LinkedList<Int>.empty
        }, list)

        #expect(length(list: result) == 6)
        #expect(nthOpt(n: 0, list: result) == 1)
        #expect(nthOpt(n: 1, list: result) == 10)
        #expect(nthOpt(n: 2, list: result) == 2)
        #expect(nthOpt(n: 3, list: result) == 20)
        #expect(nthOpt(n: 4, list: result) == 3)
        #expect(nthOpt(n: 5, list: result) == 30)
        #expect(nthOpt(n: 6, list: result) == nil)
    }

    @Test func concatMapSkipsEmptyMappedLists() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = concatMap({ value in
            value.isMultiple(of: 2) ? value +| LinkedList<Int>.empty : .empty
        }, list)

        #expect(length(list: result) == 2)
        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 4)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func concatMapCanTransformElementType() {
        let list = 1 +| 2 +| LinkedList<Int>.empty

        let result = concatMap({ value in
            "value-\(value)" +| "double-\(value * 2)" +| LinkedList<String>.empty
        }, list)

        #expect(length(list: result) == 4)
        #expect(nthOpt(n: 0, list: result) == "value-1")
        #expect(nthOpt(n: 1, list: result) == "double-2")
        #expect(nthOpt(n: 2, list: result) == "value-2")
        #expect(nthOpt(n: 3, list: result) == "double-4")
        #expect(nthOpt(n: 4, list: result) == nil)
    }

    @Test func concatMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = concatMap({ value in value +| LinkedList<Int>.empty }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func concatMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| LinkedList<Int>.empty

        let result = list |> concatMapOf { value in
            value +| (value + 100) +| LinkedList<Int>.empty
        }

        #expect(length(list: result) == 4)
        #expect(nthOpt(n: 0, list: result) == 1)
        #expect(nthOpt(n: 1, list: result) == 101)
        #expect(nthOpt(n: 2, list: result) == 2)
        #expect(nthOpt(n: 3, list: result) == 102)
        #expect(nthOpt(n: 4, list: result) == nil)
    }
}
