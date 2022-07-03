// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SpyxTCA",
  platforms: [.macOS(.v10_15)],
  products: [
    .library(
      name: "SpyxTCA",
      targets: ["SpyxTCA"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.0.1"),
  ],
  targets: [
    .target(
      name: "SpyxTCA",
      dependencies: [
        .product(name: "ComposableArchitecture",
                 package: "swift-composable-architecture"),
      ]),
    .testTarget(
      name: "SpyxTCATests",
      dependencies: ["SpyxTCA", .
        product(name: "ComposableArchitecture",
                package: "swift-composable-architecture")]),
  ])
