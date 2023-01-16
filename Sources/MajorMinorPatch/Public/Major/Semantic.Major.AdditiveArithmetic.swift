
import Foundation

//MARK: - AdditiveArithmetic

extension Semantic.Major: AdditiveArithmetic {

    static public var zero: Semantic.Major { 0 }

    public static func - (lhs: Semantic.Major, rhs: Semantic.Major) -> Semantic.Major {
        .init(integerLiteral: lhs.rawValue - rhs.rawValue)
    }

    public static func + (lhs: Semantic.Major, rhs: Semantic.Major) -> Semantic.Major {
        .init(integerLiteral: lhs.rawValue + rhs.rawValue)
    }

}
