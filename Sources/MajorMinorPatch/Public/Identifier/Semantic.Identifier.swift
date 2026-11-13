import Foundation

extension Semantic {

    public struct Identifier {
        let value: String

        public init?(string: String) {

            guard
                isValidIdentifier(string)
            else {
                return nil
            }

            self.value = string
        }
    }
}

// MARK: - Nicer API

public extension Semantic.Identifier {
    static var alpha: Self { .init(string: "alpha")! }
    static var beta : Self { .init(string: "beta")!  }
}

// MARK: - Comparable

extension Semantic.Identifier: Comparable {

    public static func == (lhs: Semantic.Identifier, rhs: Semantic.Identifier) -> Bool {
        lhs.value == rhs.value
    }

    /// https://semver.org/#spec-item-11 (4.1-4.3):
    /// numeric identifiers compare numerically, alphanumeric ones lexically in ASCII order,
    /// and numeric identifiers always have lower precedence than alphanumeric ones.
    public static func < (lhs: Semantic.Identifier, rhs: Semantic.Identifier) -> Bool {
        switch (lhs.isNumeric, rhs.isNumeric) {
        case (true, true):
            // No leading zeros (validated), so a shorter digit string is a smaller number;
            // comparing by length first avoids overflow for arbitrarily long numbers.
            if lhs.value.utf8.count != rhs.value.utf8.count {
                return lhs.value.utf8.count < rhs.value.utf8.count
            }
            return lhs.value.utf8.lexicographicallyPrecedes(rhs.value.utf8)
        case (true, false):
            return true
        case (false, true):
            return false
        case (false, false):
            return lhs.value.utf8.lexicographicallyPrecedes(rhs.value.utf8)
        }
    }

    var isNumeric: Bool {
        value.utf8.allSatisfy { $0 >= UInt8(ascii: "0") && $0 <= UInt8(ascii: "9") }
    }

}
