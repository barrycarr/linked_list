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

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func mapTransformsEachElementInOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = map({ $0 * 2 }, list)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 2)
        #expect(nthOpt(1, result) == 4)
        #expect(nthOpt(2, result) == 6)
        #expect(nthOpt(3, result) == nil)
    }

    @Test func mapCanTransformElementType() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = map({ "value-\($0)" }, list)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == "value-1")
        #expect(nthOpt(1, result) == "value-2")
        #expect(nthOpt(2, result) == "value-3")
    }

    @Test func mapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = map({ $0 * 10 }, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func mapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = list |> mapOf { $0 + 1 }

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 2)
        #expect(nthOpt(1, result) == 3)
        #expect(nthOpt(2, result) == 4)
    }

    @Test func mapIReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = mapI({ index, value in index + value }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func mapITransformsEachElementWithIndexInOrder() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = mapI({ index, value in index + value }, list)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 10)
        #expect(nthOpt(1, result) == 21)
        #expect(nthOpt(2, result) == 32)
        #expect(nthOpt(3, result) == nil)
    }

    @Test func mapICanTransformElementType() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty

        let result = mapI({ index, value in "\(index):\(value)" }, list)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == "0:a")
        #expect(nthOpt(1, result) == "1:b")
        #expect(nthOpt(2, result) == "2:c")
    }

    @Test func mapIDoesNotChangeOriginalList() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        _ = mapI({ index, value in index + value }, list)

        #expect(nthOpt(0, list) == 10)
        #expect(nthOpt(1, list) == 20)
        #expect(nthOpt(2, list) == 30)
    }

    @Test func mapIOfCanBeUsedWithPipeForward() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = list |> mapIOf { index, value in index * value }

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 0)
        #expect(nthOpt(1, result) == 20)
        #expect(nthOpt(2, result) == 60)
    }

    @Test func reverseMapReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = reverseMap({ $0 * 2 }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func reverseMapTransformsEachElementInReverseOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = reverseMap({ $0 * 2 }, list)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 6)
        #expect(nthOpt(1, result) == 4)
        #expect(nthOpt(2, result) == 2)
        #expect(nthOpt(3, result) == nil)
    }

    @Test func reverseMapCanTransformElementType() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = reverseMap({ "value-\($0)" }, list)

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == "value-3")
        #expect(nthOpt(1, result) == "value-2")
        #expect(nthOpt(2, result) == "value-1")
    }

    @Test func reverseMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = reverseMap({ $0 * 10 }, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func reverseMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = list |> reverseMapOf { $0 + 1 }

        #expect(length(result) == 3)
        #expect(nthOpt(0, result) == 4)
        #expect(nthOpt(1, result) == 3)
        #expect(nthOpt(2, result) == 2)
    }

    @Test func filterMapReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = filterMap({ value in value * 2 }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func filterMapReturnsEmptyListWhenAllValuesReturnNil() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = filterMap({ value in
            value.isMultiple(of: 2) ? value : nil
        }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func filterMapKeepsMappedValuesAndDropsNilValuesInOrder() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = filterMap({ value in
            value.isMultiple(of: 2) ? value * 10 : nil
        }, list)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 20)
        #expect(nthOpt(1, result) == 40)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func filterMapCanTransformElementType() {
        let list = "1" +| "two" +| "3" +| LinkedList<String>.empty

        let result = filterMap({ Int($0) }, list)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 3)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func filterMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = filterMap({ value in
            value.isMultiple(of: 2) ? value : nil
        }, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func filterMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = list |> filterMapOf { value in
            value > 2 ? "value-\(value)" : nil
        }

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == "value-3")
        #expect(nthOpt(1, result) == "value-4")
        #expect(nthOpt(2, result) == nil)
    }

    @Test func filterMapIReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = filterMapI({ index, value in index + value }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func filterMapIReturnsEmptyListWhenAllValuesReturnNil() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = filterMapI({ _, _ in nil as Int? }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func filterMapIKeepsMappedValuesAndDropsNilValuesInOrder() {
        let list = 10 +| 20 +| 30 +| 40 +| LinkedList<Int>.empty

        let result = filterMapI({ index, value in
            index.isMultiple(of: 2) ? index + value : nil
        }, list)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 10)
        #expect(nthOpt(1, result) == 32)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func filterMapIIncrementsIndexWhenValuesAreDropped() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = filterMapI({ index, value in
            value.isMultiple(of: 2) ? index : nil
        }, list)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 3)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func filterMapICanTransformElementType() {
        let list = "a" +| "" +| "c" +| LinkedList<String>.empty

        let result = filterMapI({ index, value in
            value.isEmpty ? nil : "\(index):\(value)"
        }, list)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == "0:a")
        #expect(nthOpt(1, result) == "2:c")
        #expect(nthOpt(2, result) == nil)
    }

    @Test func filterMapIDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = filterMapI({ index, value in
            index.isMultiple(of: 2) ? value : nil
        }, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func filterMapIOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = list |> filterMapIOf { index, value in
            value > 2 ? "value-\(index)-\(value)" : nil
        }

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == "value-2-3")
        #expect(nthOpt(1, result) == "value-3-4")
        #expect(nthOpt(2, result) == nil)
    }

    @Test func concatMapReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = concatMap({ value in value +| LinkedList<Int>.empty }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func concatMapReturnsEmptyListWhenAllMappedListsAreEmpty() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = concatMap({ _ in LinkedList<Int>.empty }, list)

        #expect(isEmpty(result))
        #expect(length(result) == 0)
    }

    @Test func concatMapConcatenatesMappedListsInOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = concatMap({ value in
            value +| (value * 10) +| LinkedList<Int>.empty
        }, list)

        #expect(length(result) == 6)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 10)
        #expect(nthOpt(2, result) == 2)
        #expect(nthOpt(3, result) == 20)
        #expect(nthOpt(4, result) == 3)
        #expect(nthOpt(5, result) == 30)
        #expect(nthOpt(6, result) == nil)
    }

    @Test func concatMapSkipsEmptyMappedLists() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = concatMap({ value in
            value.isMultiple(of: 2) ? value +| LinkedList<Int>.empty : .empty
        }, list)

        #expect(length(result) == 2)
        #expect(nthOpt(0, result) == 2)
        #expect(nthOpt(1, result) == 4)
        #expect(nthOpt(2, result) == nil)
    }

    @Test func concatMapCanTransformElementType() {
        let list = 1 +| 2 +| LinkedList<Int>.empty

        let result = concatMap({ value in
            "value-\(value)" +| "double-\(value * 2)" +| LinkedList<String>.empty
        }, list)

        #expect(length(result) == 4)
        #expect(nthOpt(0, result) == "value-1")
        #expect(nthOpt(1, result) == "double-2")
        #expect(nthOpt(2, result) == "value-2")
        #expect(nthOpt(3, result) == "double-4")
        #expect(nthOpt(4, result) == nil)
    }

    @Test func concatMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = concatMap({ value in value +| LinkedList<Int>.empty }, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func concatMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| LinkedList<Int>.empty

        let result = list |> concatMapOf { value in
            value +| (value + 100) +| LinkedList<Int>.empty
        }

        #expect(length(result) == 4)
        #expect(nthOpt(0, result) == 1)
        #expect(nthOpt(1, result) == 101)
        #expect(nthOpt(2, result) == 2)
        #expect(nthOpt(3, result) == 102)
        #expect(nthOpt(4, result) == nil)
    }

    @Test func foldLeftReturnsAccumulatorForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = foldLeft({ acc, value in
            callCount += 1
            return acc + value
        }, 42, list)

        #expect(result == 42)
        #expect(callCount == 0)
    }

    @Test func foldLeftCombinesValuesFromLeftToRight() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = foldLeft({ acc, value in
            acc - value
        }, 0, list)

        #expect(result == -6)
    }

    @Test func foldLeftThreadsAccumulatorThroughEachStep() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty

        let result = foldLeft({ acc, value in
            acc + "[\(value)]"
        }, "", list)

        #expect(result == "[a][b][c]")
    }

    @Test func foldLeftCanReturnDifferentTypeThanListElement() {
        let list = "one" +| "three" +| "seven" +| LinkedList<String>.empty

        let result = foldLeft({ acc, value in
            acc + value.count
        }, 0, list)

        #expect(result == 13)
    }

    @Test func foldLeftDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = foldLeft({ acc, value in acc + value }, 0, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func foldLeftOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = list |> foldLeftOf({ acc, value in
            acc + value
        }, 10)

        #expect(result == 16)
    }

    @Test func foldLeftMapReturnsAccumulatorAndEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let (acc, mapped) = foldLeftMap({ acc, value in
            callCount += 1
            return (acc + value, value * 2)
        }, 42, list)

        #expect(acc == 42)
        #expect(isEmpty(mapped))
        #expect(length(mapped) == 0)
        #expect(callCount == 0)
    }

    @Test func foldLeftMapThreadsAccumulatorFromLeftToRight() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (acc, mapped) = foldLeftMap({ acc, value in
            let newAcc = acc - value
            return (newAcc, newAcc)
        }, 0, list)

        #expect(acc == -6)
        #expect(length(mapped) == 3)
        #expect(nthOpt(0, mapped) == -1)
        #expect(nthOpt(1, mapped) == -3)
        #expect(nthOpt(2, mapped) == -6)
        #expect(nthOpt(3, mapped) == nil)
    }

    @Test func foldLeftMapKeepsMappedValuesInOriginalOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (acc, mapped) = foldLeftMap({ acc, value in
            (acc + value, value * 10)
        }, 0, list)

        #expect(acc == 6)
        #expect(length(mapped) == 3)
        #expect(nthOpt(0, mapped) == 10)
        #expect(nthOpt(1, mapped) == 20)
        #expect(nthOpt(2, mapped) == 30)
        #expect(nthOpt(3, mapped) == nil)
    }

    @Test func foldLeftMapCanReturnDifferentMappedType() {
        let list = "a" +| "bb" +| "ccc" +| LinkedList<String>.empty

        let (acc, mapped) = foldLeftMap({ acc, value in
            (acc + value.count, "\(acc):\(value)")
        }, 0, list)

        #expect(acc == 6)
        #expect(length(mapped) == 3)
        #expect(nthOpt(0, mapped) == "0:a")
        #expect(nthOpt(1, mapped) == "1:bb")
        #expect(nthOpt(2, mapped) == "3:ccc")
        #expect(nthOpt(3, mapped) == nil)
    }

    @Test func foldLeftMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = foldLeftMap({ acc, value in
            (acc + value, value * 2)
        }, 0, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func foldLeftMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (acc, mapped) = list |> foldLeftMapOf({ acc, value in
            (acc + value, "value-\(value)")
        }, 10)

        #expect(acc == 16)
        #expect(length(mapped) == 3)
        #expect(nthOpt(0,mapped) == "value-1")
        #expect(nthOpt(1, mapped) == "value-2")
        #expect(nthOpt(2, mapped) == "value-3")
        #expect(nthOpt(3, mapped) == nil)
    }

    @Test func foldRightReturnsAccumulatorForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = foldRight({ value, acc in
            callCount += 1
            return value + acc
        }, list, 42)

        #expect(result == 42)
        #expect(callCount == 0)
    }

    @Test func foldRightCombinesValuesFromRightToLeft() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = foldRight({ value, acc in
            value - acc
        }, list, 0)

        #expect(result == 2)
    }

    @Test func foldRightThreadsAccumulatorThroughEachStep() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty

        let result = foldRight({ value, acc in
            "(\(value)\(acc))"
        }, list, "")

        #expect(result == "(a(b(c)))")
    }

    @Test func foldRightCanReturnDifferentTypeThanListElement() {
        let list = "one" +| "three" +| "seven" +| LinkedList<String>.empty

        let result = foldRight({ value, acc in
            value.count + acc
        }, list, 0)

        #expect(result == 13)
    }

    @Test func foldRightDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = foldRight({ value, acc in value + acc }, list, 0)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }

    @Test func foldRightOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = list |> foldRightOf({ value, acc in
            value - acc
        }, 0)

        #expect(result == 2)
    }
}
