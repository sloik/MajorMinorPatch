import XCTest
@testable import MajorMinorPatch

final class MajorTests: XCTestCase {
    
    func test_equatable() {
        XCTAssertEqual   ( Semantic.Major.one , 1 )
        XCTAssertNotEqual( Semantic.Major.one , 0 )

        XCTAssert( Semantic.Major.zero < .one )
        XCTAssert( Semantic.Major.max  > .one )
    }
    
    func test_isZero() {
        XCTAssertTrue ( Semantic.Major.zero.isZero )
        XCTAssertFalse( Semantic.Major.one.isZero )
    }

    func test_isMin() {
        XCTAssertTrue ( Semantic.Major.min.isMin )
        XCTAssertFalse( Semantic.Major.one.isMin )
    }

    func test_isMax() {
        XCTAssertTrue ( Semantic.Major.max.isMax )
        XCTAssertFalse( Semantic.Major.one.isMax )
    }
    
    func test_increment() {

        XCTAssertEqual(
            Semantic.Major.max.incremented,
            Semantic.Major.max,
            "Incrementing max value should return the same value!"
        )

        XCTAssertEqual(
            Semantic.Major.zero.incremented,
            Semantic.Major.one,
            "Incrementing zero should return one!"
        )
    }
    
    func test_decremented() {

        XCTAssertEqual(
            Semantic.Major.min.decremented,
            Semantic.Major.min,
            "Decrementing min value should return the same value!"
        )

        XCTAssertEqual(
            Semantic.Major.one.decremented,
            Semantic.Major.zero,
            "Decrementing one should return zero!"
        )
    }
    
    func test_additive() {

        XCTAssertEqual(
            major1 + major2,
            major3,
            "1 + 2 != 3"
        )

        XCTAssertEqual(
            major3 - major2,
            major1,
            "3 - 2 != 1"
        )
    }

}
