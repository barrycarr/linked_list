//
//  sortingTests.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

import Testing
@testable import linked_list

struct SortingTests {
    struct Item: Equatable {
        let sortKey: Int
        let label: String
    }

    private func intCmp(_ lhs: Int, _ rhs: Int) -> Int {
        lhs - rhs
    }

    private func expectList<T: Equatable>(_ list: LinkedList<T>, equals values: [T]) {
        for (index, value) in values.enumerated() {
            #expect(nthOpt(index, list) == value)
        }
        #expect(nthOpt(values.count, list) == nil)
    }

    @Test func mergeReturnsEmptyListForTwoEmptyLists() {
        let lhs = LinkedList<Int>.empty
        let rhs = LinkedList<Int>.empty

        let result = merge(intCmp, lhs, rhs)

        #expect(isEmpty(result))
    }

    @Test func mergeReturnsRightListWhenLeftListIsEmpty() {
        let lhs = LinkedList<Int>.empty
        let rhs = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = merge(intCmp, lhs, rhs)

        expectList(result, equals: [1, 3, 5])
    }

    @Test func mergeReturnsLeftListWhenRightListIsEmpty() {
        let lhs = 1 +| 3 +| 5 +| LinkedList<Int>.empty
        let rhs = LinkedList<Int>.empty

        let result = merge(intCmp, lhs, rhs)

        expectList(result, equals: [1, 3, 5])
    }

    @Test func mergeInterleavesTwoSortedLists() {
        let lhs = 1 +| 3 +| 5 +| LinkedList<Int>.empty
        let rhs = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = merge(intCmp, lhs, rhs)

        expectList(result, equals: [1, 2, 3, 4, 5, 6])
    }

    @Test func mergeHandlesUnevenLengthLists() {
        let lhs = 1 +| 2 +| LinkedList<Int>.empty
        let rhs = 3 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty

        let result = merge(intCmp, lhs, rhs)

        expectList(result, equals: [1, 2, 3, 4, 5, 6])
    }

    @Test func mergeKeepsDuplicateValues() {
        let lhs = 1 +| 2 +| 4 +| LinkedList<Int>.empty
        let rhs = 2 +| 3 +| 4 +| LinkedList<Int>.empty

        let result = merge(intCmp, lhs, rhs)

        expectList(result, equals: [1, 2, 2, 3, 4, 4])
    }

    @Test func mergeIsStableWhenComparedValuesAreEqual() {
        let leftFirst = Item(sortKey: 1, label: "left first")
        let leftSecond = Item(sortKey: 2, label: "left second")
        let rightFirst = Item(sortKey: 1, label: "right first")
        let rightSecond = Item(sortKey: 2, label: "right second")
        let lhs = leftFirst +| leftSecond +| LinkedList<Item>.empty
        let rhs = rightFirst +| rightSecond +| LinkedList<Item>.empty

        let result = merge({ lhs, rhs in
            lhs.sortKey - rhs.sortKey
        }, lhs, rhs)

        expectList(result, equals: [leftFirst, rightFirst, leftSecond, rightSecond])
    }

    @Test func mergeCanUseComparatorForNonComparableValues() {
        let lhs = Item(sortKey: 1, label: "one") +| Item(sortKey: 4, label: "four") +| LinkedList<Item>.empty
        let rhs = Item(sortKey: 2, label: "two") +| Item(sortKey: 3, label: "three") +| LinkedList<Item>.empty

        let result = merge({ lhs, rhs in
            lhs.sortKey - rhs.sortKey
        }, lhs, rhs)

        expectList(
            result,
            equals: [
                Item(sortKey: 1, label: "one"),
                Item(sortKey: 2, label: "two"),
                Item(sortKey: 3, label: "three"),
                Item(sortKey: 4, label: "four")
            ]
        )
    }

    @Test func mergeDoesNotChangeOriginalLists() {
        let lhs = 1 +| 3 +| LinkedList<Int>.empty
        let rhs = 2 +| 4 +| LinkedList<Int>.empty

        _ = merge(intCmp, lhs, rhs)

        expectList(lhs, equals: [1, 3])
        expectList(rhs, equals: [2, 4])
    }

    @Test func mergeOfCanBeUsedWithPipeForward() {
        let lhs = 1 +| 3 +| 5 +| LinkedList<Int>.empty
        let rhs = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = rhs |> mergeOf(intCmp, lhs)

        expectList(result, equals: [1, 2, 3, 4, 5, 6])
    }

    @Test func halveReturnsTwoEmptyListsForEmptyList() {
        let list = LinkedList<Int>.empty

        let (left, right) = halve(list)

        #expect(isEmpty(left))
        #expect(isEmpty(right))
    }

    @Test func halvePutsSingleValueInLeftList() {
        let list = 1 +| LinkedList<Int>.empty

        let (left, right) = halve(list)

        expectList(left, equals: [1])
        #expect(isEmpty(right))
    }

    @Test func halveSplitsTwoValuesAcrossBothLists() {
        let list = 1 +| 2 +| LinkedList<Int>.empty

        let (left, right) = halve(list)

        expectList(left, equals: [1])
        expectList(right, equals: [2])
    }

    @Test func halveSplitsOddLengthListIntoContiguousHalves() {
        let list = 1 +| 2 +| 3 +| 4 +| 5 +| LinkedList<Int>.empty

        let (left, right) = halve(list)

        expectList(left, equals: [1, 2])
        expectList(right, equals: [3, 4, 5])
    }

    @Test func halveSplitsEvenLengthListIntoContiguousHalves() {
        let list = 1 +| 2 +| 3 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty

        let (left, right) = halve(list)

        expectList(left, equals: [1, 2, 3])
        expectList(right, equals: [4, 5, 6])
    }

    @Test func halveDoesNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty

        _ = halve(list)

        expectList(list, equals: [1, 2, 3, 4])
    }

    @Test func sortReturnsEmptyListForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = sort(intCmp, list)

        #expect(isEmpty(result))
    }

    @Test func sortReturnsSingleItemList() {
        let list = 1 +| LinkedList<Int>.empty

        let result = sort(intCmp, list)

        expectList(result, equals: [1])
    }

    @Test func sortOrdersUnsortedValuesAscending() {
        let list = 4 +| 1 +| 3 +| 2 +| LinkedList<Int>.empty

        let result = sort(intCmp, list)

        expectList(result, equals: [1, 2, 3, 4])
    }

    @Test func sortKeepsDuplicateValues() {
        let list = 3 +| 1 +| 2 +| 1 +| 3 +| LinkedList<Int>.empty

        let result = sort(intCmp, list)

        expectList(result, equals: [1, 1, 2, 3, 3])
    }

    @Test func sortCanUseComparatorForDescendingOrder() {
        let list = 1 +| 4 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = sort({ lhs, rhs in rhs - lhs }, list)

        expectList(result, equals: [4, 3, 2, 1])
    }

    @Test func sortCanUseComparatorForNonComparableValues() {
        let list = Item(sortKey: 3, label: "three")
            +| Item(sortKey: 1, label: "one")
            +| Item(sortKey: 2, label: "two")
            +| LinkedList<Item>.empty

        let result = sort({ lhs, rhs in
            lhs.sortKey - rhs.sortKey
        }, list)

        expectList(
            result,
            equals: [
                Item(sortKey: 1, label: "one"),
                Item(sortKey: 2, label: "two"),
                Item(sortKey: 3, label: "three")
            ]
        )
    }

    @Test func sortOfCanBeUsedWithPipeForward() {
        let list = 4 +| 1 +| 3 +| 2 +| LinkedList<Int>.empty

        let result = list |> sortOf(intCmp)

        expectList(result, equals: [1, 2, 3, 4])
    }

    @Test func sortDoesNotChangeOriginalList() {
        let list = 4 +| 1 +| 3 +| 2 +| LinkedList<Int>.empty

        _ = sort(intCmp, list)

        expectList(list, equals: [4, 1, 3, 2])
    }

    @Test func sortIsStableWhenComparedValuesAreEqual() {
        let first = Item(sortKey: 1, label: "first")
        let second = Item(sortKey: 1, label: "second")
        let third = Item(sortKey: 1, label: "third")
        let fourth = Item(sortKey: 1, label: "fourth")
        let list = first +| second +| third +| fourth +| LinkedList<Item>.empty

        let result = sort({ lhs, rhs in
            lhs.sortKey - rhs.sortKey
        }, list)

        expectList(result, equals: [first, second, third, fourth])
    }

    @Test func stableSortOrdersValuesUsingSortImplementation() {
        let list = 4 +| 1 +| 3 +| 2 +| LinkedList<Int>.empty

        let result = stableSort(intCmp, list)

        expectList(result, equals: [1, 2, 3, 4])
    }

    @Test func stableSortOfCanBeUsedWithPipeForward() {
        let list = 4 +| 1 +| 3 +| 2 +| LinkedList<Int>.empty

        let result = list |> stableSortOf(intCmp)

        expectList(result, equals: [1, 2, 3, 4])
    }

    @Test func stableSortIsStableWhenComparedValuesAreEqual() {
        let first = Item(sortKey: 1, label: "first")
        let second = Item(sortKey: 1, label: "second")
        let third = Item(sortKey: 1, label: "third")
        let list = first +| second +| third +| LinkedList<Item>.empty

        let result = stableSort({ lhs, rhs in
            lhs.sortKey - rhs.sortKey
        }, list)

        expectList(result, equals: [first, second, third])
    }

    @Test func fastSortOrdersValuesUsingSortImplementation() {
        let list = 4 +| 1 +| 3 +| 2 +| LinkedList<Int>.empty

        let result = fastSort(intCmp, list)

        expectList(result, equals: [1, 2, 3, 4])
    }

    @Test func fastSortOfCanBeUsedWithPipeForward() {
        let list = 4 +| 1 +| 3 +| 2 +| LinkedList<Int>.empty

        let result = list |> fastSortOf(intCmp)

        expectList(result, equals: [1, 2, 3, 4])
    }

    @Test func fastSortIsStableWhenComparedValuesAreEqual() {
        let first = Item(sortKey: 1, label: "first")
        let second = Item(sortKey: 1, label: "second")
        let third = Item(sortKey: 1, label: "third")
        let list = first +| second +| third +| LinkedList<Item>.empty

        let result = fastSort({ lhs, rhs in
            lhs.sortKey - rhs.sortKey
        }, list)

        expectList(result, equals: [first, second, third])
    }
}
