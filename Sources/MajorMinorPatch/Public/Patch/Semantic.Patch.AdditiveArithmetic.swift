
import Foundation

extension Semantic.Patch: AdditiveArithmetic {

    static public var zero: Semantic.Patch { 0 }

    public static func - (lhs: Semantic.Patch, rhs: Semantic.Patch) -> Semantic.Patch {
        .init(integerLiteral: lhs.rawValue - rhs.rawValue)
    }

    public static func + (lhs: Semantic.Patch, rhs: Semantic.Patch) -> Semantic.Patch {
        .init(integerLiteral: lhs.rawValue + rhs.rawValue)
    }
}
