//
//  sequencesTests.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

import Testing
@testable import linked_list

struct SequencesTests {
    private func expectList<T: Equatable>(_ list: LinkedList<T>, equals values: [T]) {
        for (index, value) in values.enumerated() {
            #expect(nthOpt(n: index, list: list) == value)
        }
        #expect(nthOpt(n: values.count, list: list) == nil)
    }

    @Test func emptyListIteratesNoValues() {
        let list = LinkedList<Int>.empty

        let values = Array(list)

        #expect(values.isEmpty)
    }

    @Test func listIteratesValuesInOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        var values: [Int] = []

        for value in list {
            values.append(value)
        }

        #expect(values == [1, 2, 3])
    }

    @Test func listCanBeIteratedMoreThanOnce() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let firstPass = Array(list)
        let secondPass = Array(list)

        #expect(firstPass == [1, 2, 3])
        #expect(secondPass == [1, 2, 3])
    }

    @Test func independentIteratorsKeepSeparateState() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let first = list.makeIterator()
        let second = list.makeIterator()

        #expect(first.next() == 1)
        #expect(first.next() == 2)
        #expect(second.next() == 1)
        #expect(first.next() == 3)
        #expect(second.next() == 2)
        #expect(first.next() == nil)
        #expect(second.next() == 3)
        #expect(second.next() == nil)
    }

    @Test func toArrayReturnsEmptyArrayForEmptyList() {
        let list = LinkedList<Int>.empty

        let result = toArray(list)

        #expect(result == [])
    }

    @Test func toArrayReturnsValuesInListOrder() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = toArray(list)

        #expect(result == [1, 2, 3])
    }

    @Test func ofArrayReturnsEmptyListForEmptyArray() {
        let result = ofArray([Int]())

        #expect(isEmpty(list: result))
    }

    @Test func ofArrayPreservesArrayOrder() {
        let result = ofArray([1, 2, 3])

        expectList(result, equals: [1, 2, 3])
    }

    @Test func ofCollectionReturnsEmptyListForEmptyCollection() {
        let values = ArraySlice<Int>()

        let result = ofCollection(values)

        #expect(isEmpty(list: result))
    }

    @Test func ofCollectionPreservesCollectionOrder() {
        let values = [1, 2, 3, 4][1...3]

        let result = ofCollection(values)

        expectList(result, equals: [2, 3, 4])
    }

    @Test func ofSeqReturnsEmptyListForEmptySequence() {
        let values = AnySequence<Int> {
            AnyIterator { nil }
        }

        let result = ofSeq(values)

        #expect(isEmpty(list: result))
    }

    @Test func ofSeqPreservesSequenceOrder() {
        let values = AnySequence([1, 2, 3])

        let result = ofSeq(values)

        expectList(result, equals: [1, 2, 3])
    }

    @Test func roundTripThroughArrayPreservesValues() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = ofArray(toArray(list))

        expectList(result, equals: [1, 2, 3])
    }
}
