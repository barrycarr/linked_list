//
//  pairsTests.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

import Testing
@testable import linked_list

struct PairsTests {
    private func expectList<T: Equatable>(_ list: LinkedList<T>, equals values: [T]) {
        for (index, value) in values.enumerated() {
            #expect(nthOpt(n: index, list: list) == value)
        }
        #expect(nthOpt(n: values.count, list: list) == nil)
    }

    @Test func splitReturnsTwoEmptyListsForEmptyList() {
        let list = LinkedList<(Int, String)>.empty

        let (left, right) = split(list)

        #expect(isEmpty(list: left))
        #expect(isEmpty(list: right))
    }

    @Test func splitSeparatesPairElementsInOriginalOrder() {
        let list = (1, "one") +| (2, "two") +| (3, "three") +| LinkedList<(Int, String)>.empty

        let (left, right) = split(list)

        expectList(left, equals: [1, 2, 3])
        expectList(right, equals: ["one", "two", "three"])
    }

    @Test func splitWorksWithDifferentElementTypes() {
        let list = ("one", true) +| ("two", false) +| LinkedList<(String, Bool)>.empty

        let (left, right) = split(list)

        expectList(left, equals: ["one", "two"])
        expectList(right, equals: [true, false])
    }

    @Test func splitDoesNotChangeOriginalList() {
        let list = (1, "one") +| (2, "two") +| LinkedList<(Int, String)>.empty

        _ = split(list)

        #expect(nthOpt(n: 0, list: list)?.0 == 1)
        #expect(nthOpt(n: 0, list: list)?.1 == "one")
        #expect(nthOpt(n: 1, list: list)?.0 == 2)
        #expect(nthOpt(n: 1, list: list)?.1 == "two")
        #expect(nthOpt(n: 2, list: list) == nil)
    }

    @Test func splitMapReturnsTwoEmptyListsForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let (left, right) = splitMap({ value in
            callCount += 1
            return (value, String(value))
        }, list)

        #expect(isEmpty(list: left))
        #expect(isEmpty(list: right))
        #expect(callCount == 0)
    }

    @Test func splitMapMapsElementsIntoTwoListsInOriginalOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (left, right) = splitMap({ value in
            (value * 2, "value \(value)")
        }, list)

        expectList(left, equals: [2, 4, 6])
        expectList(right, equals: ["value 1", "value 2", "value 3"])
    }

    @Test func splitMapCanProduceDifferentOutputTypes() {
        let list = "1" +| "22" +| "333" +| LinkedList<String>.empty

        let (left, right) = splitMap({ value in
            (value.count, value.uppercased())
        }, list)

        expectList(left, equals: [1, 2, 3])
        expectList(right, equals: ["1", "22", "333"])
    }

    @Test func splitMapCallsFunctionForEveryElement() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        _ = splitMap({ value in
            checkedValues.append(value)
            return (value, value)
        }, list)

        #expect(checkedValues == [1, 2, 3])
    }

    @Test func splitMapDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = splitMap({ value in (value, String(value)) }, list)

        expectList(list, equals: [1, 2, 3])
    }

    @Test func splitMapOfCanBeUsedWithPipeForward() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let (left, right) = list |> splitMapOf { value in
            (value * 10, String(value))
        }

        expectList(left, equals: [10, 20, 30])
        expectList(right, equals: ["1", "2", "3"])
    }

    @Test func combineReturnsEmptyListForTwoEmptyLists() {
        let left = LinkedList<Int>.empty
        let right = LinkedList<String>.empty

        let result = combine(left, right)

        if case .success(let list) = result {
            #expect(isEmpty(list: list))
        } else {
            #expect(Bool(false))
        }
    }

    @Test func combinePairsElementsInOriginalOrder() {
        let left = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let right = "one" +| "two" +| "three" +| LinkedList<String>.empty

        let result = combine(left, right)

        if case .success(let list) = result {
            #expect(nthOpt(n: 0, list: list)?.0 == 1)
            #expect(nthOpt(n: 0, list: list)?.1 == "one")
            #expect(nthOpt(n: 1, list: list)?.0 == 2)
            #expect(nthOpt(n: 1, list: list)?.1 == "two")
            #expect(nthOpt(n: 2, list: list)?.0 == 3)
            #expect(nthOpt(n: 2, list: list)?.1 == "three")
            #expect(nthOpt(n: 3, list: list) == nil)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func combineWorksWithDifferentElementTypes() {
        let left = "one" +| "two" +| LinkedList<String>.empty
        let right = true +| false +| LinkedList<Bool>.empty

        let result = combine(left, right)

        if case .success(let list) = result {
            #expect(nthOpt(n: 0, list: list)?.0 == "one")
            #expect(nthOpt(n: 0, list: list)?.1 == true)
            #expect(nthOpt(n: 1, list: list)?.0 == "two")
            #expect(nthOpt(n: 1, list: list)?.1 == false)
            #expect(nthOpt(n: 2, list: list) == nil)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func combineReturnsList1TooShortWhenFirstListEndsFirst() {
        let left = 1 +| LinkedList<Int>.empty
        let right = "one" +| "two" +| LinkedList<String>.empty

        let result = combine(left, right)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func combineReturnsList2TooShortWhenSecondListEndsFirst() {
        let left = 1 +| 2 +| LinkedList<Int>.empty
        let right = "one" +| LinkedList<String>.empty

        let result = combine(left, right)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func combineReturnsList1TooShortWhenOnlySecondListHasValues() {
        let left = LinkedList<Int>.empty
        let right = "one" +| LinkedList<String>.empty

        let result = combine(left, right)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func combineReturnsList2TooShortWhenOnlyFirstListHasValues() {
        let left = 1 +| LinkedList<Int>.empty
        let right = LinkedList<String>.empty

        let result = combine(left, right)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func combineDoesNotChangeOriginalLists() {
        let left = 1 +| 2 +| LinkedList<Int>.empty
        let right = "one" +| "two" +| LinkedList<String>.empty

        _ = combine(left, right)

        expectList(left, equals: [1, 2])
        expectList(right, equals: ["one", "two"])
    }
}
