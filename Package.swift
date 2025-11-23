// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "whisper",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: [
        .library(
            name: "whisper",
            targets: ["_whisper"]
        ),
    ],
    targets: [
        // Need a dummy target to embedded correctly.
        // https://github.com/apple/swift-package-manager/issues/6069
        .target(
            name: "_whisper",
            dependencies: ["Libwhisper-combined"],
            path: "Sources/_Dummy"
        ),
        //AUTO_GENERATE_TARGETS_BEGIN//

        .binaryTarget(
            name: "Libwhisper-combined",
            url: "https://github.com/mpvkit/whisper-build/releases/download/1.8.2/Libwhisper-combined.xcframework.zip",
            checksum: "3f5bd7d100c8a9c7f68dec3642b1f63e82dda9d2942dc82dd33eee295fded947"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)