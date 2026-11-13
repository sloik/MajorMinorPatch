# Formal model (TLA+)

`MajorMinorPatch.tla` is a finite TLA+ model of the public semantics of `Semantic`
(`Major` / `Minor` / `Patch` / `Version` / `Identifier` / `Metadata`) as written in
`Sources/MajorMinorPatch`. TLC checks each law exhaustively over a small abstract domain.
The model follows **what the code does**; where the code breaks a semver law, the law is
*not* in `MajorMinorPatch.cfg` but pinned by a `finding_*` cfg (see Findings).

Abstractions: `UInt` components are `0..MaxC` (`MaxC` stands for `UInt.max`); in the text model
each number, identifier and build identifier is one atomic token; the Foundation
`compare(_, options: .numeric)` used for identifiers is modelled by an explicit rank
(`CodeRank`, derived from probing the real code), semver.org's rule by `RefIdLess`.
There is a single dummy state (`u = 0`); every law is a closed quantified formula over the
finite domains (`Init` has one state, `Next == UNCHANGED u`).

| Invariant | Swift API it abstracts |
|---|---|
| `IncNeverDecreases`, `IncSaturatesAtMax`, `DecSaturatesAtZero`, `IncIsSuccessor`, `DecIsPredecessor`, `IncDecInverse` | `Major/Minor/Patch.incremented` / `.decremented` (saturating, never trap) |
| `VersionIrreflexive`, `VersionLessCoversLex`, `VersionLessSoundOnChains` | `Semantic.Version.<` (correct only when components are comparable, see Findings) |
| `IdOrderMatchesSemver` | `Semantic.Identifier.<` (numeric < alphanumeric, numeric by value) |
| `VOnlyIsStrictTotal`, `VIOnlyIsStrictTotal` | `Semantic.<` / `==` on `.v` and on `.vi`: strict total order, `==` an equivalence |
| `VIOrderMatchesSemver` | `.vi` / `.v` precedence equals semver.org item 11 (written independently as `RefLess`) |
| `SameVersionPrereleaseBelowRelease` | `1.0.0-alpha < 1.0.0` |
| `BuildMetadataIgnored`, `VIBOrdersLikeVI` | `.vib` pairs ignore build metadata in `==` and `<` |
| `EqReflexiveAllKinds`, `EqSymmetricExceptVvb` | `Semantic.==` |
| `ParsePrintRoundTrip` | `Semantic(description)` after `description`, over every `.v/.vi/.vb/.vib` (incl. empty arrays) |
| `PrintParseOnCanonical` | `description` after parsing a canonical string returns it |
| `LeadingZeroIdRejected`, `MalformedRejected` | `Semantic.parser` rejects `1.0.0-01`, trailing dots, `a+b` builds, junk |

## Non-vacuity

Seeded bugs (`MajorMinorPatch.<mutant>.cfg`, first line `\* EXPECT_VIOLATION: <Invariant>`):
`inc_wraps` -> `IncNeverDecreases`; `prerelease_above_release` -> `SameVersionPrereleaseBelowRelease`;
`ids_lexical` -> `IdOrderMatchesSemver`; `shorter_not_lower` -> `VIOrderMatchesSemver`;
`build_in_equality` -> `BuildMetadataIgnored`; `accept_leading_zero_id` -> `LeadingZeroIdRejected`;
`print_swaps_minor_patch` -> `ParsePrintRoundTrip`. `run_tlc.sh` fails if a mutant passes.

## Findings (laws the Swift code does NOT satisfy)

Each is confirmed against the real code (throwaway XCTest probe, not committed) and pinned by a
`MajorMinorPatch.finding_*.cfg` that runs the *unmutated* model and expects the violation. If the
Swift is fixed, the matching cfg goes red: move the invariant into `MajorMinorPatch.cfg`.

1. `finding_version_not_antisymmetric` - `Version.<` is `major< || minor< || patch<` (not
   lexicographic): `2.0.0 < 1.5.0` and `1.5.0 < 2.0.0` are both true. Violates `VersionLessAsymmetric`.
2. `finding_prerelease_cross_version` - `.vi < .v` is unconditionally `true`: `2.0.0-alpha < 1.0.0`
   and `1.0.0 < 2.0.0-alpha` are both true. Violates `PlainLessAsymmetric`.
3. `finding_build_and_mixed_kinds_unordered` - `<` only handles `v/v`, `v/vi`, `vi/v`, `vi/vi`,
   `vib/vib`; everything else is `false`: `1.0.0+a < 2.0.0+a` is false both ways, `1.0.0-alpha+x < 1.0.0-beta`
   is false. Violates `LessMatchesSemverAllKinds`.
4. `finding_eq_asymmetric_v_vb` - `.vb == .v` is version equality but `.v == .vb` is `false`.
   Violates `EqSymmetric`.
5. `finding_alnum_digit_runs` - identifier compare uses `.numeric`, so `a2 < a10`; semver (ASCII)
   says `a10 < a2`. Violates `IdOrderMatchesSemver` once such identifiers exist.
6. `finding_leading_zero_normalised` - `Semantic("01.0.0")` parses (leading zeros accepted in
   major/minor/patch, forbidden by semver 2) and prints `1.0.0`. Violates `PrintParseLossless`.
7. `finding_empty_id_array_parses` - `Semantic("1.0.0-")` parses to `.vi` with `ids == []`; then
   `==` / `<` trap on `identifiers!` (observed: Fatal error, signal 5). Violates `ParseYieldsNonEmptyIds`.

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

The model describes the code as read by hand and probed once; it does not prove the Swift
conforms. Identifier ordering depends on Foundation's `compare(_, options: .numeric)`, which is
abstracted to a rank table derived on macOS; swift-corelibs-foundation on Linux may differ.
Strings are abstracted to tokens (ids containing `-`, Unicode, overflow of `UInt` are out of
scope). If the Swift behaviour changes, update the model in the same PR.
