
import Foundation

extension Semantic: LosslessStringConvertible {

    public var description: String {
        switch self {

        case .v(let ver):
            return ver.description

        case .vi(let ver, let ids):
            let idsString: String = ids.map( \.description ).joined(separator: ".")
            return ver.description + "-" + idsString

        case .vb(let ver, let build):
            let metadataString: String = build.map( \.description ).joined(separator: ".")
            return ver.description + "+" + metadataString

        case .vib(let ver, let ids, let build):
            let idsString: String = ids.map( \.description ).joined(separator: ".")
            let metadataString: String = build.map( \.description ).joined(separator: ".")

            return ver.description + "-" + idsString + "+" + metadataString
        }
    }

    public init?(_ description: String) {
        do {
            self = try Self.parser.parse(description[...])
        } catch {
            return nil
        }
    }
}
