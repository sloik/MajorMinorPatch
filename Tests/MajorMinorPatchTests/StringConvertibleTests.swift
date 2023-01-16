import Foundation
import XCTest

@testable import MajorMinorPatch

final class PrintingTests: XCTestCase {

    func test_major_printing() throws {

        // Arrange
        let sut = Semantic.Major(42)

        // Act & Assert
        XCTAssertEqual( sut.description, "42" )

        XCTAssertEqual(
            Semantic.Major( sut.description ) ,
            sut
        )
    }

    func test_minor_printing() throws {

        // Arrange
        let sut = Semantic.Minor(42)

        // Act & Assert
        XCTAssertEqual( sut.description, "42" )

        XCTAssertEqual(
            Semantic.Minor( sut.description ) ,
            sut
        )
    }

    func test_patch_printing() throws {

        // Arrange
        let sut = Semantic.Patch(42)

        // Act & Assert
        XCTAssertEqual( sut.description, "42" )

        XCTAssertEqual(
            Semantic.Patch( sut.description ) ,
            sut
        )
    }

    func test_version_printing() throws {

        XCTAssertEqual( ver_2_1_1.version.description, "2.1.1" )
        XCTAssertEqual(
            Semantic.Version( ver_2_1_1.version.description ),
            ver_2_1_1.version
        )

        XCTAssertEqual( ver_2_1_0.version.description, "2.1.0" )
        XCTAssertEqual(
            Semantic.Version( ver_2_1_0.version.description ),
            ver_2_1_0.version
        )

        XCTAssertEqual( ver_2_0_0.version.description, "2.0.0" )
        XCTAssertEqual(
            Semantic.Version( ver_2_0_0.version.description ),
            ver_2_0_0.version
        )

        XCTAssertEqual( ver_0_0_0.version.description, "0.0.0" )
        XCTAssertEqual(
            Semantic.Version( ver_0_0_0.version.description ),
            ver_0_0_0.version
        )
    }

    func test_identifier_printing() {

        XCTAssertEqual(ver_2_1_1_alpha.identifiers?.first?.description, "alpha")
        XCTAssertEqual(
            Semantic.Identifier("alpha"),
            .alpha
        )

    }

    func test_metadata_printing() {

        XCTAssertEqual(ver_0_0_0_b1.metadata?.first?.description, "1")
        XCTAssertEqual(
            Semantic.Metadata("exp"),
            .init(string: "exp")
        )
    }

    func test_semantic_printing() {

        XCTAssertEqual(ver_2_0_0.description, "2.0.0")
        XCTAssertEqual(Semantic( ver_2_0_0.description ) , ver_2_0_0)

        XCTAssertEqual(ver_2_1_0.description, "2.1.0")
        XCTAssertEqual(Semantic( ver_2_1_0.description ) , ver_2_1_0)

        XCTAssertEqual(ver_2_1_1.description, "2.1.1")
        XCTAssertEqual(Semantic( ver_2_1_1.description ) , ver_2_1_1)

        XCTAssertEqual(ver_2_0_0_alpha.description, "2.0.0-alpha")
        XCTAssertEqual(Semantic( ver_2_0_0_alpha.description ) , ver_2_0_0_alpha)

        XCTAssertEqual(ver_2_1_0_alpha.description, "2.1.0-alpha")
        XCTAssertEqual(Semantic( ver_2_1_0_alpha.description ) , ver_2_1_0_alpha)

        XCTAssertEqual(ver_2_1_1_alpha.description, "2.1.1-alpha")
        XCTAssertEqual(Semantic( ver_2_1_1_alpha.description ) , ver_2_1_1_alpha)

        XCTAssertEqual(ver_2_0_0_beta.description, "2.0.0-beta")
        XCTAssertEqual(Semantic( ver_2_0_0_beta.description ) , ver_2_0_0_beta)

        XCTAssertEqual(ver_2_1_0_beta.description, "2.1.0-beta")
        XCTAssertEqual(Semantic( ver_2_1_0_beta.description ) , ver_2_1_0_beta)

        XCTAssertEqual(ver_2_1_1_beta.description, "2.1.1-beta")
        XCTAssertEqual(Semantic( ver_2_1_1_beta.description ) , ver_2_1_1_beta)

        XCTAssertEqual(ver_2_0_0_alpha_beta.description, "2.0.0-alpha.beta")
        XCTAssertEqual(Semantic( ver_2_0_0_alpha_beta.description ) , ver_2_0_0_alpha_beta)

        XCTAssertEqual(ver_2_1_0_alpha_beta.description, "2.1.0-alpha.beta")
        XCTAssertEqual(Semantic( ver_2_1_0_alpha_beta.description ) , ver_2_1_0_alpha_beta)

        XCTAssertEqual(ver_2_1_1_alpha_beta.description, "2.1.1-alpha.beta")
        XCTAssertEqual(Semantic( ver_2_1_1_alpha_beta.description ) , ver_2_1_1_alpha_beta)

        XCTAssertEqual(ver_2_0_0_b1.description, "2.0.0+1")
        XCTAssertEqual(Semantic( ver_2_0_0_b1.description ) , ver_2_0_0_b1)

        XCTAssertEqual(ver_2_1_0_b1.description, "2.1.0+1")
        XCTAssertEqual(Semantic( ver_2_1_0_b1.description ) , ver_2_1_0_b1)

        XCTAssertEqual(ver_2_1_1_b1.description, "2.1.1+1")
        XCTAssertEqual(Semantic( ver_2_1_1_b1.description ) , ver_2_1_1_b1)

        XCTAssertEqual(ver_2_0_0_beta_b1.description, "2.0.0-beta+1")
        XCTAssertEqual(Semantic( ver_2_0_0_beta_b1.description ) , ver_2_0_0_beta_b1)

        XCTAssertEqual(ver_2_1_0_beta_b1.description, "2.1.0-beta+1")
        XCTAssertEqual(Semantic( ver_2_1_0_beta_b1.description ) , ver_2_1_0_beta_b1)

        XCTAssertEqual(ver_2_1_1_beta_b1.description, "2.1.1-beta+1")
        XCTAssertEqual(Semantic( ver_2_1_1_beta_b1.description ) , ver_2_1_1_beta_b1)
    }

    func test_semantic_printing_manyOptions() {

        // Arrange
        let sut = Semantic.vib(
            ver: .init(major: 1, minor: 42, patch: 69),
            ids: [.alpha, .beta, .init(string: "omega")!],
            build: [ .init(string: "exe")!, .init(string: "sha")!, .init(string: "4433ffGG")!, .init(string: "07")! ]
        )

        let expectedString = "1.42.69-alpha.beta.omega+exe.sha.4433ffGG.07"

        // Act
        let parsed = Semantic( expectedString )

        XCTAssertNotNil( parsed, "Should create a valid version!" )

        if let parsed {
            XCTAssertEqual( parsed, sut )

            // Specification says that in normal comparison metadata
            // should be ignored.
            XCTAssertEqual( parsed.metadata!, sut.metadata!)

            XCTAssertEqual( sut.description, expectedString )
        }
    }
}
