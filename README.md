# linked_list

An OCaml-inspired immutable linked list library for Swift.

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

## Operators

| Operator | Purpose | Example |
| --- | --- | --- |
| `+|` | Cons a value onto the front of a list | `1 +| list` |
| `<>` | Append two lists | `left <> right` |
| `|>` | Pipe-forward operator | `list |> mapOf { $0 * 2 }` |

## Basic Functions

The library includes OCaml-style list helpers:

```swift
head(list: list)
tail(list: list)
length(list: list)
isEmpty(list: list)
nth(n: 2, list: list)
nthOpt(n: 2, list: list)
reverse(list)
append(l0: left, l1: right)
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

## Comparison

```swift
compareLengths(left, right)
compareLengthWith(list, len: 3)
equal({ $0 == $1 }, left, right)
compare({ lhs, rhs in lhs - rhs }, left, right)
```

## Testing

This is an Xcode project using Swift Testing.

Open the project:

```sh
open linked_list.xcodeproj
```

Then run the `linked_list` test plan from Xcode.

The current test suite covers the public list functions across basic operations, comparison, iteration, two-list iteration, scanning, searching, association lists, manipulation, and operators.
