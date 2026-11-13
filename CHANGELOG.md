# Changelog

This project follows [Semantic Versioning 2.0.0](https://semver.org).

## 1.0.0 (2026-11-13): breaking

**Why a major version:** comparisons and parsing now follow semver.org 2.0.0 exactly. In 0.0.5
several of them were wrong. Fixing them changes the results of public API (`<`, `==`, `sorted()`,
`max()`, `Semantic(_:)`), so code that sorts, compares or parses versions can see different
answers after upgrading. That is a breaking change, so the major version goes up. 1.0.0 is
also the first release with a stable public API.

The bugs were found by a TLA+ model of the library (`formal/`), and each one has a regression
test in `Tests/MajorMinorPatchTests/SemverRegressionTests.swift`.

### Breaking: ordering (`<`, `>`, `sorted()`, `min()`, `max()`)

| Expression | 0.0.5 | 1.0.0 | Why (semver.org) |
|---|---|---|---|
| `2.0.0 < 1.5.0` | `true` (and `1.5.0 < 2.0.0` too) | `false` | 11.2: compare major, then minor, then patch |
| `2.0.0-alpha < 1.0.0` | `true` | `false` | 11.3: a pre-release only ranks below its *own* release |
| `1.0.0 < 2.0.0-alpha` | `true` | `true` | (unchanged) |
| `1.0.0+a < 2.0.0+a` | `false` both ways | `true` | 10: build metadata is ignored for precedence |
| `1.0.0-alpha+x < 1.0.0-beta` | `false` | `true` | 10 + 11.4 |
| `Identifier("a10") < Identifier("a2")` | `false` (`a2 < a10`) | `true` | 11.4.2: alphanumeric identifiers compare in ASCII order |

Before, `<` was not a valid order (for example, both `2.0.0 < 1.5.0` and `1.5.0 < 2.0.0` were
true), so `sorted()` could return any order. It is now a strict weak order across all four
cases (`.v`, `.vi`, `.vb`, `.vib`).

### Breaking: equality (`==`)

`==` now means *same precedence*: the version and pre-release are equal, and build metadata is
ignored. It is symmetric across cases.

| Expression | 0.0.5 | 1.0.0 |
|---|---|---|
| `1.0.0+build == 1.0.0` | `true` | `true` |
| `1.0.0 == 1.0.0+build` | `false` | `true` |
| `1.0.0-alpha == 1.0.0-alpha+build` | `true` | `true` |

To tell builds apart, compare `metadata` explicitly.

### Breaking: parsing (`Semantic(_:)`, `Major(_:)`, `Minor(_:)`, `Patch(_:)`)

These strings parsed in 0.0.5 and now return `nil`:

| Input | 0.0.5 | 1.0.0 | Why |
|---|---|---|---|
| `01.0.0`, `1.00.0`, `1.0.01` | parsed, printed without the zero (`1.0.0`) | `nil` | 2: no leading zeroes |
| `1.0.0-` | parsed with empty identifiers; `==`/`<` then **crashed** | `nil` | 9: a pre-release needs one or more identifiers |
| `1.0.0+` | parsed with empty build metadata | `nil` | 10: build metadata needs one or more identifiers |

### Unchanged

Valid semver strings parse and print as before. `Major`/`Minor`/`Patch` arithmetic,
`incremented`, `decremented` and the `Identifier`/`Metadata` validation rules are unchanged.

### Migrating

- If you sort or compare versions, you need no code change; results are now correct. Re-check
  any stored ordering or snapshot built with 0.0.5.
- If you accepted user input with leading zeroes or a trailing `-`/`+`, handle the new `nil`
  (for example by normalising the input first).
- If you used `==` to mean "identical including build metadata", also compare `metadata`.

## 0.0.5 (2023-01-19)

Last 0.x release.
