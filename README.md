# linked_list

An OCaml-inspired immutable linked list library for Swift. It's based on the list module in OCaml 5.5

I wrote this to learn Swift; I don't expect anyone to use it except for interest and reference. This code makes heavy use of recursion, so you'll want to ensure that the appropriate optimisations are enabled to ensure that tail calls are utilised. 

Should you use it? Probably not; Swift has perfectly good data structures that do the same job as this linked list. I did this as a purely academic exercise. That being said, if you want to use it, the code comes with absolutely no warranty; use it at your own risk.  

The core type is a recursive enum:

```swift
public indirect enum LinkedList<T> {
    case empty
    case cons(T, LinkedList<T>)
}
```

This makes the list easy to pattern match:

```swift
switch list {
case .empty:
    print("empty")
case .cons(let head, let tail):
    print("head:", head)
    print("tail:", tail)
}
```

## Creating Lists

Use `.empty` and `.cons` directly, or use the `+|` cons operator:

```swift
let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
```

There are also helpers for common construction:

```swift
let emptyList: LinkedList<Int> = empty()
let oneItem = singleton(42)
```

## Swift Sequences And Collections

`LinkedList` conforms to Swift's `Sequence` protocol, so it can be used in `for` loops and with standard library APIs that consume sequences:

```swift
for value in list {
    print(value)
}

let values = Array(list)
```

Conversion helpers are available for common Swift collection and sequence types:

```swift
let fromArray = ofArray([1, 2, 3])
let fromCollection = ofCollection([1, 2, 3][1...])
let fromSequence = ofSeq(1...3)

let array = toArray(list)
```

`ofSeq` accepts any `Sequence`; `ofCollection` accepts collection types such as arrays, array slices, sets, and ranges.

## Documentation

Public types and functions include Swift documentation comments. In Xcode, use Quick Help or build generated documentation for detailed behavior, parameters, return values, and failure cases.

## Swift Package Manager

The project includes a `Package.swift` manifest, so it can be built and tested with Swift Package Manager:

```sh
swift build
swift test
```

The package uses the existing `linked_list` source directory and `linked_listTests` test directory as SwiftPM targets.

## Operators

| Operator | Purpose | Example |
| --- | --- | --- |
| `+|` | Cons a value onto the front of a list | `1 +| list` |
| `<>` | Append two lists | `left <> right` |
| `|>` | Pipe-forward operator | `list |> mapOf { $0 * 2 }` |

## Basic Functions

The library includes OCaml-style list helpers:

```swift
head(list)
tail(list)
length(list)
isEmpty(list)
nth(2, list)
nthOpt(2, list)
reverse(list)
append(left, right)
concat(lists)
flatten(lists)
```

Functions that can fail return `Result`, while optional variants return `nil` for missing values.

## Iteration And Mapping

```swift
iter({ print($0) }, list)
iterI({ index, value in print(index, value) }, list)

let doubled = map({ $0 * 2 }, list)
let indexed = mapI({ index, value in index + value }, list)
let reversed = reverseMap({ $0 * 2 }, list)
let filtered = filterMap({ $0.isMultiple(of: 2) ? String($0) : nil }, list)
```

Most higher-order functions also have pipe-forward helpers:

```swift
let doubled = list |> mapOf { $0 * 2 }
let total = list |> foldLeftOf({ acc, value in acc + value }, 0)
```

## Searching And Filtering

```swift
let firstEven = findOpt({ $0.isMultiple(of: 2) }, list)
let firstEvenResult = find({ $0.isMultiple(of: 2) }, list)
let firstEvenIndex = findIndex({ $0.isMultiple(of: 2) }, list)

let evens = filter({ $0.isMultiple(of: 2) }, list)
let allEvens = findAll({ $0.isMultiple(of: 2) }, list)
let indexedFilter = filterI({ index, _ in index.isMultiple(of: 2) }, list)
```

## Scanning

```swift
forAll({ $0 > 0 }, list)
exists({ $0 == 3 }, list)
mem(3, list)
memBy({ lhs, rhs in lhs.lowercased() == rhs.lowercased() }, "apple", words)
```

Two-list scanning functions return `Result` so mismatched lengths can be reported:

```swift
forAll2({ lhs, rhs in lhs == rhs }, left, right)
exists2({ lhs, rhs in lhs < rhs }, left, right)
```

## Association Lists

Association-list helpers work on lists of key/value tuples:

```swift
let entries =
    ("one", 1)
    +| ("two", 2)
    +| ("three", 3)
    +| LinkedList<(String, Int)>.empty

let value = assocOpt("two", entries)
let result = assoc("two", entries)
let exists = memAssoc("two", entries)
let removed = removeAssoc("two", entries)
```

`assoc` returns a `Result`, while `assocOpt` returns `nil` when the key is not found. `removeAssoc` removes the first matching binding and preserves the rest of the list.

The `assq` variants use object identity with `===` instead of value equality:

```swift
let value = assqOpt(objectKey, entries)
let result = assq(objectKey, entries)
let exists = memAssq(objectKey, entries)
let removed = removeAssq(objectKey, entries)
```

Pipe-forward helpers are available for both equality and identity variants:

```swift
let value = entries |> assocOptOf("two")
let exists = entries |> memAssocOf("two")
let removed = entries |> removeAssocOf("two")
```

## Manipulation

```swift
take(3, list)
drop(2, list)
takeWhile({ $0 < 10 }, list)
dropWhile({ $0 < 10 }, list)

let (evens, odds) = partition({ $0.isMultiple(of: 2) }, list)
```

`partitionMap` uses the project’s generic `Either` type:

```swift
let (numbers, words) = partitionMap({ value in
    if let number = Int(value) {
        return Either<Int, String>.left(number)
    }
    return Either<Int, String>.right(value)
}, input)
```

## Two-List Operations

```swift
iter2({ lhs, rhs in print(lhs, rhs) }, left, right)
map2({ lhs, rhs in lhs + rhs }, left, right)
revMap2({ lhs, rhs in lhs + rhs }, left, right)
foldLeft2({ acc, lhs, rhs in acc + lhs + rhs }, 0, left, right)
foldRight2({ lhs, rhs, acc in acc + lhs + rhs }, left, right, 0)
```

These functions return `Result` where mismatched input lengths are possible.

## Pair Helpers

Pair helpers convert between lists of tuples and tuples of lists:

```swift
let pairs =
    (1, "one")
    +| (2, "two")
    +| (3, "three")
    +| LinkedList<(Int, String)>.empty

let (numbers, words) = split(pairs)
```

`splitMap` maps each input value to a pair, then splits the pair components into separate lists:

```swift
let (lengths, uppercased) = splitMap({ word in
    (word.count, word.uppercased())
}, words)

let piped = words |> splitMapOf { word in
    (word.count, word.uppercased())
}
```

`combine` zips two lists into a list of tuples:

```swift
let pairs = combine(numbers, words)
```

`combine` returns `Result` because it fails when the input lists have different lengths.

## Sorting

Sorting functions take a comparison closure that returns a negative value when the first value is smaller, zero when the values compare equal, and a positive value when the first value is greater:

```swift
let sorted = sort({ lhs, rhs in lhs - rhs }, list)
let descending = sort({ lhs, rhs in rhs - lhs }, list)
```

`stableSort` and `fastSort` are aliases for the same stable merge-sort implementation:

```swift
let sorted = stableSort({ lhs, rhs in lhs - rhs }, list)
let alsoSorted = fastSort({ lhs, rhs in lhs - rhs }, list)
```

`merge` combines two lists that are already sorted according to the same comparison function:

```swift
let merged = merge({ lhs, rhs in lhs - rhs }, leftSorted, rightSorted)
```

Pipe-forward helpers are available:

```swift
let sorted = list |> sortOf { lhs, rhs in lhs - rhs }
let stable = list |> stableSortOf { lhs, rhs in lhs - rhs }
let fast = list |> fastSortOf { lhs, rhs in lhs - rhs }
let merged = rightSorted |> mergeOf({ lhs, rhs in lhs - rhs }, leftSorted)
```

## Comparison

```swift
compareLengths(left, right)
compareLengthWith(list, len: 3)
equal({ $0 == $1 }, left, right)
compare({ lhs, rhs in lhs - rhs }, left, right)
```

## Testing

This project uses Swift Testing and can be tested from Xcode or Swift Package Manager.

Open the project:

```sh
open linked_list.xcodeproj
```

Then run the `linked_list` test plan from Xcode.

To run the tests with Swift Package Manager:

```sh
swift test
```

The current test suite covers the public list functions across basic operations, comparison, iteration, two-list iteration, pair helpers, scanning, searching, association lists, manipulation, sorting, sequences, conversions, and operators.
