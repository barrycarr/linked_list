// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "linked_list",
    products: [
        .library(
            name: "linked_list",
            targets: ["linked_list"]
        )
    ],
    targets: [
        .target(
            name: "linked_list",
            path: "linked_list"
        ),
        .testTarget(
            name: "linked_listTests",
            dependencies: ["linked_list"],
            path: "linked_listTests"
        )
    ]
)
