# Formal model (TLA+)

`MajorMinorPatch.tla` is a finite TLA+ model of the public semantics of `Semantic`
(`Major` / `Minor` / `Patch` / `Version` / `Identifier` / `Metadata`) as written in
`Sources/MajorMinorPatch`. TLC checks each law exhaustively over a small abstract domain.
The model follows **what the code does**. Since the 2026-11-13 fix the code follows semver.org
2.0.0, and every law, including the seven the old code broke, is in `MajorMinorPatch.cfg`.

Abstractions: `UInt` components are `0..MaxC` (`MaxC` stands for `UInt.max`); in the text model
each number, identifier and build identifier is one atomic token; identifier order is written twice: as the code's numeric/alphanumeric cases (`IdLess`) and
independently from semver.org (`RefIdLess`), and the two must agree.
There is a single dummy state (`u = 0`); every law is a closed quantified formula over the
finite domains (`Init` has one state, `Next == UNCHANGED u`).

| Invariant | Swift API it abstracts |
|---|---|
| `IncNeverDecreases`, `IncSaturatesAtMax`, `DecSaturatesAtZero`, `IncIsSuccessor`, `DecIsPredecessor`, `IncDecInverse` | `Major/Minor/Patch.incremented` / `.decremented` (saturating, never trap) |
| `VersionIrreflexive`, `VersionLessCoversLex`, `VersionLessSoundOnChains`, `VersionLessIsLex`, `VersionLessAsymmetric` | `Semantic.Version.<`: major, then minor, then patch |
| `IdOrderMatchesSemver` | `Semantic.Identifier.<`: numeric by value, numeric < alphanumeric, alphanumeric in ASCII order (`a10 < a2`) |
| `VOnlyIsStrictTotal`, `VIOnlyIsStrictTotal` | `Semantic.<` / `==` on `.v` and on `.vi`: strict total order, `==` an equivalence |
| `VIOrderMatchesSemver` | `.vi` / `.v` precedence equals semver.org item 11 (written independently as `RefLess`) |
| `SameVersionPrereleaseBelowRelease` | `1.0.0-alpha < 1.0.0` |
| `BuildMetadataIgnored`, `VIBOrdersLikeVI` | `.vib` pairs ignore build metadata in `==` and `<` |
| `EqReflexiveAllKinds`, `EqSymmetricExceptVvb`, `EqSymmetric` | `Semantic.==` means same precedence (build ignored), symmetric |
| `PlainLessAsymmetric`, `LessMatchesSemverAllKinds`, `AllKindsStrictWeakOrder` | `Semantic.<` over every pair of `.v/.vi/.vb/.vib` equals semver.org item 11 and is a strict weak order (`MajorMinorPatch.total.cfg`) |
| `ParsePrintRoundTrip` | `Semantic(description)` after `description`, over every parseable `.v/.vi/.vb/.vib` |
| `PrintParseOnCanonical`, `PrintParseLossless` | `description` after parsing any accepted string returns it unchanged |
| `LeadingZeroIdRejected`, `LeadingZeroComponentRejected`, `MalformedRejected` | `Semantic.parser` rejects `1.0.0-01`, `01.0.0`, trailing dots, `a+b` builds, junk |
| `ParseYieldsNonEmptyIds`, `ParseYieldsNonEmptyBuild` | `1.0.0-` and `1.0.0+` are rejected |

## Non-vacuity

Seeded bugs (`MajorMinorPatch.<mutant>.cfg`, first line `\* EXPECT_VIOLATION: <Invariant>`):
`inc_wraps` -> `IncNeverDecreases`; `prerelease_above_release` -> `SameVersionPrereleaseBelowRelease`;
`ids_lexical` -> `IdOrderMatchesSemver`; `shorter_not_lower` -> `VIOrderMatchesSemver`;
`build_in_equality` -> `BuildMetadataIgnored`; `accept_leading_zero_id` -> `LeadingZeroIdRejected`;
`print_swaps_minor_patch` -> `ParsePrintRoundTrip`. `run_tlc.sh` fails if a mutant passes.

## Fixed findings (2026-11-13)

The first version of this model found seven semver.org violations in the code. All seven are
fixed in `Sources/` and covered by `Tests/MajorMinorPatchTests/SemverRegressionTests.swift`
(each test fails on the old code). Each old bug survives as a `legacy_*` mutant that re-introduces
it and must be caught, so the law that found it can still go red:

| Old behaviour | Fix | Mutant -> invariant |
|---|---|---|
| `Version.<` was `major< \|\| minor< \|\| patch<`, so `2.0.0 < 1.5.0` | lexicographic | `legacy_version_any_component` -> `VersionLessAsymmetric` |
| `.vi < .v` always true, so `2.0.0-alpha < 1.0.0` | versions first, then pre-release | `legacy_prerelease_below_all` -> `PlainLessAsymmetric` |
| `<` false for every `.vb` and mixed build pair | one rule for all cases, build ignored | `legacy_build_kinds_unordered` -> `LessMatchesSemverAllKinds` |
| `.vb == .v` true but `.v == .vb` false | `==` compares version and pre-release | `legacy_eq_asymmetric` -> `EqSymmetric` |
| identifiers used Foundation `.numeric`, so `a2 < a10` | semver item 11.4 (ASCII, `a10 < a2`) | `legacy_numeric_id_compare` -> `IdOrderMatchesSemver` |
| `01.0.0` parsed and printed `1.0.0` | leading zeros rejected | `legacy_leading_zero_component` -> `PrintParseLossless` |
| `1.0.0-` parsed with empty ids, then `==` trapped | pre-release and build need >= 1 item | `legacy_empty_ids` -> `ParseYieldsNonEmptyIds` |

A hand-built `.vi(ver:ids: [])` (not produced by the parser) is treated as a release in `==`/`<`
and no longer traps, but its `description` (`"1.0.0-"`) does not parse back.

Not modelled because it does not exist: there is **no `Version`-level bump API** (no
`bumpMajor` that resets minor/patch). Only per-component `incremented`/`decremented` exist, so
"bump resets lower components" cannot be checked. `+` / `-` on components trap on overflow /
underflow (Swift runtime), outside the model; `incremented`/`decremented` guard against this.

## Running

```sh
TLA_JAR=/path/to/tla2tools-1.7.4.jar formal/run_tlc.sh   # needs Java 11+
```

The script checks the jar's SHA-256 against the pinned tla2tools 1.7.4. CI runs it on a
self-hosted Oracle ARM64 runner, only on pushes to the default branch or by manual dispatch
(`.github/workflows/oracle-tla.yml`). The Swift build and tests stay on hosted macOS.

## Limits

The model describes the code as read by hand; it does not prove the Swift conforms (the XCTest
suite covers the code). Identifier ordering no longer depends on Foundation, so it is the same
on macOS and Linux.
Strings are abstracted to tokens (ids containing `-`, Unicode, overflow of `UInt` are out of
scope). If the Swift behaviour changes, update the model in the same PR.
