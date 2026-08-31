# ``linked_list``

An OCaml-inspired immutable linked list library for Swift.

## Overview

The `linked_list` module provides an immutable recursive list type and a set of
OCaml-style helper functions for constructing, transforming, searching,
combining, and sorting lists.

The core type is ``LinkedList``:

```swift
let list = 1 +| 2 +| 3 +| LinkedList<Int>.empty
```

Because ``LinkedList`` is an enum, lists can be pattern matched directly:

```swift
switch list {
case .empty:
    print("empty")
case .cons(let head, let tail):
    print(head, tail)
}
```

Most functions follow the same broad conventions as OCaml's `List` module.
Functions that may fail return `Result` with ``LinkedListError``. Optional
variants, such as ``nthOpt(_:_:)`` and ``findOpt(_:_:)``, return `nil` when no
value is available.

`LinkedList` also conforms to Swift's `Sequence` protocol, so it can be used
with `for` loops and converted to standard Swift collections:

```swift
for value in list {
    print(value)
}

let array = toArray(list)
let fromArray = ofArray([1, 2, 3])
```

## Topics

### Core Types

- ``LinkedList``
- ``LinkedListError``
- ``Either``

### Basic List Functions

- ``empty()``
- ``head(_:)``
- ``tail(_:)``
- ``length(_:)``
- ``isEmpty(_:)``
- ``nth(_:_:)``
- ``nthOpt(_:_:)``
- ``singleton(_:)``
- ``reverse(_:)``
- ``append(_:_:)``
- ``revAppend(_:_:)``
- ``concat(_:)``
- ``flatten(_:)``

### Iteration And Mapping

- ``iter(_:_:)``
- ``iterI(_:_:)``
- ``map(_:_:)``
- ``mapI(_:_:)``
- ``reverseMap(_:_:)``
- ``filterMap(_:_:)``
- ``filterMapI(_:_:)``
- ``concatMap(_:_:)``
- ``foldLeft(_:_:_:)``
- ``foldLeftMap(_:_:_:)``
- ``foldRight(_:_:_:)``

### Two-List Operations

- ``iter2(_:_:_:)``
- ``map2(_:_:_:)``
- ``revMap2(_:_:_:)``
- ``foldLeft2(_:_:_:_:)``
- ``foldRight2(_:_:_:_:)``

### Searching And Scanning

- ``forAll(_:_:)``
- ``forAll2(_:_:_:)``
- ``exists(_:_:)``
- ``exists2(_:_:_:)``
- ``mem(_:_:)``
- ``memQ(_:_:)``
- ``memBy(_:_:_:)``
- ``find(_:_:)``
- ``findOpt(_:_:)``
- ``findIndex(_:_:)``
- ``findMap(_:_:)``
- ``findMapI(_:_:)``
- ``filter(_:_:)``
- ``findAll(_:_:)``
- ``filterI(_:_:)``

### Manipulation

- ``take(_:_:)``
- ``drop(_:_:)``
- ``takeWhile(_:_:)``
- ``dropWhile(_:_:)``
- ``partition(_:_:)``
- ``partitionMap(_:_:)``

### Association Lists

- ``assocOpt(_:_:)``
- ``assoc(_:_:)``
- ``assqOpt(_:_:)``
- ``assq(_:_:)``
- ``memAssoc(_:_:)``
- ``memAssq(_:_:)``
- ``removeAssoc(_:_:)``
- ``removeAssq(_:_:)``

### Pair Helpers

- ``split(_:)``
- ``splitMap(_:_:)``
- ``combine(_:_:)``

### Sorting

- ``merge(_:_:_:)``
- ``sort(_:_:)``
- ``stableSort(_:_:)``
- ``fastSort(_:_:)``

### Swift Sequences And Collections

- ``LinkedList/makeIterator()``
- ``ofArray(_:)``
- ``toArray(_:)``
- ``ofCollection(_:)``
- ``ofSeq(_:)``

### Pipe-Forward Helpers

- ``nthOf(_:)``
- ``nthOfOpt(_:)``
- ``appendTo(_:)``
- ``revAppendTo(_:)``
- ``iterOf(_:)``
- ``iterIOf(_:)``
- ``mapOf(_:)``
- ``mapIOf(_:)``
- ``reverseMapOf(_:)``
- ``filterMapOf(_:)``
- ``filterMapIOf(_:)``
- ``concatMapOf(_:)``
- ``foldLeftOf(_:_:)``
- ``foldLeftMapOf(_:_:)``
- ``foldRightOf(_:_:)``
- ``forAllOf(_:)``
- ``existsOf(_:)``
- ``memOf(_:)``
- ``memQOf(_:)``
- ``memByOf(_:_:)``
- ``findOf(_:)``
- ``findOptOf(_:)``
- ``findIndexOf(_:)``
- ``findMapOf(_:)``
- ``findMapIOf(_:)``
- ``filterOf(_:)``
- ``findAllOf(_:)``
- ``filterIOf(_:)``
- ``takeOf(_:)``
- ``dropOf(_:)``
- ``takeWhileOf(_:)``
- ``dropWhileOf(_:)``
- ``partitionOf(_:)``
- ``partitionMapOf(_:)``
- ``assocOptOf(_:)``
- ``assocOf(_:)``
- ``assqOptOf(_:)``
- ``assqOf(_:)``
- ``memAssocOf(_:)``
- ``memAssqOf(_:)``
- ``removeAssocOf(_:)``
- ``removeAssqOf(_:)``
- ``splitMapOf(_:)``
- ``mergeOf(_:_:)``
- ``sortOf(_:)``
- ``stableSortOf(_:)``
- ``fastSortOf(_:)``
