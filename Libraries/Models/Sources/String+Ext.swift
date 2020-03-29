import Foundation

extension String {
    /// Generate new string as Capitalized format
    ///
    /// E.g:
    ///  - email -> Email
    ///  - firstName -> First Name

    public func camelCaseToCapitalize() -> String {
        var stringToReturn = ""
        for chr in self {
            let str = String(chr)
            if str.lowercased() != str {
                stringToReturn = "\(stringToReturn) \(str)"
            } else {
                stringToReturn = "\(stringToReturn)\(str)"
            }
        }
        return stringToReturn.capitalized
    }

    /// https://gist.github.com/stevenschobert/540dd33e828461916c11
    public func camelize() -> String {
        let source = clean(with: " ", allOf: "-", "_")
        if source.contains(" ") {
            let first = String(source[..<source.index(after: source.startIndex)])
            let cammel =
                NSString(
                    format: "%@",
                    (source as NSString).capitalized.replacingOccurrences(of: " ", with: ""))
                as String
            let rest = String(cammel.dropFirst())
            return "\(first.lowercased())\(rest)"
        } else {
            let first = String(
                (source as NSString).lowercased[..<source.index(after: source.startIndex)])
            let rest = String(source.dropFirst())
            return "\(first.lowercased())\(rest)"
        }
    }

    func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
}
