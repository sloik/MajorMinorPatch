
import Foundation

extension Semantic {

    public struct Version {

        let major: Major
        let minor: Minor
        let patch: Patch

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

        if lhs.major < rhs.major  { return true }
        if lhs.minor < rhs.minor  { return true }
        if lhs.patch < rhs.patch  { return true }

        return false
    }
}
