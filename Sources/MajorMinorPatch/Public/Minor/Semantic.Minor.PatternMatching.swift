
import Foundation

public func ~= (pattern: Semantic.Minor, value: Semantic.Minor) -> Bool {
    pattern.rawValue == value.rawValue
}

public func ~= (pattern: UInt, value: Semantic.Minor) -> Bool {
    pattern == value.rawValue
}
