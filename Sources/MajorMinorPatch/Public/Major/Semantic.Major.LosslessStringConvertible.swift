
import Foundation

// MARK: - LosslessStringConvertible

extension Semantic.Major: LosslessStringConvertible {

    public var description: String {
        String(rawValue)
    }

    public init?(_ description: String) {
        do {
            self = try Self.parser.parse(description[...])
        } catch {
            return nil
        }
    }
}
