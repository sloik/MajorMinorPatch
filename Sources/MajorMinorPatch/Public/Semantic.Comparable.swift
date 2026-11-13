import Foundation

/// Precedence follows https://semver.org/#spec-item-11:
/// - versions compare by major, minor, patch;
/// - with equal versions, a pre-release has lower precedence than the release;
/// - two pre-releases of the same version compare by their identifiers;
/// - build metadata MUST be ignored, so `==` means "same precedence" and holds across
///   cases that differ only in build metadata (`.v` == `.vb`, `.vi` == `.vib`).
extension Semantic: Comparable {

    /// Pre-release identifiers, or `nil` for a release.
    private var preRelease: [Identifier]? {
        switch self {
        case .v, .vb:
            return .none
        case .vi(_, let ids), .vib(_, let ids, _):
            return ids.isEmpty ? .none : ids
        }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.version == rhs.version && lhs.preRelease == rhs.preRelease
    }

    public static func < (lhs: Semantic, rhs: Semantic) -> Bool {
        if lhs.version != rhs.version {
            return lhs.version < rhs.version
        }

        switch (lhs.preRelease, rhs.preRelease) {
        case (.none, .none):
            return false
        case (.some, .none):
            return true
        case (.none, .some):
            return false
        case (.some(let l), .some(let r)):
            return l < r
        }
    }
}
