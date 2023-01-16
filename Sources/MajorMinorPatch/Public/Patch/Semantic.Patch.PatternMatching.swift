
import Foundation

public func ~= (pattern: Semantic.Patch, value: Semantic.Patch) -> Bool {
    pattern.rawValue == value.rawValue
}

public func ~= (pattern: UInt, value: Semantic.Patch) -> Bool {
    pattern == value.rawValue
}
