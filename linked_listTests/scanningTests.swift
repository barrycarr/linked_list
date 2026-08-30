//
//  scanningTests.swift
//  linked_list
//
//  Created by Barry Carr on 26/08/2026.
//

import Testing
@testable import linked_list

struct ScanningTests {
    final class Box: Equatable {
        let id: Int

        init(_ id: Int) {
            self.id = id
        }

        static func == (lhs: Box, rhs: Box) -> Bool {
            lhs.id == rhs.id
        }
    }

    @Test func forAllReturnsTrueForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = forAll({ _ in
            callCount += 1
            return false
        }, list)

        #expect(result)
        #expect(callCount == 0)
    }

    @Test func forAllReturnsTrueWhenEveryElementMatchesPredicate() {
        let list = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = forAll({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(result)
    }

    @Test func forAllReturnsFalseWhenFirstElementDoesNotMatchPredicate() {
        let list = 1 +| 2 +| 4 +| LinkedList<Int>.empty
        var callCount = 0

        let result = forAll({ value in
            callCount += 1
            return value.isMultiple(of: 2)
        }, list)

        #expect(!result)
        #expect(callCount == 1)
    }

    @Test func forAllReturnsFalseWhenLaterElementDoesNotMatchPredicate() {
        let list = 2 +| 4 +| 5 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = forAll({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        #expect(!result)
        #expect(checkedValues == [2, 4, 5])
    }

    @Test func forAllWorksWithNonIntegerValues() {
        let list = "apple" +| "apricot" +| "avocado" +| LinkedList<String>.empty

        let result = forAll({ value in
            value.hasPrefix("a")
        }, list)

        #expect(result)
    }

    @Test func forAllDoesNotChangeOriginalList() {
        let list = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        _ = forAll({ value in value.isMultiple(of: 2) }, list)

        #expect(nthOpt(0, list) == 2)
        #expect(nthOpt(1, list) == 4)
        #expect(nthOpt(2, list) == 6)
    }

    @Test func forAllOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "apricot" +| "avocado" +| LinkedList<String>.empty

        let result = list |> forAllOf { value in
            value.hasPrefix("a")
        }

        #expect(result)
    }

    @Test func forAll2ReturnsTrueForTwoEmptyLists() {
        let l1 = LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = forAll2({ _, _ in
            callCount += 1
            return false
        }, l1, l2)

        if case .success(let value) = result {
            #expect(value)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func forAll2ReturnsTrueWhenEveryPairMatchesPredicate() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 2 +| 4 +| 6 +| LinkedList<Int>.empty

        let result = forAll2({ value1, value2 in
            value2 == value1 * 2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(value)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func forAll2ReturnsFalseWhenFirstPairDoesNotMatchPredicate() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 3 +| 4 +| 6 +| LinkedList<Int>.empty
        var callCount = 0

        let result = forAll2({ value1, value2 in
            callCount += 1
            return value2 == value1 * 2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(!value)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func forAll2ReturnsFalseWhenLaterPairDoesNotMatchPredicate() {
        let l1 = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty
        let l2 = 2 +| 4 +| 7 +| 8 +| LinkedList<Int>.empty
        var checkedPairs: [(Int, Int)] = []

        let result = forAll2({ value1, value2 in
            checkedPairs.append((value1, value2))
            return value2 == value1 * 2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(!value)
        } else {
            #expect(Bool(false))
        }
        #expect(checkedPairs.count == 3)
        #expect(checkedPairs[0].0 == 1)
        #expect(checkedPairs[0].1 == 2)
        #expect(checkedPairs[1].0 == 2)
        #expect(checkedPairs[1].1 == 4)
        #expect(checkedPairs[2].0 == 3)
        #expect(checkedPairs[2].1 == 7)
    }

    @Test func forAll2ReturnsList1TooShortWhenFirstListEndsFirst() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = 2 +| 4 +| LinkedList<Int>.empty
        var callCount = 0

        let result = forAll2({ value1, value2 in
            callCount += 1
            return value2 == value1 * 2
        }, l1, l2)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func forAll2ReturnsList2TooShortWhenSecondListEndsFirst() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 2 +| LinkedList<Int>.empty
        var callCount = 0

        let result = forAll2({ value1, value2 in
            callCount += 1
            return value2 == value1 * 2
        }, l1, l2)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func forAll2WorksWithDifferentElementTypes() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = "1" +| "2" +| LinkedList<String>.empty

        let result = forAll2({ value1, value2 in
            String(value1) == value2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(value)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func forAll2DoesNotChangeOriginalLists() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 2 +| 4 +| LinkedList<Int>.empty

        _ = forAll2({ value1, value2 in value2 == value1 * 2 }, l1, l2)

        #expect(nthOpt(0, l1) == 1)
        #expect(nthOpt(1, l1) == 2)
        #expect(nthOpt(0, l2) == 2)
        #expect(nthOpt(1, l2) == 4)
    }

    @Test func existsReturnsFalseForEmptyList() {
        let list = LinkedList<Int>.empty
        var callCount = 0

        let result = exists({ _ in
            callCount += 1
            return true
        }, list)

        #expect(!result)
        #expect(callCount == 0)
    }

    @Test func existsReturnsTrueWhenFirstElementMatchesPredicate() {
        let list = 2 +| 3 +| 5 +| LinkedList<Int>.empty
        var callCount = 0

        let result = exists({ value in
            callCount += 1
            return value.isMultiple(of: 2)
        }, list)

        #expect(result)
        #expect(callCount == 1)
    }

    @Test func existsReturnsTrueWhenLaterElementMatchesPredicate() {
        let list = 1 +| 3 +| 4 +| 6 +| LinkedList<Int>.empty
        var checkedValues: [Int] = []

        let result = exists({ value in
            checkedValues.append(value)
            return value.isMultiple(of: 2)
        }, list)

        #expect(result)
        #expect(checkedValues == [1, 3, 4])
    }

    @Test func existsReturnsFalseWhenNoElementMatchesPredicate() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        let result = exists({ value in
            value.isMultiple(of: 2)
        }, list)

        #expect(!result)
    }

    @Test func existsWorksWithNonIntegerValues() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = exists({ value in
            value.hasPrefix("b")
        }, list)

        #expect(result)
    }

    @Test func existsDoesNotChangeOriginalList() {
        let list = 1 +| 3 +| 5 +| LinkedList<Int>.empty

        _ = exists({ value in value.isMultiple(of: 2) }, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 3)
        #expect(nthOpt(2, list) == 5)
    }

    @Test func existsOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> existsOf { value in
            value.hasPrefix("b")
        }

        #expect(result)
    }

    @Test func exists2ReturnsFalseForTwoEmptyLists() {
        let l1 = LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = exists2({ _, _ in
            callCount += 1
            return true
        }, l1, l2)

        if case .success(let value) = result {
            #expect(!value)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func exists2ReturnsTrueWhenFirstPairMatchesPredicate() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 2 +| 4 +| 6 +| LinkedList<Int>.empty
        var callCount = 0

        let result = exists2({ value1, value2 in
            callCount += 1
            return value2 == value1 * 2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(value)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func exists2ReturnsTrueWhenLaterPairMatchesPredicate() {
        let l1 = 1 +| 2 +| 3 +| 4 +| LinkedList<Int>.empty
        let l2 = 3 +| 5 +| 6 +| 8 +| LinkedList<Int>.empty
        var checkedPairs: [(Int, Int)] = []

        let result = exists2({ value1, value2 in
            checkedPairs.append((value1, value2))
            return value2 == value1 * 2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(value)
        } else {
            #expect(Bool(false))
        }
        #expect(checkedPairs.count == 3)
        #expect(checkedPairs[0].0 == 1)
        #expect(checkedPairs[0].1 == 3)
        #expect(checkedPairs[1].0 == 2)
        #expect(checkedPairs[1].1 == 5)
        #expect(checkedPairs[2].0 == 3)
        #expect(checkedPairs[2].1 == 6)
    }

    @Test func exists2ReturnsFalseWhenNoPairMatchesPredicate() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 3 +| 5 +| 7 +| LinkedList<Int>.empty

        let result = exists2({ value1, value2 in
            value2 == value1 * 2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(!value)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func exists2ReturnsList1TooShortWhenFirstListEndsFirstWithoutMatch() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = 3 +| 5 +| LinkedList<Int>.empty
        var callCount = 0

        let result = exists2({ value1, value2 in
            callCount += 1
            return value2 == value1 * 2
        }, l1, l2)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func exists2ReturnsList2TooShortWhenSecondListEndsFirstWithoutMatch() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 3 +| LinkedList<Int>.empty
        var callCount = 0

        let result = exists2({ value1, value2 in
            callCount += 1
            return value2 == value1 * 2
        }, l1, l2)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func exists2ReturnsTrueBeforeLengthMismatchWhenPairMatches() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = 2 +| 4 +| LinkedList<Int>.empty
        var callCount = 0

        let result = exists2({ value1, value2 in
            callCount += 1
            return value2 == value1 * 2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(value)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func exists2WorksWithDifferentElementTypes() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = "one" +| "2" +| LinkedList<String>.empty

        let result = exists2({ value1, value2 in
            String(value1) == value2
        }, l1, l2)

        if case .success(let value) = result {
            #expect(value)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func exists2DoesNotChangeOriginalLists() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 3 +| 4 +| LinkedList<Int>.empty

        _ = exists2({ value1, value2 in value2 == value1 * 2 }, l1, l2)

        #expect(nthOpt(0, l1) == 1)
        #expect(nthOpt(1, l1) == 2)
        #expect(nthOpt(0, l2) == 3)
        #expect(nthOpt(1, l2) == 4)
    }

    @Test func memReturnsTrueWhenListContainsValue() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = mem(2, list)

        #expect(result)
    }

    @Test func memReturnsFalseWhenListDoesNotContainValue() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        let result = mem(4, list)

        #expect(!result)
    }

    @Test func memUsesEquatableValueEquality() {
        let first = Box(1)
        let second = Box(2)
        let equalButDifferentInstance = Box(1)
        let list = first +| second +| LinkedList<Box>.empty

        let result = mem(equalButDifferentInstance, list)

        #expect(result)
    }

    @Test func memOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> memOf("banana")

        #expect(result)
    }

    @Test func memQReturnsTrueForSameObjectInstance() {
        let first = Box(1)
        let second = Box(2)
        let list = first +| second +| LinkedList<Box>.empty

        let result = memQ(first, list)

        #expect(result)
    }

    @Test func memQReturnsFalseForEqualButDifferentObjectInstance() {
        let first = Box(1)
        let second = Box(2)
        let equalButDifferentInstance = Box(1)
        let list = first +| second +| LinkedList<Box>.empty

        let result = memQ(equalButDifferentInstance, list)

        #expect(!result)
    }

    @Test func memQOfCanBeUsedWithPipeForward() {
        let first = Box(1)
        let second = Box(2)
        let list = first +| second +| LinkedList<Box>.empty

        let result = list |> memQOf(second)

        #expect(result)
    }

    @Test func memByReturnsTrueWhenCustomEqualityMatches() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = memBy({ element, value in
            element.first == value.first
        }, "apricot", list)

        #expect(result)
    }

    @Test func memByReturnsFalseWhenCustomEqualityDoesNotMatch() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = memBy({ element, value in
            element.first == value.first
        }, "cherry", list)

        #expect(!result)
    }

    @Test func memByOfCanBeUsedWithPipeForward() {
        let list = "apple" +| "banana" +| "avocado" +| LinkedList<String>.empty

        let result = list |> memByOf({ element, value in
            element.count == value.count
        }, "orange")

        #expect(result)
    }

    @Test func memHelpersDoNotChangeOriginalList() {
        let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty

        _ = mem(2, list)
        _ = memBy({ element, value in element == value }, 3, list)

        #expect(nthOpt(0, list) == 1)
        #expect(nthOpt(1, list) == 2)
        #expect(nthOpt(2, list) == 3)
    }
}
