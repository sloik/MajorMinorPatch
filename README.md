[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsloik%2FMajor.Minor.Patch%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sloik/Major.Minor.Patch)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsloik%2FMajor.Minor.Patch%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sloik/Major.Minor.Patch)
![Main](https://github.com/sloik/MajorMinorPatch/actions/workflows/swift.yml/badge.svg?branch=main)
![Nightly](https://github.com/sloik/MajorMinorPatch/actions/workflows/nightly.yml/badge.svg)

# 🪖Major 👶Minor 🛠Patch

Implementation of https://semver.org in Swift.

## Implemented specification version

**2.0.0**

## Installing

```swift
.package(url: "https://github.com/sloik/MajorMinorPatch.git", from: "1.0.0")
```

> **1.0.0 is a breaking release.** Ordering, equality and parsing now follow semver.org exactly,
> so results differ from 0.0.5 (e.g. `2.0.0 < 1.5.0` is no longer `true`, and `01.0.0` no longer
> parses). See [CHANGELOG.md](CHANGELOG.md) for every changed result and how to migrate.

---

# 🐇🕳 Rabbit Hole

This project is part of the [🐇🕳 Rabbit Hole Packages Collection](https://github.com/sloik/RabbitHole)
