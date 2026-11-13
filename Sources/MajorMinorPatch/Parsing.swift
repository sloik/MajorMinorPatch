
import Foundation
import Parsing

extension Semantic.Major {

    static var parser: AnyParser<Substring, Semantic.Major> {
        numericComponentParser.map( Semantic.Major.init(integerLiteral:) ).eraseToAnyParser()
    }
}

extension Semantic.Minor {

    static var parser: AnyParser<Substring, Semantic.Minor> {
        numericComponentParser.map( Semantic.Minor.init(integerLiteral:) ).eraseToAnyParser()
    }
}

extension Semantic.Patch {

    static var parser: AnyParser<Substring, Semantic.Patch> {
        numericComponentParser.map( Semantic.Patch.init(integerLiteral:) ).eraseToAnyParser()
    }
}

/// https://semver.org/#spec-item-2: a non-negative integer that MUST NOT contain leading zeroes.
var numericComponentParser: AnyParser<Substring, UInt> {
    Prefix(1...) { $0.isASCII && $0.isNumber }
        .compactMap { (digits: Substring) -> UInt? in
            if digits.count > 1 && digits.first == "0" { return nil }
            return UInt(digits)
        }
        .eraseToAnyParser()
}

extension Semantic.Version {

    static var parser: AnyParser<Substring, Semantic.Version> {

        Parse( Semantic.Version.init(major:minor:patch:) ) {
            Semantic.Major.parser
            "."
            Semantic.Minor.parser
            "."
            Semantic.Patch.parser
        }
        .eraseToAnyParser()
    }
}

extension Semantic.Identifier {

    static var parser: AnyParser<Substring, Semantic.Identifier> {

        Prefix(
            while: { $0 != "." && $0 != "+" }
        )
        .map(
            AnyConversion(
                apply: { (sub: Substring) -> Semantic.Identifier? in
                    Semantic.Identifier(string: String(sub))
                },
                unapply: { (identifier: Semantic.Identifier) -> Substring? in
                    identifier.value[...]
                }
            )
        )
        .eraseToAnyParser()
    }
}

var arrayOfIdentifiersParser: AnyParser<Substring, [Semantic.Identifier]> {
    // https://semver.org/#spec-item-9: a pre-release is one or more identifiers.
    Many(1...) {
        Semantic.Identifier.parser
    } separator: {
        "."
    }
    .eraseToAnyParser()
}

extension Semantic.Metadata {
    static var parser: AnyParser<Substring, Semantic.Metadata> {

        Prefix(
            while: { $0 != "." }
        )
        .map(
            AnyConversion(
                apply: { (sub: Substring) -> Semantic.Metadata? in
                    Semantic.Metadata(string: String(sub))
                },
                unapply: { (metadata: Semantic.Metadata) -> Substring? in
                    metadata.value[...]
                }
            )
        )
        .eraseToAnyParser()
    }
}

var arrayOfMetdataParser: AnyParser<Substring, [Semantic.Metadata]> {
    // https://semver.org/#spec-item-10: build metadata is one or more identifiers.
    Many(1...) {
        Semantic.Metadata.parser
    } separator: {
        "."
    } 
    .eraseToAnyParser()
}

var versionIdentifiersMetadataParser: AnyParser<Substring, Semantic> {

    Parse {
        versionParser
        "-"
        arrayOfIdentifiersParser
        "+"
        arrayOfMetdataParser
    }
    .map { (sem: Semantic, ids: [Semantic.Identifier], metadata: [Semantic.Metadata]) -> Semantic in
        Semantic.vib(ver: sem.version, ids: ids, build: metadata)
    }
    .eraseToAnyParser()
}

var versionMetadataParser: AnyParser<Substring, Semantic> {

    Parse {
        versionParser
        "+"
        arrayOfMetdataParser
    }
    .map { (sem: Semantic, metadata: [Semantic.Metadata]) -> Semantic in
        Semantic.vb(ver: sem.version, build: metadata)
    }
    .eraseToAnyParser()
}

var versionIdentifiersParser: AnyParser<Substring, Semantic> {

    Parse {
        versionParser
        "-"
        arrayOfIdentifiersParser
    }
    .map { (sem: Semantic, ids: [Semantic.Identifier]) -> Semantic in
        Semantic.vi(ver: sem.version, ids: ids)
    }
    .eraseToAnyParser()
}

var versionParser: AnyParser<Substring, Semantic> {
    Semantic.Version.parser.map( Semantic.v(ver:) ).eraseToAnyParser()
}

extension Semantic {
    static var parser: AnyParser<Substring, Semantic> {
        OneOf {
            versionIdentifiersMetadataParser
            versionMetadataParser
            versionIdentifiersParser
            versionParser
        }
        .eraseToAnyParser()
    }
}


func parse(string: String) -> Semantic? {

    let semVer: Semantic?

    do {
        semVer = try Semantic.parser.parse(string)
    } catch {
        semVer = .none
    }

    return semVer
}
