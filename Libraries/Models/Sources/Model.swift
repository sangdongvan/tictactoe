import Foundation

public struct Model {

    /// List of business rules
    private(set) var rules: [ModelRule] = []

    /// List of validation errors
    public private(set) var invalidRules: [ModelRule] = []

    mutating func addRule(_ rule: ModelRule) {
        rules.append(rule)
    }

    /// A getter to check validation status of Business Object without side effect
    /// to the `invalidRules` property
    ///
    public var isValid: Bool {
        return invalidRules.count == 0
    }

    /// determine whether business rules are valid or not.
    ///
    /// - Returns: Bool
    ///
    @discardableResult
    public mutating func validate() -> Bool {
        /// Clean previous check before validating
        invalidRules.removeAll()

        for rule in rules {
            if !rule.validate(self) {
                invalidRules.append(rule)
            }
        }

        return isValid
    }
}
