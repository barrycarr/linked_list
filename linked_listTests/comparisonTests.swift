//
//  comparisonTests.swift
//  linked_listTests
//
//  Created by Barry Carr on 19/08/2026.
//

import Testing
@testable import linked_list

struct ComparisonTests {

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
}
