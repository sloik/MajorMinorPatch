import XCTest
@testable import MajorMinorPatch

final class PatchTests: XCTestCase {
    
    func test_equatable() {
        XCTAssertEqual   ( Semantic.Patch.one , 1 )
        XCTAssertNotEqual( Semantic.Patch.one , 0 )
        
        XCTAssert( Semantic.Patch.zero < .one )
        XCTAssert( Semantic.Patch.max  > .one )
    }
    
    func test_isZero() {
        XCTAssertTrue ( Semantic.Patch.zero.isZero )
        XCTAssertFalse( Semantic.Patch.one.isZero )
    }

    func test_isMin() {
        XCTAssertTrue ( Semantic.Patch.min.isMin )
        XCTAssertFalse( Semantic.Patch.one.isMin )
    }

    func test_isMax() {
        XCTAssertTrue ( Semantic.Patch.max.isMax )
        XCTAssertFalse( Semantic.Patch.one.isMax )
    }
    
    func test_increment() {

        XCTAssertEqual(
            Semantic.Patch.max.incremented,
            Semantic.Patch.max,
            "Incrementing max value should return the same value!"
        )

        XCTAssertEqual(
            Semantic.Patch.zero.incremented,
            Semantic.Patch.one,
            "Incrementing zero should return one!"
        )
    }
    
    func test_decremented() {

        XCTAssertEqual(
            Semantic.Patch.min.decremented,
            Semantic.Patch.min,
            "Decrementing min value should return the same value!"
        )

        XCTAssertEqual(
            Semantic.Patch.one.decremented,
            Semantic.Patch.zero,
            "Decrementing one should return zero!"
        )
    }
    
    func test_additive() {

        XCTAssertEqual(
            patch1 + patch2,
            patch3,
            "1 + 2 != 3"
        )

        XCTAssertEqual(
            patch3 - patch2,
            patch1,
            "3 - 2 != 1"
        )
    }

}
