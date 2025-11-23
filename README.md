# whisper-build

build scripts for [whisper](https://github.com/ggml-org/whisper.cpp)

> This is a component of the [MPVKit](https://github.com/mpvkit/MPVKit) project.

## Installation

### Swift Package Manager

```
https://github.com/mpvkit/whisper-build.git
```

## How to build

```bash
make build
# specified platforms (ios,macos,tvos,tvsimulator,isimulator,maccatalyst,xros,xrsimulator)
make build platform=ios,macos
# clean all build temp files and cache
make clean
# see help
make help
```
