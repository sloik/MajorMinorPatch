
import Foundation

extension Semantic {

    public struct Minor: ExpressibleByIntegerLiteral, RawRepresentable {

        public let rawValue: UInt

        public init(integerLiteral value: UInt) {
            self.rawValue = value
        }

        public init?(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public init(_ value: UInt) {
            self.rawValue = value
        }
    }
}

// MARK: - Common

extension Semantic.Minor {

    static public var one: Semantic.Minor { 1 }

    static public var max: Semantic.Minor {
        .init(integerLiteral: .max)
    }

    static public var min: Semantic.Minor {
        .init(integerLiteral: .min)
    }

    var isZero: Bool {
        self == .zero
    }

    var isMax: Bool {
        self == .max
    }

    var isMin: Bool {
        self == .min
    }
}

// MARK: - Incrementation Decrementation

extension Semantic.Minor {
    /// Returns incremented version of `Minor`. Is self is at max value than returns copy.
    var incremented: Semantic.Minor {
        isMax ? self : self + .one
    }

    /// Returns decremented version of `Minor`. Is self is at min value than returns copy.
    var decremented: Semantic.Minor {
        isMin ? self : self - .one
    }
}

// MARK: -
