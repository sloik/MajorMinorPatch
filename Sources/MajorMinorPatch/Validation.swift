
import Foundation

fileprivate var lowercase26: CharacterSet { CharacterSet(charactersIn: "a"..."z") }
fileprivate var uppercase26: CharacterSet { CharacterSet(charactersIn: "A"..."Z") }
fileprivate var digits10   : CharacterSet { CharacterSet(charactersIn: "0"..."9") }
fileprivate var dash1      : CharacterSet { CharacterSet(charactersIn: "-") }

fileprivate var validIdentifierCharacters: CharacterSet {
    lowercase26
        .union(uppercase26)
        .union(digits10)
        .union(dash1)
}

/// https://semver.org/#spec-item-9
///
///  Identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-].
///  Identifiers MUST NOT be empty. Numeric identifiers MUST NOT include leading
///  zeroes.
func isValidIdentifier(_ string: String) -> Bool {

    // Identifiers MUST NOT be empty.
    // Identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-]
    guard
        string.isEmpty == false,
        string.unicodeScalars.allSatisfy( validIdentifierCharacters.contains )
    else {
        return false
    }

    //  Numeric identifiers MUST NOT include leading zeroes.
    let isNumeric = string.unicodeScalars.allSatisfy( digits10.contains )
    if isNumeric && string.count > 1 {
        return string.starts(with: "0") == false
    }

    return true
}

/// Identifiers MUST comprise only ASCII alphanumerics and hyphens [0-9A-Za-z-].
/// Identifiers MUST NOT be empty.
func isValidBuildIdentifier(_ string: String) -> Bool {
    
    string.isEmpty == false &&
    string.unicodeScalars.allSatisfy( validIdentifierCharacters.contains )
}
