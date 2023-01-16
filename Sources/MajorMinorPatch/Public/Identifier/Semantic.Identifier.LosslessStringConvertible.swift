
import Foundation

extension Semantic.Identifier: LosslessStringConvertible {

    public var description: String {
        value
    }

    public init?(_ description: String) {
        do {
            self = try Self.parser.parse(description[...])
        } catch {
            return nil
        }
    }
}
