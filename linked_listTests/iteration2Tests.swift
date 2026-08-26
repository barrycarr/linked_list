//
//  iteration2Tests.swift
//  linked_listTests
//
//  Created by Barry Carr on 26/08/2026.
//

import Testing
@testable import linked_list

struct Iteration2Tests {

    @Test func iter2ReturnsSuccessForTwoEmptyLists() {
        let l1 = LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = iter2({ _, _ in callCount += 1 }, l1, l2)

        if case .success = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func iter2CallsFunctionForEachPairInOrder() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = "a" +| "b" +| "c" +| LinkedList<String>.empty
        var pairs: [(Int, String)] = []

        let result = iter2({ value1, value2 in
            pairs.append((value1, value2))
        }, l1, l2)

        if case .success = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(pairs.count == 3)
        #expect(pairs[0].0 == 1)
        #expect(pairs[0].1 == "a")
        #expect(pairs[1].0 == 2)
        #expect(pairs[1].1 == "b")
        #expect(pairs[2].0 == 3)
        #expect(pairs[2].1 == "c")
    }

    @Test func iter2ReturnsFailureWhenFirstListIsTooShort() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = "a" +| "b" +| LinkedList<String>.empty
        var pairs: [(Int, String)] = []

        let result = iter2({ value1, value2 in
            pairs.append((value1, value2))
        }, l1, l2)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(pairs.count == 1)
        #expect(pairs[0].0 == 1)
        #expect(pairs[0].1 == "a")
    }

    @Test func iter2ReturnsFailureWhenSecondListIsTooShort() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = "a" +| LinkedList<String>.empty
        var pairs: [(Int, String)] = []

        let result = iter2({ value1, value2 in
            pairs.append((value1, value2))
        }, l1, l2)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(pairs.count == 1)
        #expect(pairs[0].0 == 1)
        #expect(pairs[0].1 == "a")
    }

    @Test func iter2ReturnsList1TooShortWhenOnlySecondListHasValues() {
        let l1 = LinkedList<Int>.empty
        let l2 = "a" +| LinkedList<String>.empty
        var callCount = 0

        let result = iter2({ _, _ in callCount += 1 }, l1, l2)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func iter2ReturnsList2TooShortWhenOnlyFirstListHasValues() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = iter2({ _, _ in callCount += 1 }, l1, l2)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func map2ReturnsEmptyListForTwoEmptyLists() {
        let l1 = LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = map2({ value1, value2 in
            callCount += 1
            return "\(value1):\(value2)"
        }, l1, l2)

        if case .success(let mapped) = result {
            #expect(isEmpty(list: mapped))
            #expect(length(list: mapped) == 0)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func revMap2ReturnsEmptyListForTwoEmptyLists() {
        let l1 = LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = revMap2({ value1, value2 in
            callCount += 1
            return "\(value1):\(value2)"
        }, l1, l2)

        if case .success(let mapped) = result {
            #expect(isEmpty(list: mapped))
            #expect(length(list: mapped) == 0)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func map2MapsPairsInOrder() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = map2({ value1, value2 in
            value1 + value2
        }, l1, l2)

        if case .success(let mapped) = result {
            #expect(length(list: mapped) == 3)
            #expect(nthOpt(n: 0, list: mapped) == 11)
            #expect(nthOpt(n: 1, list: mapped) == 22)
            #expect(nthOpt(n: 2, list: mapped) == 33)
            #expect(nthOpt(n: 3, list: mapped) == nil)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func revMap2MapsPairsInReverseOrder() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = revMap2({ value1, value2 in
            value1 + value2
        }, l1, l2)

        if case .success(let mapped) = result {
            #expect(length(list: mapped) == 3)
            #expect(nthOpt(n: 0, list: mapped) == 33)
            #expect(nthOpt(n: 1, list: mapped) == 22)
            #expect(nthOpt(n: 2, list: mapped) == 11)
            #expect(nthOpt(n: 3, list: mapped) == nil)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func map2CanTransformElementTypes() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = "a" +| "b" +| LinkedList<String>.empty

        let result = map2({ value1, value2 in
            "\(value2)-\(value1)"
        }, l1, l2)

        if case .success(let mapped) = result {
            #expect(length(list: mapped) == 2)
            #expect(nthOpt(n: 0, list: mapped) == "a-1")
            #expect(nthOpt(n: 1, list: mapped) == "b-2")
            #expect(nthOpt(n: 2, list: mapped) == nil)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func revMap2CanTransformElementTypes() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = "a" +| "b" +| LinkedList<String>.empty

        let result = revMap2({ value1, value2 in
            "\(value2)-\(value1)"
        }, l1, l2)

        if case .success(let mapped) = result {
            #expect(length(list: mapped) == 2)
            #expect(nthOpt(n: 0, list: mapped) == "b-2")
            #expect(nthOpt(n: 1, list: mapped) == "a-1")
            #expect(nthOpt(n: 2, list: mapped) == nil)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func map2ReturnsFailureWhenFirstListIsTooShort() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty
        var callCount = 0

        let result = map2({ value1, value2 in
            callCount += 1
            return value1 + value2
        }, l1, l2)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func revMap2ReturnsFailureWhenFirstListIsTooShort() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty
        var callCount = 0

        let result = revMap2({ value1, value2 in
            callCount += 1
            return value1 + value2
        }, l1, l2)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func map2ReturnsFailureWhenSecondListIsTooShort() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| LinkedList<Int>.empty
        var callCount = 0

        let result = map2({ value1, value2 in
            callCount += 1
            return value1 + value2
        }, l1, l2)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func revMap2ReturnsFailureWhenSecondListIsTooShort() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| LinkedList<Int>.empty
        var callCount = 0

        let result = revMap2({ value1, value2 in
            callCount += 1
            return value1 + value2
        }, l1, l2)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func map2DoesNotChangeOriginalLists() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty

        _ = map2({ value1, value2 in value1 + value2 }, l1, l2)

        #expect(nthOpt(n: 0, list: l1) == 1)
        #expect(nthOpt(n: 1, list: l1) == 2)
        #expect(nthOpt(n: 0, list: l2) == 10)
        #expect(nthOpt(n: 1, list: l2) == 20)
    }

    @Test func revMap2DoesNotChangeOriginalLists() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty

        _ = revMap2({ value1, value2 in value1 + value2 }, l1, l2)

        #expect(nthOpt(n: 0, list: l1) == 1)
        #expect(nthOpt(n: 1, list: l1) == 2)
        #expect(nthOpt(n: 0, list: l2) == 10)
        #expect(nthOpt(n: 1, list: l2) == 20)
    }

    @Test func foldLeft2ReturnsAccumulatorForTwoEmptyLists() {
        let l1 = LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = foldLeft2({ acc, value1, value2 in
            callCount += 1
            return "\(acc):\(value1):\(value2)"
        }, "start", l1, l2)

        if case .success(let acc) = result {
            #expect(acc == "start")
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func foldLeft2ThreadsAccumulatorFromLeftToRight() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = foldLeft2({ acc, value1, value2 in
            acc - value1 - value2
        }, 0, l1, l2)

        if case .success(let acc) = result {
            #expect(acc == -66)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func foldLeft2CanUseDifferentElementTypes() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = "a" +| "bb" +| LinkedList<String>.empty

        let result = foldLeft2({ acc, value1, value2 in
            acc + "[\(value1):\(value2)]"
        }, "", l1, l2)

        if case .success(let acc) = result {
            #expect(acc == "[1:a][2:bb]")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func foldLeft2ReturnsFailureWhenFirstListIsTooShort() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty
        var callCount = 0

        let result = foldLeft2({ acc, value1, value2 in
            callCount += 1
            return acc + value1 + value2
        }, 0, l1, l2)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func foldLeft2ReturnsFailureWhenSecondListIsTooShort() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| LinkedList<Int>.empty
        var callCount = 0

        let result = foldLeft2({ acc, value1, value2 in
            callCount += 1
            return acc + value1 + value2
        }, 0, l1, l2)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 1)
    }

    @Test func foldLeft2DoesNotChangeOriginalLists() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty

        _ = foldLeft2({ acc, value1, value2 in
            acc + value1 + value2
        }, 0, l1, l2)

        #expect(nthOpt(n: 0, list: l1) == 1)
        #expect(nthOpt(n: 1, list: l1) == 2)
        #expect(nthOpt(n: 0, list: l2) == 10)
        #expect(nthOpt(n: 1, list: l2) == 20)
    }

    @Test func foldRight2ReturnsAccumulatorForTwoEmptyLists() {
        let l1 = LinkedList<Int>.empty
        let l2 = LinkedList<String>.empty
        var callCount = 0

        let result = foldRight2({ value1, value2, acc in
            callCount += 1
            return "\(value1):\(value2):\(acc)"
        }, l1, l2, "start")

        if case .success(let acc) = result {
            #expect(acc == "start")
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func foldRight2ThreadsAccumulatorFromRightToLeft() {
        let l1 = 1 +| 2 +| 3 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| 30 +| LinkedList<Int>.empty

        let result = foldRight2({ value1, value2, acc in
            value1 + value2 - acc
        }, l1, l2, 0)

        if case .success(let acc) = result {
            #expect(acc == 22)
        } else {
            #expect(Bool(false))
        }
    }

    @Test func foldRight2CanUseDifferentElementTypes() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = "a" +| "bb" +| LinkedList<String>.empty

        let result = foldRight2({ value1, value2, acc in
            "[\(value1):\(value2)]" + acc
        }, l1, l2, "")

        if case .success(let acc) = result {
            #expect(acc == "[1:a][2:bb]")
        } else {
            #expect(Bool(false))
        }
    }

    @Test func foldRight2ReturnsFailureWhenFirstListIsTooShort() {
        let l1 = 1 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty
        var callCount = 0

        let result = foldRight2({ value1, value2, acc in
            callCount += 1
            return value1 + value2 + acc
        }, l1, l2, 0)

        if case .failure(.list1TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func foldRight2ReturnsFailureWhenSecondListIsTooShort() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| LinkedList<Int>.empty
        var callCount = 0

        let result = foldRight2({ value1, value2, acc in
            callCount += 1
            return value1 + value2 + acc
        }, l1, l2, 0)

        if case .failure(.list2TooShort) = result {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
        #expect(callCount == 0)
    }

    @Test func foldRight2DoesNotChangeOriginalLists() {
        let l1 = 1 +| 2 +| LinkedList<Int>.empty
        let l2 = 10 +| 20 +| LinkedList<Int>.empty

        _ = foldRight2({ value1, value2, acc in
            value1 + value2 + acc
        }, l1, l2, 0)

        #expect(nthOpt(n: 0, list: l1) == 1)
        #expect(nthOpt(n: 1, list: l1) == 2)
        #expect(nthOpt(n: 0, list: l2) == 10)
        #expect(nthOpt(n: 1, list: l2) == 20)
    }
}
