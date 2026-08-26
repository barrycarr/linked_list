//
//  comparisonTests.swift
//  linked_listTests
//
//  Created by Barry Carr on 19/08/2026.
//

import Testing
@testable import linked_list

struct ComparisonTests {

    private let intCompare: ListCmp<Int> = { lhs, rhs in
        if lhs < rhs {
            return -1
        }
        if lhs > rhs {
            return 1
        }
        return 0
    }

    @Test func compareLengthsReturnsZeroForListsWithEqualLength() {
        let lhs = 1 +| 2 +| LinkedList<Int>.empty
        let rhs = 10 +| 20 +| LinkedList<Int>.empty

        #expect(compareLengths(lhs, rhs) == 0)
    }

    @Test func compareLengthsReturnsNegativeWhenFirstListIsShorter() {
        let lhs = 1 +| LinkedList<Int>.empty
        let rhs = 10 +| 20 +| LinkedList<Int>.empty

        #expect(compareLengths(lhs, rhs) < 0)
    }

    @Test func compareLengthsReturnsPositiveWhenFirstListIsLonger() {
        let lhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let rhs = 10 +| LinkedList<Int>.empty

        #expect(compareLengths(lhs, rhs) > 0)
    }

    @Test func compareLengthsHandlesEmptyLists() {
        let emptyList = LinkedList<Int>.empty
        let nonEmptyList = 1 +| LinkedList<Int>.empty

        #expect(compareLengths(emptyList, emptyList) == 0)
        #expect(compareLengths(emptyList, nonEmptyList) < 0)
        #expect(compareLengths(nonEmptyList, emptyList) > 0)
    }

    @Test func compareLengthWithReturnsZeroWhenLengthMatches() {
        let list = 1 +| 2 +| LinkedList<Int>.empty

        #expect(compareLengthWith(list, len: 2) == 0)
    }

    @Test func compareLengthWithReturnsNegativeWhenListIsShorterThanLength() {
        let list = 1 +| 2 +| LinkedList<Int>.empty

        #expect(compareLengthWith(list, len: 3) < 0)
    }

    @Test func compareLengthWithReturnsPositiveWhenListIsLongerThanLength() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        #expect(compareLengthWith(list, len: 2) > 0)
    }

    @Test func compareLengthWithHandlesEmptyList() {
        let list = LinkedList<Int>.empty

        #expect(compareLengthWith(list, len: 0) == 0)
        #expect(compareLengthWith(list, len: 1) < 0)
        #expect(compareLengthWith(list, len: -1) > 0)
    }

    @Test func compareLengthWithReturnsPositiveForNegativeLengthAndNonEmptyList() {
        let list = 1 +| LinkedList<Int>.empty

        #expect(compareLengthWith(list, len: -1) > 0)
    }

    @Test func equalReturnsTrueForTwoEmptyLists() {
        let lhs = LinkedList<Int>.empty
        let rhs = LinkedList<Int>.empty

        #expect(equal(==, lhs, rhs))
    }

    @Test func equalReturnsTrueWhenAllElementsMatch() {
        let lhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let rhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        #expect(equal(==, lhs, rhs))
    }

    @Test func equalReturnsFalseWhenElementsDiffer() {
        let lhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let rhs = 1 +| 9 +| 3 +| LinkedList<Int>.empty

        #expect(!equal(==, lhs, rhs))
    }

    @Test func equalReturnsFalseWhenFirstListIsShorter() {
        let lhs = 1 +| 2 +| LinkedList<Int>.empty
        let rhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        #expect(!equal(==, lhs, rhs))
    }

    @Test func equalReturnsFalseWhenFirstListIsLonger() {
        let lhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let rhs = 1 +| 2 +| LinkedList<Int>.empty

        #expect(!equal(==, lhs, rhs))
    }

    @Test func equalUsesTheProvidedComparisonFunction() {
        let lhs = 1 +| -2 +| 3 +| LinkedList<Int>.empty
        let rhs = -1 +| 2 +| -3 +| LinkedList<Int>.empty

        let sameMagnitude: ListEq<Int> = { lhs, rhs in
            abs(lhs) == abs(rhs)
        }

        #expect(equal(sameMagnitude, lhs, rhs))
    }

    @Test func compareReturnsZeroForTwoEmptyLists() {
        let lhs = LinkedList<Int>.empty
        let rhs = LinkedList<Int>.empty

        #expect(compare(intCompare, lhs, rhs) == 0)
    }

    @Test func compareReturnsZeroWhenAllElementsMatch() {
        let lhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let rhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        #expect(compare(intCompare, lhs, rhs) == 0)
    }

    @Test func compareReturnsNegativeWhenFirstDifferentElementIsSmaller() {
        let lhs = 1 +| 2 +| 9 +| LinkedList<Int>.empty
        let rhs = 1 +| 3 +| 0 +| LinkedList<Int>.empty

        #expect(compare(intCompare, lhs, rhs) < 0)
    }

    @Test func compareReturnsPositiveWhenFirstDifferentElementIsLarger() {
        let lhs = 1 +| 4 +| 0 +| LinkedList<Int>.empty
        let rhs = 1 +| 3 +| 9 +| LinkedList<Int>.empty

        #expect(compare(intCompare, lhs, rhs) > 0)
    }

    @Test func compareReturnsNegativeWhenLeftListEndsAfterEqualPrefix() {
        let lhs = 1 +| 2 +| LinkedList<Int>.empty
        let rhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        #expect(compare(intCompare, lhs, rhs) < 0)
    }

    @Test func compareReturnsPositiveWhenRightListEndsAfterEqualPrefix() {
        let lhs = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let rhs = 1 +| 2 +| LinkedList<Int>.empty

        #expect(compare(intCompare, lhs, rhs) > 0)
    }

    @Test func compareEmptyListIsSmallerThanNonEmptyList() {
        let lhs = LinkedList<Int>.empty
        let rhs = 1 +| LinkedList<Int>.empty

        #expect(compare(intCompare, lhs, rhs) < 0)
        #expect(compare(intCompare, rhs, lhs) > 0)
    }

    @Test func compareUsesProvidedComparisonFunction() {
        let lhs = "a" +| "bb" +| LinkedList<String>.empty
        let rhs = "z" +| "c" +| LinkedList<String>.empty

        let compareLength: ListCmp<String> = { lhs, rhs in
            if lhs.count < rhs.count {
                return -1
            }
            if lhs.count > rhs.count {
                return 1
            }
            return 0
        }

        #expect(compare(compareLength, lhs, rhs) > 0)
    }
}
