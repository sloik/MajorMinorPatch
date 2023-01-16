
import Foundation

extension [Semantic.Identifier]: Comparable {

    public static func < (lhs: [Element], rhs: [Element]) -> Bool {

        let lefts = lhs.map(\.value).joined(separator: ".")
        let rights = rhs.map(\.value).joined(separator: ".")

        return lefts < rights
    }

}
