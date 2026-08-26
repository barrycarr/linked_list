//
//  searchingTests.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//

import Testing
@testable import linked_list

struct SearchingTests {
    @Test func findReturnsFirstMatchingElement() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = find({ value in
            value.isMultiple(of: 2)
        }, list)

        if case .success(let value) = result {
            #expect(value == 2)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func findReturnsFirstMatchingElementWhenMultipleElementsMatch() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = find({ value in
            value.hasPrefix("a")
        }, list)

        if case .success(let value) = result {
            #expect(value == "apple")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func findReturnsNotFoundForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = find({ _ in
            callCount += 1
            return true
        }, list)

        if case .failure(.notFound) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func findReturnsNotFoundWhenNoElementMatchesPredicate() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = find({ value in
            value.isMultiple(of: 2)
        }, list)

        if case .failure(.notFound) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func findShortCircuitsAfterFirstMatch() {
        let list = 1 +| 2 +| 4 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = find({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        if case .success(let value) = result {
            #expect(value == 2)
        } else {
            #expect(Bool(false))
        }
        #expect(checkedValues == [1, 2])
    }

    @Test func findDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = find({ value in value == 2 }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func findOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> findOf { value in
            value.hasPrefix("b")
        }

        if case .success(let value) = result {
            #expect(value == "banana")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func findOptReturnsFirstMatchingElement() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = findOpt({ value in
            value > 2
        }, list)

        #expect(result == 3)
    }

    @Test func findOptReturnsFirstMatchingElementWhenMultipleElementsMatch() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = findOpt({ value in
            value.hasPrefix("a")
        }, list)

        #expect(result == "apple")
    }

    @Test func findOptReturnsNilForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = findOpt({ _ in
            callCount += 1
            return true
        }, list)

        #expect(result == nil)
        #expect(callCount == 0)
    }

    @Test func findOptReturnsNilWhenNoElementMatchesPredicate() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = findOpt({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(result == nil)
    }

    @Test func findOptShortCircuitsAfterFirstMatch() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = findOpt({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        #expect(result == 4)
        #expect(checkedValues == [1, 3, 4])
    }

    @Test func findOptOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> findOptOf { value in
            value.hasPrefix("a") && value.count == 7
        }

        #expect(result == "avocado")
    }

    @Test func findIndexReturnsZeroWhenFirstElementMatchesPredicate() {
        let list = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = findIndex({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(result == 0)
    }

    @Test func findIndexReturnsIndexOfFirstMatchingElement() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = findIndex({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(result == 2)
    }

    @Test func findIndexReturnsFirstIndexWhenMultipleElementsMatch() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = findIndex({ value in
            value.hasPrefix("a")
        }, list)

        #expect(result == 0)
    }

    @Test func findIndexReturnsNilForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = findIndex({ _ in
            callCount += 1
            return true
        }, list)

        #expect(result == nil)
        #expect(callCount == 0)
    }

    @Test func findIndexReturnsNilWhenNoElementMatchesPredicate() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = findIndex({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(result == nil)
    }

    @Test func findIndexShortCircuitsAfterFirstMatch() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = findIndex({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        #expect(result == 2)
        #expect(checkedValues == [1, 3, 4])
    }

    @Test func findIndexDoesNotChangeOriginalList() {
        let list = 1 +| 3 +| 4 +| LinkedList<Int>.empty

        _ = findIndex({ value in value.isMultiple(of: 2) }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 3)
        #expect(nthOpt(n: 2, list: list) == 4)
    }

    @Test func findIndexOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> findIndexOf { value in
            value.hasPrefix("a") && value.count == 7
        }

        #expect(result == 2)
    }

    @Test func findMapReturnsNilForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = findMap({ value in
            callCount += 1
            return String(value)
        }, list)

        #expect(result == nil)
        #expect(callCount == 0)
    }

    @Test func findMapReturnsFirstNonNilMappedValue() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = findMap({ value in
            value.isMultiple(of: 2) ? "even \(value)" : nil
        }, list)

        #expect(result == "even 4")
    }

    @Test func findMapReturnsFirstNonNilValueWhenMultipleValuesMap() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = findMap({ value in
            value.hasPrefix("a") ? value.uppercased() : nil
        }, list)

        #expect(result == "APPLE")
    }

    @Test func findMapReturnsNilWhenEveryMappedValueIsNil() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = findMap({ value in
            value.isMultiple(of: 2) ? value * 10 : nil
        }, list)

        #expect(result == nil)
    }

    @Test func findMapShortCircuitsAfterFirstNonNilMappedValue() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = findMap({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2) ? value * 10 : nil
        }, list)

        #expect(result == 40)
        #expect(checkedValues == [1, 3, 4])
    }

    @Test func findMapDoesNotChangeOriginalList() {
        let list = 1 +| 3 +| 4 +| LinkedList<Int>.empty

        _ = findMap({ value in value.isMultiple(of: 2) ? value * 10 : nil }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 3)
        #expect(nthOpt(n: 2, list: list) == 4)
    }

    @Test func findMapOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> findMapOf { value in
            value.hasPrefix("b") ? value.count : nil
        }

        #expect(result == 6)
    }

    @Test func findMapIReturnsNilForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = findMapI({ index, value in
            callCount += 1
            return index + value
        }, list)

        #expect(result == nil)
        #expect(callCount == 0)
    }

    @Test func findMapIReturnsFirstNonNilMappedValue() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = findMapI({ index, value in
            value.isMultiple(of: 2) ? "\(index):\(value)" : nil
        }, list)

        #expect(result == "2:4")
    }

    @Test func findMapIReturnsFirstNonNilValueWhenMultipleValuesMap() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = findMapI({ index, value in
            value.hasPrefix("a") ? "\(index)-\(value)" : nil
        }, list)

        #expect(result == "0-apple")
    }

    @Test func findMapIReturnsNilWhenEveryMappedValueIsNil() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = findMapI({ index, value in
            value.isMultiple(of: 2) ? index + value : nil
        }, list)

        #expect(result == nil)
    }

    @Test func findMapIPassesZeroBasedIndexToMappingFunction() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty
        var visited: [(Int, String)] = []

        let result = findMapI({ index, value in
            visited.append((index, value))
            return index == 2 ? value.uppercased() : nil
        }, list)

        #expect(result == "C")
        #expect(visited.count == 3)
        #expect(visited[0].0 == 0)
        #expect(visited[0].1 == "a")
        #expect(visited[1].0 == 1)
        #expect(visited[1].1 == "b")
        #expect(visited[2].0 == 2)
        #expect(visited[2].1 == "c")
    }

    @Test func findMapIShortCircuitsAfterFirstNonNilMappedValue() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = findMapI({ index, value in
            checkedValues.append(value)
            return value.isMultiple(of: 2) ? index : nil
        }, list)

        #expect(result == 2)
        #expect(checkedValues == [1, 3, 4])
    }

    @Test func findMapIDoesNotChangeOriginalList() {
        let list = 1 +| 3 +| 4 +| LinkedList<Int>.empty

        _ = findMapI({ index, value in value.isMultiple(of: 2) ? index + value : nil }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 3)
        #expect(nthOpt(n: 2, list: list) == 4)
    }

    @Test func findMapIOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> findMapIOf { index, value in
            value.hasPrefix("a") && value.count == 7 ? index : nil
        }

        #expect(result == 2)
    }

    @Test func filterReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = filter({ _ in
            callCount += 1
            return true
        }, list)

        #expect(isEmpty(list: result))
        #expect(callCount == 0)
    }

    @Test func filterReturnsEmptyListWhenNoElementsMatchPredicate() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = filter({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(isEmpty(list: result))
    }

    @Test func filterReturnsAllElementsWhenAllElementsMatchPredicate() {
        let list = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = filter({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 4)
        #expect(nthOpt(n: 2, list: result) == 6)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func filterKeepsMatchingElementsInOriginalOrder() {
        let list = 1 +| 2 +| 3 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty

        let result = filter({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 4)
        #expect(nthOpt(n: 2, list: result) == 6)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func filterCallsPredicateForEveryElement() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        _ = filter({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        #expect(checkedValues == [1, 2, 3])
    }

    @Test func filterWorksWithNonIntegerValues() {
        let list = "apple" +| "banana" +| "apricot" +| "blueberry" +| LinkedList<String>.empty

        let result = filter({ value in
            value.hasPrefix("a")
        }, list)

        #expect(nthOpt(n: 0, list: result) == "apple")
        #expect(nthOpt(n: 1, list: result) == "apricot")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        _ = filter({ value in value.isMultiple(of: 2) }, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
        #expect(nthOpt(n: 3, list: list) == 4)
    }

    @Test func filterOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "apricot" +| "blueberry" +| LinkedList<String>.empty

        let result = list |> filterOf { value in
            value.hasPrefix("b")
        }

        #expect(nthOpt(n: 0, list: result) == "banana")
        #expect(nthOpt(n: 1, list: result) == "blueberry")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func findAllReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = findAll({ _ in
            callCount += 1
            return true
        }, list)

        #expect(isEmpty(list: result))
        #expect(callCount == 0)
    }

    @Test func findAllReturnsAllMatchingElementsInOriginalOrder() {
        let list = 1 +| 2 +| 3 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty

        let result = findAll({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(nthOpt(n: 0, list: result) == 2)
        #expect(nthOpt(n: 1, list: result) == 4)
        #expect(nthOpt(n: 2, list: result) == 6)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func findAllReturnsEmptyListWhenNoElementsMatchPredicate() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = findAll({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(isEmpty(list: result))
    }

    @Test func findAllOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "apricot" +| "blueberry" +| LinkedList<String>.empty

        let result = list |> findAllOf { value in
            value.hasPrefix("a")
        }

        #expect(nthOpt(n: 0, list: result) == "apple")
        #expect(nthOpt(n: 1, list: result) == "apricot")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func filterIReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = filterI({ _, _ in
            callCount += 1
            return true
        }, list)

        #expect(isEmpty(list: result))
        #expect(callCount == 0)
    }

    @Test func filterIReturnsEmptyListWhenNoElementsMatchPredicate() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = filterI({ index, value in
            index + value > 10
        }, list)

        #expect(isEmpty(list: result))
    }

    @Test func filterIReturnsAllElementsWhenAllElementsMatchPredicate() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty

        let result = filterI({ index, value in
            index >= 0 && !value.isEmpty
        }, list)

        #expect(nthOpt(n: 0, list: result) == "a")
        #expect(nthOpt(n: 1, list: result) == "b")
        #expect(nthOpt(n: 2, list: result) == "c")
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func filterIKeepsMatchingElementsInOriginalOrder() {
        let list = 10 +| 20 +| 30 +| 40 +| LinkedList<Int>.empty

        let result = filterI({ index, value in
            index.isMultiple(of: 2) || value == 40
        }, list)

        #expect(nthOpt(n: 0, list: result) == 10)
        #expect(nthOpt(n: 1, list: result) == 30)
        #expect(nthOpt(n: 2, list: result) == 40)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func filterIPassesZeroBasedIndexToPredicate() {
        let list = "a" +| "b" +| "c" +| LinkedList<String>.empty
        var visited: [(Int, String)] = []

        _ = filterI({ index, value in
            visited.append((index, value))
            return index == 1
        }, list)

        #expect(visited.count == 3)
        #expect(visited[0].0 == 0)
        #expect(visited[0].1 == "a")
        #expect(visited[1].0 == 1)
        #expect(visited[1].1 == "b")
        #expect(visited[2].0 == 2)
        #expect(visited[2].1 == "c")
    }

    @Test func filterICallsPredicateForEveryElement() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        _ = filterI({ _, value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        #expect(checkedValues == [1, 2, 3])
    }

    @Test func filterIDoesNotChangeOriginalList() {
        let list = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        _ = filterI({ index, _ in index > 0 }, list)

        #expect(nthOpt(n: 0, list: list) == 10)
        #expect(nthOpt(n: 1, list: list) == 20)
        #expect(nthOpt(n: 2, list: list) == 30)
    }

    @Test func filterIOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "apricot" +| "blueberry" +| LinkedList<String>.empty

        let result = list |> filterIOf { index, value in
            index > 0 && value.hasPrefix("a")
        }

        #expect(nthOpt(n: 0, list: result) == "apricot")
        #expect(nthOpt(n: 1, list: result) == nil)
    }
}
