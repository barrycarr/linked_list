//
//  associationTests.swift
//  linked_list
//
//  Created by Barry Carr on 27/08/2026.
//

import Testing
@testable import linked_list

struct AssociationTests {
    final class Key: Equatable {
        let id: Int

        init(_ id: Int) {
            self.id = id
        }

        static func == (lhs: Key, rhs: Key) -> Bool {
            lhs.id == rhs.id
        }
    }

    @Test func assocOptReturnsNilForEmptyList() {
        let list = LinkedList<(String, Int)>.empty

        let result = assocOpt("one", list)

        #expect(result == nil)
    }

    @Test func assocOptReturnsValueForMatchingKey() {
        let list = ("one", 1) +| ("two", 2) +| ("three", 3) +| LinkedList<(String, Int)>.empty

        let result = assocOpt("two", list)

        #expect(result == 2)
    }

    @Test func assocOptReturnsFirstMatchingValueWhenKeyAppearsMultipleTimes() {
        let list = ("one", 1) +| ("two", 2) +| ("two", 22) +| LinkedList<(String, Int)>.empty

        let result = assocOpt("two", list)

        #expect(result == 2)
    }

    @Test func assocOptReturnsNilWhenKeyIsNotFound() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        let result = assocOpt("three", list)

        #expect(result == nil)
    }

    @Test func assocOptUsesEquatableKeyEquality() {
        let list = ("Apple", 1) +| ("Banana", 2) +| LinkedList<(String, Int)>.empty

        let result = assocOpt("Apple", list)

        #expect(result == 1)
    }

    @Test func assocOptOfCanBeUsedWithPipeForward() {
        let list = (1, "one") +| (2, "two") +| (3, "three") +| LinkedList<(Int, String)>.empty

        let result = list |> assocOptOf(3)

        #expect(result == "three")
    }

    @Test func assocReturnsSuccessForMatchingKey() {
        let list = ("one", 1) +| ("two", 2) +| ("three", 3) +| LinkedList<(String, Int)>.empty

        let result = assoc("two", list)

        if case .success(let value) = result {
            #expect(value == 2)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assocReturnsFirstMatchingValueWhenKeyAppearsMultipleTimes() {
        let list = ("one", 1) +| ("two", 2) +| ("two", 22) +| LinkedList<(String, Int)>.empty

        let result = assoc("two", list)

        if case .success(let value) = result {
            #expect(value == 2)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assocReturnsNotFoundForEmptyList() {
        let list = LinkedList<(String, Int)>.empty

        let result = assoc("one", list)

        if case .failure(.notFound) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assocReturnsNotFoundWhenKeyIsNotFound() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        let result = assoc("three", list)

        if case .failure(.notFound) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assocOfCanBeUsedWithPipeForward() {
        let list = (1, "one") +| (2, "two") +| (3, "three") +| LinkedList<(Int, String)>.empty

        let result = list |> assocOf(2)

        if case .success(let value) = result {
            #expect(value == "two")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assocDoesNotChangeOriginalList() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        _ = assoc("two", list)

        #expect(nthOpt(n: 0, list: list)?.0 == "one")
        #expect(nthOpt(n: 0, list: list)?.1 == 1)
        #expect(nthOpt(n: 1, list: list)?.0 == "two")
        #expect(nthOpt(n: 1, list: list)?.1 == 2)
        #expect(nthOpt(n: 2, list: list) == nil)
    }

    @Test func assqOptReturnsNilForEmptyList() {
        let key = Key(1)
        let list = LinkedList<(Key, String)>.empty

        let result = assqOpt(key, list)

        #expect(result == nil)
    }

    @Test func assqOptReturnsValueForIdenticalKeyInstance() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        let result = assqOpt(second, list)

        #expect(result == "two")
    }

    @Test func assqOptDoesNotMatchEqualButDifferentKeyInstance() {
        let stored = Key(1)
        let equalButDifferentInstance = Key(1)
        let list = (stored, "one") +| LinkedList<(Key, String)>.empty

        let result = assqOpt(equalButDifferentInstance, list)

        #expect(result == nil)
    }

    @Test func assqOptReturnsFirstMatchingValueWhenSameKeyInstanceAppearsMultipleTimes() {
        let key = Key(1)
        let list = (key, "first") +| (key, "second") +| LinkedList<(Key, String)>.empty

        let result = assqOpt(key, list)

        #expect(result == "first")
    }

    @Test func assqOptReturnsNilWhenKeyIsNotFound() {
        let stored = Key(1)
        let missing = Key(2)
        let list = (stored, "one") +| LinkedList<(Key, String)>.empty

        let result = assqOpt(missing, list)

        #expect(result == nil)
    }

    @Test func assqOptOfCanBeUsedWithPipeForward() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        let result = list |> assqOptOf(second)

        #expect(result == "two")
    }

    @Test func assqReturnsSuccessForIdenticalKeyInstance() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        let result = assq(second, list)

        if case .success(let value) = result {
            #expect(value == "two")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assqReturnsFirstMatchingValueWhenSameKeyInstanceAppearsMultipleTimes() {
        let key = Key(1)
        let list = (key, "first") +| (key, "second") +| LinkedList<(Key, String)>.empty

        let result = assq(key, list)

        if case .success(let value) = result {
            #expect(value == "first")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assqReturnsNotFoundForEmptyList() {
        let key = Key(1)
        let list = LinkedList<(Key, String)>.empty

        let result = assq(key, list)

        if case .failure(.notFound) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assqReturnsNotFoundForEqualButDifferentKeyInstance() {
        let stored = Key(1)
        let equalButDifferentInstance = Key(1)
        let list = (stored, "one") +| LinkedList<(Key, String)>.empty

        let result = assq(equalButDifferentInstance, list)

        if case .failure(.notFound) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assqOfCanBeUsedWithPipeForward() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        let result = list |> assqOf(first)

        if case .success(let value) = result {
            #expect(value == "one")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func assqDoesNotChangeOriginalList() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        _ = assq(second, list)

        #expect(nthOpt(n: 0, list: list)?.0 === first)
        #expect(nthOpt(n: 0, list: list)?.1 == "one")
        #expect(nthOpt(n: 1, list: list)?.0 === second)
        #expect(nthOpt(n: 1, list: list)?.1 == "two")
        #expect(nthOpt(n: 2, list: list) == nil)
    }

    @Test func memAssocReturnsFalseForEmptyList() {
        let list = LinkedList<(String, Int)>.empty

        let result = memAssoc("one", list)

        #expect(!result)
    }

    @Test func memAssocReturnsTrueWhenKeyExists() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        let result = memAssoc("two", list)

        #expect(result)
    }

    @Test func memAssocReturnsFalseWhenKeyDoesNotExist() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        let result = memAssoc("three", list)

        #expect(!result)
    }

    @Test func memAssocUsesEquatableKeyEquality() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        let result = memAssoc(String("one"), list)

        #expect(result)
    }

    @Test func memAssocReturnsTrueWhenExistingKeyHasNilOptionalValue() {
        let list = ("one", Optional<Int>.none) +| ("two", Optional.some(2)) +| LinkedList<(String, Int?)>.empty

        let result = memAssoc("one", list)

        #expect(result)
    }

    @Test func memAssocOfCanBeUsedWithPipeForward() {
        let list = (1, "one") +| (2, "two") +| LinkedList<(Int, String)>.empty

        let result = list |> memAssocOf(2)

        #expect(result)
    }

    @Test func memAssqReturnsFalseForEmptyList() {
        let key = Key(1)
        let list = LinkedList<(Key, String)>.empty

        let result = memAssq(key, list)

        #expect(!result)
    }

    @Test func memAssqReturnsTrueForIdenticalKeyInstance() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        let result = memAssq(second, list)

        #expect(result)
    }

    @Test func memAssqReturnsFalseForEqualButDifferentKeyInstance() {
        let stored = Key(1)
        let equalButDifferentInstance = Key(1)
        let list = (stored, "one") +| LinkedList<(Key, String)>.empty

        let result = memAssq(equalButDifferentInstance, list)

        #expect(!result)
    }

    @Test func memAssqReturnsFalseWhenKeyDoesNotExist() {
        let stored = Key(1)
        let missing = Key(2)
        let list = (stored, "one") +| LinkedList<(Key, String)>.empty

        let result = memAssq(missing, list)

        #expect(!result)
    }

    @Test func memAssqReturnsTrueWhenExistingKeyHasNilOptionalValue() {
        let key = Key(1)
        let list = (key, Optional<Int>.none) +| LinkedList<(Key, Int?)>.empty

        let result = memAssq(key, list)

        #expect(result)
    }

    @Test func memAssqOfCanBeUsedWithPipeForward() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        let result = list |> memAssqOf(first)

        #expect(result)
    }

    @Test func removeAssocReturnsEmptyListForEmptyList() {
        let list = LinkedList<(String, Int)>.empty

        let result = removeAssoc("one", list)

        #expect(isEmpty(list: result))
    }

    @Test func removeAssocRemovesFirstMatchingKey() {
        let list = ("one", 1) +| ("two", 2) +| ("three", 3) +| LinkedList<(String, Int)>.empty

        let result = removeAssoc("two", list)

        #expect(nthOpt(n: 0, list: result)?.0 == "one")
        #expect(nthOpt(n: 0, list: result)?.1 == 1)
        #expect(nthOpt(n: 1, list: result)?.0 == "three")
        #expect(nthOpt(n: 1, list: result)?.1 == 3)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func removeAssocRemovesOnlyFirstMatchingKeyWhenKeyAppearsMultipleTimes() {
        let list = ("one", 1) +| ("two", 2) +| ("two", 22) +| ("three", 3) +| LinkedList<(String, Int)>.empty

        let result = removeAssoc("two", list)

        #expect(nthOpt(n: 0, list: result)?.0 == "one")
        #expect(nthOpt(n: 0, list: result)?.1 == 1)
        #expect(nthOpt(n: 1, list: result)?.0 == "two")
        #expect(nthOpt(n: 1, list: result)?.1 == 22)
        #expect(nthOpt(n: 2, list: result)?.0 == "three")
        #expect(nthOpt(n: 2, list: result)?.1 == 3)
        #expect(nthOpt(n: 3, list: result) == nil)
    }

    @Test func removeAssocReturnsOriginalValuesWhenKeyIsNotFound() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        let result = removeAssoc("three", list)

        #expect(nthOpt(n: 0, list: result)?.0 == "one")
        #expect(nthOpt(n: 0, list: result)?.1 == 1)
        #expect(nthOpt(n: 1, list: result)?.0 == "two")
        #expect(nthOpt(n: 1, list: result)?.1 == 2)
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func removeAssocUsesEquatableKeyEquality() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        let result = removeAssoc(String("one"), list)

        #expect(nthOpt(n: 0, list: result)?.0 == "two")
        #expect(nthOpt(n: 0, list: result)?.1 == 2)
        #expect(nthOpt(n: 1, list: result) == nil)
    }

    @Test func removeAssocOfCanBeUsedWithPipeForward() {
        let list = (1, "one") +| (2, "two") +| (3, "three") +| LinkedList<(Int, String)>.empty

        let result = list |> removeAssocOf(2)

        #expect(nthOpt(n: 0, list: result)?.0 == 1)
        #expect(nthOpt(n: 0, list: result)?.1 == "one")
        #expect(nthOpt(n: 1, list: result)?.0 == 3)
        #expect(nthOpt(n: 1, list: result)?.1 == "three")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func removeAssocDoesNotChangeOriginalList() {
        let list = ("one", 1) +| ("two", 2) +| LinkedList<(String, Int)>.empty

        _ = removeAssoc("one", list)

        #expect(nthOpt(n: 0, list: list)?.0 == "one")
        #expect(nthOpt(n: 0, list: list)?.1 == 1)
        #expect(nthOpt(n: 1, list: list)?.0 == "two")
        #expect(nthOpt(n: 1, list: list)?.1 == 2)
        #expect(nthOpt(n: 2, list: list) == nil)
    }

    @Test func removeAssqReturnsEmptyListForEmptyList() {
        let key = Key(1)
        let list = LinkedList<(Key, String)>.empty

        let result = removeAssq(key, list)

        #expect(isEmpty(list: result))
    }

    @Test func removeAssqRemovesFirstIdenticalKeyInstance() {
        let first = Key(1)
        let second = Key(2)
        let third = Key(3)
        let list = (first, "one") +| (second, "two") +| (third, "three") +| LinkedList<(Key, String)>.empty

        let result = removeAssq(second, list)

        #expect(nthOpt(n: 0, list: result)?.0 === first)
        #expect(nthOpt(n: 0, list: result)?.1 == "one")
        #expect(nthOpt(n: 1, list: result)?.0 === third)
        #expect(nthOpt(n: 1, list: result)?.1 == "three")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func removeAssqRemovesOnlyFirstMatchingKeyWhenSameInstanceAppearsMultipleTimes() {
        let key = Key(1)
        let other = Key(2)
        let list = (key, "first") +| (other, "other") +| (key, "second") +| LinkedList<(Key, String)>.empty

        let result = removeAssq(key, list)

        #expect(nthOpt(n: 0, list: result)?.0 === other)
        #expect(nthOpt(n: 0, list: result)?.1 == "other")
        #expect(nthOpt(n: 1, list: result)?.0 === key)
        #expect(nthOpt(n: 1, list: result)?.1 == "second")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func removeAssqDoesNotRemoveEqualButDifferentKeyInstance() {
        let stored = Key(1)
        let equalButDifferentInstance = Key(1)
        let list = (stored, "one") +| LinkedList<(Key, String)>.empty

        let result = removeAssq(equalButDifferentInstance, list)

        #expect(nthOpt(n: 0, list: result)?.0 === stored)
        #expect(nthOpt(n: 0, list: result)?.1 == "one")
        #expect(nthOpt(n: 1, list: result) == nil)
    }

    @Test func removeAssqReturnsOriginalValuesWhenKeyIsNotFound() {
        let stored = Key(1)
        let missing = Key(2)
        let list = (stored, "one") +| LinkedList<(Key, String)>.empty

        let result = removeAssq(missing, list)

        #expect(nthOpt(n: 0, list: result)?.0 === stored)
        #expect(nthOpt(n: 0, list: result)?.1 == "one")
        #expect(nthOpt(n: 1, list: result) == nil)
    }

    @Test func removeAssqOfCanBeUsedWithPipeForward() {
        let first = Key(1)
        let second = Key(2)
        let third = Key(3)
        let list = (first, "one") +| (second, "two") +| (third, "three") +| LinkedList<(Key, String)>.empty

        let result = list |> removeAssqOf(first)

        #expect(nthOpt(n: 0, list: result)?.0 === second)
        #expect(nthOpt(n: 0, list: result)?.1 == "two")
        #expect(nthOpt(n: 1, list: result)?.0 === third)
        #expect(nthOpt(n: 1, list: result)?.1 == "three")
        #expect(nthOpt(n: 2, list: result) == nil)
    }

    @Test func removeAssqDoesNotChangeOriginalList() {
        let first = Key(1)
        let second = Key(2)
        let list = (first, "one") +| (second, "two") +| LinkedList<(Key, String)>.empty

        _ = removeAssq(first, list)

        #expect(nthOpt(n: 0, list: list)?.0 === first)
        #expect(nthOpt(n: 0, list: list)?.1 == "one")
        #expect(nthOpt(n: 1, list: list)?.0 === second)
        #expect(nthOpt(n: 1, list: list)?.1 == "two")
        #expect(nthOpt(n: 2, list: list) == nil)
    }
}
