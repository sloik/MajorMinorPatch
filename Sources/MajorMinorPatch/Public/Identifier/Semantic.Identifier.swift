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

    public static func < (lhs: Semantic.Identifier, rhs: Semantic.Identifier) -> Bool {
        lhs.value < rhs.value
    }

}
