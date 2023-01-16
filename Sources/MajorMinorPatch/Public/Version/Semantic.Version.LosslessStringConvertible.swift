
import Foundation

extension Semantic.Version: LosslessStringConvertible {

    public var description: String {
        "\(major.description).\(minor.description).\(patch.description)"
    }

    public init?(_ description: String) {
        do {
            self = try Self.parser.parse(description[...])
        } catch {
            return nil
        }
    }
}
