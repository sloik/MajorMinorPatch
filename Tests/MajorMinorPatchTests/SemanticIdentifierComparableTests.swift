import XCTest
import MajorMinorPatch

final class SemanticIdentifierComparableTests: XCTestCase {

    // use this test to focus on one case and if green then move it to snapshot.
    func test_wip() {

    }

    /// Examples of true cases for collections
    func test_snapshot_collections() {
        XCTAssertLessThan(
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
            ],
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "b")!,
            ]
        )
        
        XCTAssertLessThan(
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "A")!,
            ],
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
            ]
        )

        XCTAssertLessThan(
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
            ],
            [
                Semantic.Identifier(string: "b")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
            ]
        )

        XCTAssertLessThan(
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
            ],
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "a")!,
            ]
        )

        XCTAssertFalse(
            Array<Semantic.Identifier>() < Array<Semantic.Identifier>()
        )

        XCTAssertGreaterThan(
            [
                Semantic.Identifier(string: "a")!,
            ],
            []
        )

        XCTAssertLessThan(
            [
                Semantic.Identifier(string: "a")!,
            ],
            [
                Semantic.Identifier(string: "a")!,
                Semantic.Identifier(string: "1")!,
            ]
        )

        XCTAssertLessThan(
            [
                Semantic.Identifier(string: "1")!,
            ],
            [
                Semantic.Identifier(string: "a")!,
            ]
        )

        XCTAssertLessThan(
            [
                Semantic.Identifier(string: "a")!,
            ],
            [
                Semantic.Identifier(string: "a")!,
                .init(string: "a")!
            ]
        )

        XCTAssertLessThan(
            [Semantic.Identifier(string: "a")!],
            [Semantic.Identifier(string: "b")!]
        )

        XCTAssertLessThan(
            [],
            [Semantic.Identifier(string: "a")!]
        )
    }

    /// Examples of true cases.
    func test_snapshot() {
        XCTAssertTrue(
            Semantic.Identifier(string: "a-a-a")! < Semantic.Identifier(string: "b")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "a-a-a")! < Semantic.Identifier(string: "a-b")!
        )
        XCTAssertTrue(
            Semantic.Identifier(string: "a-a")! < Semantic.Identifier(string: "a-b")!
        )
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
