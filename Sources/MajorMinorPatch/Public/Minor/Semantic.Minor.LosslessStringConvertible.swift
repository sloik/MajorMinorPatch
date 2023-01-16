
import Foundation

extension Semantic.Minor: LosslessStringConvertible {

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
