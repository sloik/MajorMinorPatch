import XCTest
import MajorMinorPatch

final class SemanticIdentifierComparableTests: XCTestCase {

    // use this test to focus on one case and if green then move it to snapshot.
    func test_wip() {
        XCTAssertTrue(
            Semantic.Identifier(string: "Alpha")! < Semantic.Identifier(string: "alpha")!
        )
    }

    /// Examples of true cases.
    func test_snapshot() {
        XCTAssertTrue(
            Semantic.Identifier(string: "ALpha")! < Semantic.Identifier(string: "alpha")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "ALPha")! < Semantic.Identifier(string: "alpha")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "ALPHa")! < Semantic.Identifier(string: "alpha")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "ALPHA")! < Semantic.Identifier(string: "alpha")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "A")! < Semantic.Identifier(string: "a")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "1")! < Semantic.Identifier(string: "200")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "199")! < Semantic.Identifier(string: "200")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "1")! < Semantic.Identifier(string: "beta")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "1")! < Semantic.Identifier(string: "alpha")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "alpha")! < Semantic.Identifier(string: "beta")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "1")! < Semantic.Identifier(string: "2")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "1")! < Semantic.Identifier(string: "10")!
        )
    }
}
