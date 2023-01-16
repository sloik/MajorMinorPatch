
import Foundation

extension Semantic: Comparable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case ( .v, .v ):
            return lhs.version == rhs.version

        case ( .vi, .vi):
            return lhs.version == rhs.version && lhs.identifiers! == rhs.identifiers!

        case ( .vb, .vb ):
            return lhs.version == rhs.version

        case ( .vib, .vib):
            return lhs.version == rhs.version && lhs.identifiers! == rhs.identifiers!

        default:
            return false
        }
    }

    public static func < (lhs: Semantic, rhs: Semantic) -> Bool {

        switch (lhs, rhs) {

        case ( .v, .v ):
            return lhs.version < rhs.version

        case ( .v, .vi ):
            return lhs.version < rhs.version

        case ( .vi, .v ):
            return true

        case ( .vi,  .vi ):
            return lhs.version == rhs.version
                ? lhs.identifiers! < rhs.identifiers!
                : lhs.version < rhs.version

        /// Build metadata MUST be ignored when determining version precedence.
        /// Thus two versions that differ only in the build metadata,
        /// have the same precedence
        case ( .vib(let lv, let li, _), .vib(let rv, let ri, _)):
            return Semantic.vi(ver: lv, ids: li) < Semantic.vi(ver: rv, ids: ri)

        default:
            return false
        }
    }
}
