
import Foundation

extension Semantic {

    public struct Version {

        public let major: Major
        public let minor: Minor
        public let patch: Patch

        public init(
            major: Semantic.Major,
            minor: Semantic.Minor,
            patch: Semantic.Patch
        ) {
            self.major = major
            self.minor = minor
            self.patch = patch
        }
    }

}

extension Semantic.Version: Comparable {

    public static func < (lhs: Semantic.Version, rhs: Semantic.Version) -> Bool {

        // https://semver.org/#spec-item-11 (2): major, then minor, then patch, numerically.
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}
