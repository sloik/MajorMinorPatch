
import Foundation

public func ~= (pattern: Semantic.Major, value: Semantic.Major) -> Bool {
    pattern.rawValue == value.rawValue
}

public func ~= (pattern: UInt, value: Semantic.Major) -> Bool {
    pattern == value.rawValue
}
