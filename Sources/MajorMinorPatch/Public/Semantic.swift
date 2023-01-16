
import Foundation

public enum Semantic {

    /// Contains ony version.
    case v(ver: Version)

    /// Contains version and identifiers.
    case vi(ver: Version, ids: [Identifier])

    /// Contains version and build metadata.
    case vb(ver: Version, build: [Metadata])

    /// Contains version, identifiers and build metadata.
    case vib(ver: Version, ids: [Identifier], build: [Metadata])
}


// MARK: - Nicer API

public extension Semantic {

    /// `Version` ignoring any identifiers and build metadata.
    var version: Version {
        switch self {
        case .v(let ver):
            return ver

        case .vi(let ver, _):
            return ver

        case .vb(let ver, _):
            return ver

        case .vib(let ver, _, _):
            return ver
        }
    }

    var identifiers: [Identifier]? {
        switch self {
        case .vi(_, let ids):
            return ids.isEmpty ? .none : ids

        case .vib(_, let ids, _):
            return ids.isEmpty ? .none : ids

        default:
            return .none
        }
    }

    var metadata: [Metadata]? {
        switch self {
        case .vb(_, let build):
            return build
        case .vib(_, _, let build):
            return build

        default:
            return .none
        }
    }

}

// MARK: - Common Versions

public extension Semantic {

    /// 0.0.0
    static var ver_0_0_0: Semantic {
        .v(ver: Version(major: 0, minor: 0, patch: 0))
    }

    /// 1.0.0
    static var ver_1_0_0: Semantic {
        .v(ver: Version(major: 1, minor: 0, patch: 0))
    }
}
