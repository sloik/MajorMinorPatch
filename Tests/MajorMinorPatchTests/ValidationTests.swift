
import Foundation
import XCTest

@testable import MajorMinorPatch

final class ValidationTests: XCTestCase {

    func test_isValidIdentifier() {

        // Valid
        XCTAssertTrue( isValidIdentifier("-") )

        XCTAssertTrue( isValidIdentifier("10alpha") )
        XCTAssertTrue( isValidIdentifier("200alpha") )
        XCTAssertTrue( isValidIdentifier("3000alpha") )
        XCTAssertTrue( isValidIdentifier("43724730237454032759234750932") )

        
        // Numeric identifiers MUST NOT include leading zeroes,
        // so alphanumeric may contain them.
        XCTAssertTrue( isValidIdentifier("0") )
        XCTAssertTrue( isValidIdentifier("0alpha") )
        XCTAssertTrue( isValidIdentifier("00alpha") )
        XCTAssertTrue( isValidIdentifier("000alpha") )
        XCTAssertTrue( isValidIdentifier("a0") )
        XCTAssertTrue( isValidIdentifier("00a") )
        XCTAssertTrue( isValidIdentifier("0b00") )
        XCTAssertTrue( isValidIdentifier("0c1") )
        XCTAssertTrue( isValidIdentifier("00d1") )
        XCTAssertTrue( isValidIdentifier("g0g0g0g1g") )


        // Invalid
        XCTAssertFalse( isValidIdentifier("") )
        XCTAssertFalse( isValidIdentifier("00") )
        XCTAssertFalse( isValidIdentifier("000") )
        XCTAssertFalse( isValidIdentifier("01") )
        XCTAssertFalse( isValidIdentifier("001") )
        XCTAssertFalse( isValidIdentifier("0001") )
        XCTAssertFalse( isValidIdentifier("043724730237454032759234750932") )
    }

    func test_isValidBuildIdentifier() {

        // Valid
        XCTAssertTrue( isValidBuildIdentifier("-") )

        XCTAssertTrue( isValidBuildIdentifier("001") )
        XCTAssertTrue( isValidBuildIdentifier("20130313144700") )

        XCTAssertTrue( isValidBuildIdentifier("exp") )
        XCTAssertTrue( isValidBuildIdentifier("sha") )
        XCTAssertTrue( isValidBuildIdentifier("5114f85") )
        XCTAssertTrue( isValidBuildIdentifier("21AF26D3-117B344092BD") )
        XCTAssertTrue( isValidBuildIdentifier("10alpha") )
        XCTAssertTrue( isValidBuildIdentifier("200alpha") )
        XCTAssertTrue( isValidBuildIdentifier("3000alpha") )
        XCTAssertTrue( isValidBuildIdentifier("43724730237454032759234750932") )
        XCTAssertTrue( isValidBuildIdentifier("0alpha") )
        XCTAssertTrue( isValidBuildIdentifier("00alpha") )
        XCTAssertTrue( isValidBuildIdentifier("000alpha") )
        XCTAssertTrue( isValidBuildIdentifier("a0") )
        XCTAssertTrue( isValidBuildIdentifier("00a") )
        XCTAssertTrue( isValidBuildIdentifier("0b00") )
        XCTAssertTrue( isValidBuildIdentifier("0c1") )
        XCTAssertTrue( isValidBuildIdentifier("00d1") )
        XCTAssertTrue( isValidBuildIdentifier("g0g0g0g1g") )
        XCTAssertTrue( isValidBuildIdentifier("0") )
        XCTAssertTrue( isValidBuildIdentifier("00") )
        XCTAssertTrue( isValidBuildIdentifier("000") )
        XCTAssertTrue( isValidBuildIdentifier("01") )
        XCTAssertTrue( isValidBuildIdentifier("001") )
        XCTAssertTrue( isValidBuildIdentifier("0001") )
        XCTAssertTrue( isValidBuildIdentifier("043724730237454032759234750932") )


        // Invalid
        XCTAssertFalse( isValidBuildIdentifier("") )
        XCTAssertFalse( isValidBuildIdentifier("É") )
        XCTAssertFalse( isValidBuildIdentifier("💩") )
        XCTAssertFalse( isValidBuildIdentifier("exp.sha") )
    }
}
