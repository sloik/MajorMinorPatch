
import Foundation

extension Semantic {

    public struct Major: ExpressibleByIntegerLiteral, RawRepresentable {

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

// MARK: - Nicer API

extension Semantic.Major {

    static public var one: Semantic.Major { 1 }

    static public var max: Semantic.Major {
        .init(integerLiteral: .max)
    }

    static public var min: Semantic.Major {
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

extension Semantic.Major {
    /// Returns incremented version of `Major`. Is self is at max value than returns copy.
    var incremented: Semantic.Major {
        isMax ? self : self + .one
    }

    /// Returns decremented version of `Major`. Is self is at min value than returns copy.
    var decremented: Semantic.Major {
        isMin ? self : self - .one
    }
}

// MARK: -
