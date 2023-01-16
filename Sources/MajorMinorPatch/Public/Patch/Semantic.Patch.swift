
import Foundation

extension Semantic {

    public struct Patch: ExpressibleByIntegerLiteral, RawRepresentable {

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

// MARK: - Nice API

extension Semantic.Patch {

    static public var one: Semantic.Patch { 1 }

    static public var max: Semantic.Patch {
        .init(integerLiteral: .max)
    }

    static public var min: Semantic.Patch {
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

extension Semantic.Patch {
    /// Returns incremented version of `Patch`. Is self is at max value than returns copy.
    var incremented: Semantic.Patch {
        isMax ? self : self + .one
    }

    /// Returns decremented version of `Patch`. Is self is at min value than returns copy.
    var decremented: Semantic.Patch {
        isMin ? self : self - .one
    }
}

// MARK: -
