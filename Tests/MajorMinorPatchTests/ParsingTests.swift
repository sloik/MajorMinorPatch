
import Foundation
import XCTest

@testable import MajorMinorPatch

final class ParsingTests: XCTestCase {


    func test_parseString() {

        // Arrange

        let testCaseData: [ParsingTestCaseData] = [

            // just version
            newCase()
                .setInput( "1.0.0" )
                .setExpected( .v(ver: .init(major: 1, minor: 0, patch: 0)) ),
            newCase()
                .setInput( "1.0.1" )
                .setExpected( .v(ver: .init(major: 1, minor: 0, patch: 1)) ),
            newCase()
                .setInput( "1.1.0" )
                .setExpected( .v(ver: .init(major: 1, minor: 1, patch: 0)) ),
            newCase()
                .setInput( "1.1.1" )
                .setExpected( .v(ver: .init(major: 1, minor: 1, patch: 1)) ),

            // version and identifiers
            newCase()
                .setInput( "1.0.0-alpha" )
                .setExpected( .vi(ver: ver_1_0_0.version, ids: [.alpha]) ),
            newCase()
                .setInput( "1.0.0-beta" )
                .setExpected( .vi(ver: ver_1_0_0.version, ids: [.beta]) ),
            newCase()
                .setInput( "1.0.0-alpha.beta" )
                .setExpected( .vi(ver: ver_1_0_0.version, ids: [.alpha, .beta]) ),
            newCase()
                .setInput( "1.0.0-alpha.1" )
                .setExpected(
                    .vi(
                        ver: ver_1_0_0.version,
                        ids: [.alpha, .init(string: "1")!]
                    )
                ),
            newCase()
                .setInput( "1.0.0-0.3.7" )
                .setExpected(
                    .vi(
                        ver: ver_1_0_0.version,
                        ids: [.init(string: "0")!, .init(string: "3")!, .init(string: "7")!]
                    )
                ),
            newCase()
                .setInput( "1.0.0-0" )
                .setExpected(
                    .vi(
                        ver: ver_1_0_0.version,
                        ids: [.init(string: "0")!]
                    )
                ),

            // version and metadata
            newCase()
                .setInput( "1.0.0+001" )
                .setExpected(
                    .vb(
                        ver: ver_1_0_0.version,
                        build: [ .init(string: "001")! ]
                    )
                ),
            newCase()
                .setInput( "1.0.0+20130313144700" )
                .setExpected(
                    .vb(
                        ver: ver_1_0_0.version,
                        build: [ .init(string: "20130313144700")! ]
                    )
                ),
            newCase()
                .setInput( "1.0.0+exp.sha.5114f85" )
                .setExpected(
                    .vb(
                        ver: ver_1_0_0.version,
                        build: [ .init(string: "exp")!, .init(string: "sha")!, .init(string: "5114f85")! ]
                    )
                ),

            // version and ids and metadata
            newCase()
                .setInput( "1.0.0-alpha+001" )
                .setExpected( .vib(ver: ver_1_0_0.version, ids: [.alpha], build: [ .init(string: "001")! ] ) ),
            newCase()
                .setInput( "1.0.0-beta+20130313144700" )
                .setExpected( .vib(ver: ver_1_0_0.version, ids: [.beta], build: [ .init(string: "20130313144700")! ]) ),
            newCase()
                .setInput( "1.0.0-alpha.beta+exp.sha.5114f85" )
                .setExpected(
                    .vib(
                        ver: ver_1_0_0.version,
                        ids: [.alpha, .beta],
                        build: [ .init(string: "exp")!, .init(string: "sha")!, .init(string: "5114f85")! ]
                    )
                ),
            newCase()
                .setInput( "1.0.0-alpha.1+001" )
                .setExpected(
                    .vib(
                        ver: ver_1_0_0.version,
                        ids: [.alpha, .init(string: "1")!],
                        build: [ .init(string: "001")! ]
                    )
                ),
            newCase()
                .setInput( "1.0.0-0.3.7+20130313144700" )
                .setExpected(
                    .vib(
                        ver: ver_1_0_0.version,
                        ids: [.init(string: "0")!, .init(string: "3")!, .init(string: "7")!],
                        build:  [ .init(string: "20130313144700")! ]
                    )
                ),
            newCase()
                .setInput( "1.0.0-0+exp.sha.5114f85" )
                .setExpected(
                    .vib(
                        ver: ver_1_0_0.version,
                        ids: [.init(string: "0")!],
                        build: [ .init(string: "exp")!, .init(string: "sha")!, .init(string: "5114f85")! ]
                    )
                ),
            newCase()
                .setInput( "1.0.0-alpha.0+exp.sha.5114f85" )
                .setExpected(
                    .vib(
                        ver: ver_1_0_0.version,
                        ids: [.alpha, .init(string: "0")!],
                        build: [ .init(string: "exp")!, .init(string: "sha")!, .init(string: "5114f85")! ]
                    )
                ),
        ]

        // Act & Assert

        testCaseData.forEach { test in

            let result = parse(string: test.input)

            XCTAssertNotNil(
                result,
                "Did not parse string: \"\(test.input)\"",
                file: test.file,
                line: test.line
            )

            if let result {
                XCTAssertEqual(
                    result,
                    test.expected,
                    file: test.file,
                    line: test.line
                )
            }

            // When comparing for equality specification says
            // that build metadata should be ignored. But in this
            // case we need to check if parsing works.
            if let expectedMetadata = test.expected.metadata {

                XCTAssertNotNil(
                    result?.metadata,
                    "Did not parse expected metadata for: \"\(test.input)\"",
                    file: test.file,
                    line: test.line
                )

                if let resultMetadata = result?.metadata {
                    XCTAssertEqual(
                        resultMetadata,
                        expectedMetadata,
                        file: test.file,
                        line: test.line
                    )
                }

            }

        }
    }

    func test_parseString_forInvalidStrings_shouldReturnNone() {

        // Arrange

        let invalidStrings: [String] = [
            "Andrzej",
            "1.0.0-01",
            "1.0.0-01.alpha",
        ]

        // Act & Assert
        
        invalidStrings
            .forEach { (invalidString: String) in

                XCTAssertNil(
                    parse(string: invalidString),
                    "Should not parse invalid version string: \"\(invalidString)\""
                )
            }

    }
}

fileprivate func newCase(file: StaticString = #file, line: UInt = #line) -> ParsingTestCaseData {
    .init(file: file, line: line, input: "", expected: ver_0_0_0)
}

fileprivate typealias PTC = ParsingTestCaseData

fileprivate struct ParsingTestCaseData {

    let file: StaticString
    let line: UInt

    let input: String
    let expected: Semantic

    func setInput(_ string: String) -> Self {
        .init(
            file: file,
            line: line,
            input: string,
            expected: expected
        )
    }

    func setExpected(_ version: Semantic) -> Self {
        .init(
            file: file,
            line: line,
            input: input,
            expected: version
        )
    }
}
