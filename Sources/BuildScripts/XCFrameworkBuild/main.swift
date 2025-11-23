import Foundation
import Darwin

do {
    let options = try ArgumentOptions.parse(CommandLine.arguments)
    try Build.performCommand(options)

    try BuildWhisper().buildALL()
} catch {
    print(error.localizedDescription)
    exit(1)
}


enum Library: String, CaseIterable {
    case whisper
    var version: String {
        switch self {
        case .whisper:
            return "v1.8.2"
        }
    }

    var url: String {
        switch self {
        case .whisper:
            return "https://github.com/ggml-org/whisper.cpp"
        }
    }


    // for generate Package.swift
    var targets : [PackageTarget] {
        switch self {
        case .whisper:
            return  [
                .target(
                    name: "Libwhisper-combined",
                    url: "https://github.com/mpvkit/whisper-build/releases/download/\(BaseBuild.options.releaseVersion)/Libwhisper-combined.xcframework.zip",
                    checksum: "https://github.com/mpvkit/whisper-build/releases/download/\(BaseBuild.options.releaseVersion)/Libwhisper-combined.xcframework.checksum.txt"
                ),
            ]
        }
    }
}



private class BuildWhisper: CombineBaseBuild {
    init() {
        super.init(library: .whisper)
    }

    override func beforeBuild() throws {
        try super.beforeBuild()

        if Utility.shell("which sdl2-config") == nil {
            Utility.shell("brew install sdl2")
        }
    }

    override func build(platform: PlatformType, arch: ArchType) throws {
        try super.build(platform: platform, arch: arch)

        let frameworks = ["Foundation", "Metal", "Accelerate", "CoreML"]
        let libframework = frameworks.map {
            "-framework \($0)"
        }.joined(separator: " ")

        // Append the string "libframework" to the end of the Libs line.
        let thinLibPath = thinDir(platform: platform, arch: arch) + ["lib"]
        let pkgconfigPath = thinLibPath + ["pkgconfig", "\(library.rawValue).pc"]
        var pkgconfigContent = try String(contentsOf: pkgconfigPath)
        var arr = pkgconfigContent.components(separatedBy: "\n")
        for (index, line) in arr.enumerated() {
            if line.starts(with: "Libs:") {
                arr[index] = line + " " + libframework
                break
            }
        }
        pkgconfigContent = arr.joined(separator: "\n")
        try pkgconfigContent.write(to: pkgconfigPath, atomically: true, encoding: .utf8)
    }

    override func frameworks() throws -> [String] {
        ["libwhisper-combined"]
    }

    override func combineFrameworkName() -> String {
        "libwhisper-combined.a"
    }

    override func arguments(platform : PlatformType, arch : ArchType) -> [String] {
        [
            "-DGGML_METAL=ON",
            "-DGGML_METAL_USE_BF16=ON",
            "-DGGML_BLAS_DEFAULT=ON",
            "-DGGML_METAL_EMBED_LIBRARY=ON",
            "-DWHISPER_COREML=ON",
            "-DWHISPER_COREML_ALLOW_FALLBACK=ON",
            "-DGGML_OPENMP=OFF",
            "-DWHISPER_BUILD_EXAMPLES=OFF",
            "-DWHISPER_BUILD_TESTS=OFF",
            "-DWHISPER_BUILD_SERVER=OFF",
        ]
    }
}