//
//  manipulationTests.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

import Testing
@testable import linked_list

struct ManipulationTests {
    private func expectList<T: Equatable>(_ list: LinkedList<T>, equals values: [T]) {
        for (index, value) in values.enumerated() {
            #expect(nthOpt(n: index, list: list) == value)
        }
        #expect(nthOpt(n: values.count, list: list) == nil)
    }

    @Test func takeReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = take(3, list)

        if case .success(let list) = result {
            #expect(isEmpty(list: list))
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeReturnsSuccessWithEmptyListForZeroCount() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = take(0, list)

        if case .success(let list) = result {
            #expect(isEmpty(list: list))
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeReturnsNegativeCountFailureForNegativeCount() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = take(-1, list)

        if case .failure(.negativeCount) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeReturnsFirstElementForCountOne() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = take(1, list)

        if case .success(let list) = result {
            expectList(list, equals: [1])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeReturnsFirstNElementsInOriginalOrder() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = take(3, list)

        if case .success(let list) = result {
            expectList(list, equals: [1, 2, 3])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeReturnsWholeListWhenCountEqualsLength() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = take(3, list)

        if case .success(let list) = result {
            expectList(list, equals: [1, 2, 3])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeReturnsWholeListWhenCountIsGreaterThanLength() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = take(5, list)

        if case .success(let list) = result {
            expectList(list, equals: [1, 2, 3])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeWorksWithNonIntegerValues() {
        let list = "apple" +| "banana" +| "cherry" +| LinkedList<String>.empty

        let result = take(2, list)

        if case .success(let list) = result {
            expectList(list, equals: ["apple", "banana"])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = take(2, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func takeOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "cherry" +| LinkedList<String>.empty

        let result = list |> takeOf(2)

        if case .success(let list) = result {
            expectList(list, equals: ["apple", "banana"])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = drop(3, list)

        if case .success(let list) = result {
            #expect(isEmpty(list: list))
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropReturnsWholeListForZeroCount() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = drop(0, list)

        if case .success(let list) = result {
            expectList(list, equals: [1, 2, 3])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropReturnsNegativeCountFailureForNegativeCount() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = drop(-1, list)

        if case .failure(.negativeCount) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropRemovesFirstElementForCountOne() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = drop(1, list)

        if case .success(let list) = result {
            expectList(list, equals: [2, 3])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropReturnsSuffixAfterFirstNElements() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = drop(2, list)

        if case .success(let list) = result {
            expectList(list, equals: [3, 4])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropReturnsEmptyListWhenCountEqualsLength() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = drop(3, list)

        if case .success(let list) = result {
            #expect(isEmpty(list: list))
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropReturnsEmptyListWhenCountIsGreaterThanLength() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = drop(5, list)

        if case .success(let list) = result {
            #expect(isEmpty(list: list))
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropWorksWithNonIntegerValues() {
        let list = "apple" +| "banana" +| "cherry" +| LinkedList<String>.empty

        let result = drop(1, list)

        if case .success(let list) = result {
            expectList(list, equals: ["banana", "cherry"])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func dropDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = drop(2, list)

        #expect(nthOpt(n: 0, list: list) == 1)
        #expect(nthOpt(n: 1, list: list) == 2)
        #expect(nthOpt(n: 2, list: list) == 3)
    }

    @Test func dropOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "cherry" +| LinkedList<String>.empty

        let result = list |> dropOf(2)

        if case .success(let list) = result {
            expectList(list, equals: ["cherry"])
        } else {
            #expect(Bool(false))
        }
    }

    @Test func takeWhileReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = takeWhile({ _ in
            callCount += 1
            return true
        }, list)

        #expect(isEmpty(list: result))
        #expect(callCount == 0)
    }

    @Test func takeWhileReturnsEmptyListWhenFirstElementDoesNotMatch() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = takeWhile({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(isEmpty(list: result))
    }

    @Test func takeWhileReturnsMatchingPrefixInOriginalOrder() {
        let list = 2 +| 4 +| 6 +| 7 +| 8 +| LinkedList<Int>.empty

        let result = takeWhile({ value in
            value.isMultiple(of: 2)
        }, list)

        expectList(result, equals: [2, 4, 6])
    }

    @Test func takeWhileReturnsWholeListWhenEveryElementMatches() {
        let list = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = takeWhile({ value in
            value.isMultiple(of: 2)
        }, list)

        expectList(result, equals: [2, 4, 6])
    }

    @Test func takeWhileStopsCheckingAfterFirstNonMatchingElement() {
        let list = 2 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = takeWhile({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        expectList(result, equals: [2, 4])
        #expect(checkedValues == [2, 4, 5])
    }

    @Test func takeWhileWorksWithNonIntegerValues() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = takeWhile({ value in
            value.hasPrefix("a")
        }, list)

        expectList(result, equals: ["apple", "apricot"])
    }

    @Test func takeWhileDoesNotChangeOriginalList() {
        let list = 2 +| 4 +| 5 +| LinkedList<Int>.empty

        _ = takeWhile({ value in value.isMultiple(of: 2) }, list)

        expectList(list, equals: [2, 4, 5])
    }

    @Test func takeWhileOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = list |> takeWhileOf { value in
            value.hasPrefix("a")
        }

        expectList(result, equals: ["apple", "apricot"])
    }

    @Test func dropWhileReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = dropWhile({ _ in
            callCount += 1
            return true
        }, list)

        #expect(isEmpty(list: result))
        #expect(callCount == 0)
    }

    @Test func dropWhileReturnsWholeListWhenFirstElementDoesNotMatch() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = dropWhile({ value in
            value.isMultiple(of: 2)
        }, list)

        expectList(result, equals: [1, 2, 3])
    }

    @Test func dropWhileReturnsSuffixStartingAtFirstNonMatchingElement() {
        let list = 2 +| 4 +| 6 +| 7 +| 8 +| LinkedList<Int>.empty

        let result = dropWhile({ value in
            value.isMultiple(of: 2)
        }, list)

        expectList(result, equals: [7, 8])
    }

    @Test func dropWhileReturnsEmptyListWhenEveryElementMatches() {
        let list = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = dropWhile({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(isEmpty(list: result))
    }

    @Test func dropWhileStopsCheckingAfterFirstNonMatchingElement() {
        let list = 2 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = dropWhile({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        expectList(result, equals: [5, 6])
        #expect(checkedValues == [2, 4, 5])
    }

    @Test func dropWhileWorksWithNonIntegerValues() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = dropWhile({ value in
            value.hasPrefix("a")
        }, list)

        expectList(result, equals: ["banana"])
    }

    @Test func dropWhileDoesNotChangeOriginalList() {
        let list = 2 +| 4 +| 5 +| LinkedList<Int>.empty

        _ = dropWhile({ value in value.isMultiple(of: 2) }, list)

        expectList(list, equals: [2, 4, 5])
    }

    @Test func dropWhileOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "apricot" +| "banana" +| LinkedList<String>.empty

        let result = list |> dropWhileOf { value in
            value.hasPrefix("a")
        }

        expectList(result, equals: ["banana"])
    }

    @Test func partitionReturnsTwoEmptyListsForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let (matching, nonMatching) = partition({ _ in
            callCount += 1
            return true
        }, list)

        #expect(isEmpty(list: matching))
        #expect(isEmpty(list: nonMatching))
        #expect(callCount == 0)
    }

    @Test func partitionSplitsMatchingAndNonMatchingElements() {
        let list = 1 +| 2 +| 3 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty

        let (matching, nonMatching) = partition({ value in
            value.isMultiple(of: 2)
        }, list)

        expectList(matching, equals: [2, 4, 6])
        expectList(nonMatching, equals: [1, 3, 5])
    }

    @Test func partitionPreservesOriginalOrderInBothLists() {
        let list = 6 +| 1 +| 4 +| 3 +| 2 +| 5 +| LinkedList<Int>.empty

        let (matching, nonMatching) = partition({ value in
            value.isMultiple(of: 2)
        }, list)

        expectList(matching, equals: [6, 4, 2])
        expectList(nonMatching, equals: [1, 3, 5])
    }

    @Test func partitionReturnsAllElementsInFirstListWhenEveryElementMatches() {
        let list = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let (matching, nonMatching) = partition({ value in
            value.isMultiple(of: 2)
        }, list)

        expectList(matching, equals: [2, 4, 6])
        #expect(isEmpty(list: nonMatching))
    }

    @Test func partitionReturnsAllElementsInSecondListWhenNoElementMatches() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let (matching, nonMatching) = partition({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(isEmpty(list: matching))
        expectList(nonMatching, equals: [1, 3, 5])
    }

    @Test func partitionCallsPredicateForEveryElement() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        _ = partition({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        #expect(checkedValues == [1, 2, 3])
    }

    @Test func partitionWorksWithNonIntegerValues() {
        let list = "apple" +| "banana" +| "apricot" +| "blueberry" +| LinkedList<String>.empty

        let (matching, nonMatching) = partition({ value in
            value.hasPrefix("a")
        }, list)

        expectList(matching, equals: ["apple", "apricot"])
        expectList(nonMatching, equals: ["banana", "blueberry"])
    }

    @Test func partitionDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = partition({ value in value.isMultiple(of: 2) }, list)

        expectList(list, equals: [1, 2, 3])
    }

    @Test func partitionOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "apricot" +| "blueberry" +| LinkedList<String>.empty

        let (matching, nonMatching) = list |> partitionOf { value in
            value.hasPrefix("b")
        }

        expectList(matching, equals: ["banana", "blueberry"])
        expectList(nonMatching, equals: ["apple", "apricot"])
    }

    @Test func partitionMapReturnsTwoEmptyListsForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let (left, right) = partitionMap({ value in
            callCount += 1
            return Either<String, Int>.left(String(value))
        }, list)

        #expect(isEmpty(list: left))
        #expect(isEmpty(list: right))
        #expect(callCount == 0)
    }

    @Test func partitionMapSplitsLeftAndRightValues() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let (left, right) = partitionMap({ value in
            value.isMultiple(of: 2)
                ? Either<String, Int>.left("even \(value)")
                : Either<String, Int>.right(value)
        }, list)

        expectList(left, equals: ["even 2", "even 4"])
        expectList(right, equals: [1, 3])
    }

    @Test func partitionMapPreservesOriginalOrderInBothLists() {
        let list = 4 +| 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (left, right) = partitionMap({ value in
            value.isMultiple(of: 2)
                ? Either<Int, Int>.left(value * 10)
                : Either<Int, Int>.right(value * 100)
        }, list)

        expectList(left, equals: [40, 20])
        expectList(right, equals: [100, 300])
    }

    @Test func partitionMapReturnsAllMappedValuesInLeftListWhenEveryElementMapsLeft() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (left, right) = partitionMap({ value in
            Either<String, Int>.left(String(value))
        }, list)

        expectList(left, equals: ["1", "2", "3"])
        #expect(isEmpty(list: right))
    }

    @Test func partitionMapReturnsAllMappedValuesInRightListWhenEveryElementMapsRight() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (left, right) = partitionMap({ value in
            Either<String, Int>.right(value * 2)
        }, list)

        #expect(isEmpty(list: left))
        expectList(right, equals: [2, 4, 6])
    }

    @Test func partitionMapCanProduceDifferentLeftAndRightTypes() {
        let list = "1" +| "two" +| "3" +| LinkedList<String>.empty

        let (left, right) = partitionMap({ value in
            if let intValue = Int(value) {
                return Either<Int, String>.left(intValue)
            }
            return Either<Int, String>.right(value.uppercased())
        }, list)

        expectList(left, equals: [1, 3])
        expectList(right, equals: ["TWO"])
    }

    @Test func partitionMapCallsFunctionForEveryElement() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        _ = partitionMap({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
                ? Either<Int, Int>.left(value)
                : Either<Int, Int>.right(value)
        }, list)

        #expect(checkedValues == [1, 2, 3])
    }

    @Test func partitionMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = partitionMap({ value in
            value.isMultiple(of: 2)
                ? Either<Int, Int>.left(value)
                : Either<Int, Int>.right(value)
        }, list)

        expectList(list, equals: [1, 2, 3])
    }

    @Test func partitionMapOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "apricot" +| "blueberry" +| LinkedList<String>.empty

        let (left, right) = list |> partitionMapOf { value in
            value.hasPrefix("a")
                ? Either<Int, String>.left(value.count)
                : Either<Int, String>.right(value.uppercased())
        }

        expectList(left, equals: [5, 7])
        expectList(right, equals: ["BANANA", "BLUEBERRY"])
    }
}
