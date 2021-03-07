// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftlyAttributedStrings",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "SwiftlyAttributedStrings", targets: ["SwiftlyAttributedStrings"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftlyAttributedStrings"
        )
    ]
)
