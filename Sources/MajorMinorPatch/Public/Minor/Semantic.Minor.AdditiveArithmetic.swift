
import Foundation

extension Semantic.Minor: AdditiveArithmetic {

    static public var zero: Semantic.Minor { 0 }

    public static func - (lhs: Semantic.Minor, rhs: Semantic.Minor) -> Semantic.Minor {
        .init(integerLiteral: lhs.rawValue - rhs.rawValue)
    }

    public static func + (lhs: Semantic.Minor, rhs: Semantic.Minor) -> Semantic.Minor {
        .init(integerLiteral: lhs.rawValue + rhs.rawValue)
    }

}
