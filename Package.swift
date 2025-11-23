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
            path: "Sources/_Dummy",
            linkerSettings: [
                .linkedFramework("Foundation"),
                .linkedFramework("Metal"),
                .linkedFramework("Accelerate"),
                .linkedFramework("CoreML"),
            ]
        ),
        //AUTO_GENERATE_TARGETS_BEGIN//

        .binaryTarget(
            name: "Libwhisper-combined",
            url: "https://github.com/mpvkit/whisper-build/releases/download/1.8.2/Libwhisper-combined.xcframework.zip",
            checksum: "70ab3a5d6fa051ffab2aa7c434ee6834cf9fa9133657902afc0e7925ac8a712d"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)