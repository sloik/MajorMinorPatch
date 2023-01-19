
import Foundation

// https://semver.org/#spec-item-11 section 4
// Precedence for two pre-release versions with the same major, minor, and patch
// version MUST be determined by comparing each dot separated identifier
// from left to right until a difference is found as follows:
//
// 1 Identifiers consisting of only digits are compared numerically.
//
// 2. Identifiers with letters or hyphens are compared lexically in ASCII sort order.
//
// 3. Numeric identifiers always have lower precedence than non-numeric identifiers.
//
// 4. A larger set of pre-release fields has a higher precedence than a smaller set,
//    if all of the preceding identifiers are equal.
//
// Example: 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0.


extension [Semantic.Identifier]: Comparable {

    public static func == (lhs: [Semantic.Identifier], rhs: [Semantic.Identifier]) -> Bool {
        lhs.count == rhs.count && zip(lhs, rhs).allSatisfy( == )
    }

    public static func < (lhs: [Semantic.Identifier], rhs: [Semantic.Identifier]) -> Bool {

        // [] < []
        if lhs.isEmpty && rhs.isEmpty { return false }

        // [] < [...]
        if lhs.isEmpty && rhs.isEmpty == false { return true }

        // [...] < []
        if lhs.isEmpty == false && rhs.isEmpty { return false }

        // we have elements so we can drop them
        let l = lhs.first!
        let r = rhs.first!

        // elements are the same so check rest of the identifiers
        return l == r
            ? Array(lhs[1...]) < Array(rhs[1...])
            : l < r
    }

}
