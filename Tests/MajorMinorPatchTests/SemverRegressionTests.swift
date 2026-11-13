import XCTest
import MajorMinorPatch

/// Regressions for the semver.org violations found by the TLA+ model (formal/README.md).
final class SemverRegressionTests: XCTestCase {

    private func s(_ text: String, file: StaticString = #filePath, line: UInt = #line) -> Semantic {
        guard let value = Semantic(text) else {
            XCTFail("\(text) should parse", file: file, line: line)
            return .ver_0_0_0
        }
        return value
    }

    /// 1. Version precedence is lexicographic: major, then minor, then patch.
    func test_versionOrderIsLexicographic() {
        XCTAssertTrue(s("1.5.0") < s("2.0.0"))
        XCTAssertFalse(s("2.0.0") < s("1.5.0"))
        XCTAssertTrue(s("1.0.9") < s("1.1.0"))
        XCTAssertFalse(s("1.1.0") < s("1.0.9"))
        XCTAssertTrue(s("0.9.9") < s("1.0.0"))
    }

    /// 2. A pre-release is only below its own release, not below every release.
    func test_preReleaseComparesByVersionFirst() {
        XCTAssertTrue(s("1.0.0") < s("2.0.0-alpha"))
        XCTAssertFalse(s("2.0.0-alpha") < s("1.0.0"))
        XCTAssertTrue(s("1.0.0-alpha") < s("1.0.0"))
        XCTAssertFalse(s("1.0.0") < s("1.0.0-alpha"))
    }

    /// 3. Build metadata is ignored for precedence, in every case combination.
    func test_buildMetadataIgnoredInOrdering() {
        XCTAssertTrue(s("1.0.0+a") < s("2.0.0+a"))
        XCTAssertTrue(s("1.0.0-alpha+x") < s("1.0.0-beta"))
        XCTAssertTrue(s("1.0.0-alpha") < s("1.0.0+build"))
        XCTAssertTrue(s("1.0.0+build") < s("1.1.0-alpha"))
        XCTAssertFalse(s("1.0.0+a") < s("1.0.0+b"))
        XCTAssertFalse(s("1.0.0+b") < s("1.0.0+a"))
    }

    /// 4. Equality ("same precedence") is symmetric.
    func test_equalityIsSymmetric() {
        XCTAssertEqual(s("1.0.0"), s("1.0.0+build"))
        XCTAssertEqual(s("1.0.0+build"), s("1.0.0"))
        XCTAssertEqual(s("1.0.0-alpha"), s("1.0.0-alpha+build"))
        XCTAssertEqual(s("1.0.0-alpha+build"), s("1.0.0-alpha"))
        XCTAssertNotEqual(s("1.0.0"), s("1.0.0-alpha+build"))
        XCTAssertNotEqual(s("1.0.0-alpha+build"), s("1.0.0"))
    }

    /// 5. Alphanumeric identifiers compare in ASCII order; numeric ones numerically.
    func test_identifierOrderFollowsSemver() {
        let a2 = Semantic.Identifier(string: "a2")!
        let a10 = Semantic.Identifier(string: "a10")!
        XCTAssertTrue(a10 < a2)
        XCTAssertFalse(a2 < a10)
        XCTAssertTrue(Semantic.Identifier(string: "2")! < Semantic.Identifier(string: "10")!)
        XCTAssertTrue(Semantic.Identifier(string: "999")! < Semantic.Identifier(string: "a")!)
        XCTAssertTrue(s("1.0.0-beta.2") < s("1.0.0-beta.11"))
        // semver.org 11.4 example chain
        let chain = ["1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-alpha.beta", "1.0.0-beta",
                     "1.0.0-beta.2", "1.0.0-beta.11", "1.0.0-rc.1", "1.0.0"].map { s($0) }
        for (lower, higher) in zip(chain, chain.dropFirst()) {
            XCTAssertTrue(lower < higher, "\(lower) < \(higher)")
            XCTAssertFalse(higher < lower, "\(higher) < \(lower)")
        }
    }

    /// 6. Leading zeros in major, minor or patch are rejected.
    func test_leadingZeroComponentsRejected() {
        XCTAssertNil(Semantic("01.0.0"))
        XCTAssertNil(Semantic("1.00.0"))
        XCTAssertNil(Semantic("1.0.01"))
        XCTAssertNil(Semantic.Major("01"))
        XCTAssertNotNil(Semantic("0.0.0"))
        XCTAssertNotNil(Semantic("10.20.30"))
    }

    /// 7. An empty pre-release or empty build metadata does not parse (and so cannot trap later).
    func test_emptyPreReleaseAndBuildRejected() {
        XCTAssertNil(Semantic("1.0.0-"))
        XCTAssertNil(Semantic("1.0.0+"))
        XCTAssertNil(Semantic("1.0.0-+build"))
        XCTAssertNil(Semantic("1.0.0-alpha+"))
    }

    /// Round trip still holds for canonical strings.
    func test_roundTrip() {
        for text in ["0.0.0", "1.2.3", "1.0.0-alpha.1", "1.0.0+20130313144700", "1.0.0-beta+exp.sha.5114f85"] {
            XCTAssertEqual(Semantic(text)?.description, text)
        }
    }
}
