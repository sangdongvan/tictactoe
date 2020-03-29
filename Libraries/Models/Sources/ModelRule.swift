import Foundation

public protocol ModelRule {
    var property: String { get }
    var error: String { get }

    func validate(_ model: Model) -> Bool
    func getPropertyValue(_ model: Model) -> Any?
    func getPropertyValue(_ model: Model, keyPath: String) -> Any?
}

extension ModelRule {
    /// Derive the business object value based on the rule's property
    ///
    /// - Parameter model: Model
    /// - Returns: Any?
    ///
    public func getPropertyValue(_ model: Model) -> Any? {
        /// Reflect the `model` to have ability to derive
        /// the property of `model` via `ModelRule.property` variable
        let mirror = Mirror(reflecting: model)
        for child in mirror.children.enumerated() {
            if let label = child.element.label, label == property {
                return child.element.value
            }
        }
        return nil
    }

    /// Derive the business object value based on the `keyPath` parameter
    ///
    /// - Parameter model: Model
    /// - Parameter keyPath: String
    /// - Returns: Any?
    ///
    public func getPropertyValue(_ model: Model, keyPath: String) -> Any? {
        /// Reflect the `model` to have ability to derive
        /// the property of `model` via `ModelRule.property` variable
        let mirror = Mirror(reflecting: model)
        for child in mirror.children.enumerated() {
            if let label = child.element.label, label == keyPath {
                return child.element.value
            }
        }
        return nil
    }
}

extension ModelRule {
    public var description: String {
        return "\(error)"
    }
}

public struct ValidateRequired: ModelRule {
    public var property: String
    public var error: String

    init(property: String) {
        self.property = property
        self.error = "\(property.camelCaseToCapitalize()) is a required field"
    }

    public func validate(_ model: Model) -> Bool {
        switch getPropertyValue(model) {
        case let stringToTest as String:
            return stringToTest.count > 0

        /// Check if property not exist
        case .none:
            return false

        /// Check if property exists and it's nil or not?
        case .some(let unwrapped as Any?):
            return unwrapped != nil

        /// If the property exist and not nil
        default:
            return true
        }
    }
}

protocol ValidateRegexRule: ModelRule {
    var pattern: String { get }
}

extension ValidateRegexRule {
    public func validate(_ model: Model) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        guard let stringToTest = getPropertyValue(model) as? String else {
            return false
        }
        if predicate.evaluate(with: stringToTest) {
            return true
        }
        return false
    }
}

public struct ValidateRegex: ValidateRegexRule {
    public var property: String
    public var error: String
    var pattern: String

    init(property: String, pattern: String) {
        self.pattern = pattern
        self.property = property
        self.error = "\(property.camelCaseToCapitalize()) is a required field"
    }

    init(property: String, error: String, pattern: String) {
        self.init(property: property, pattern: pattern)
        self.error = error
    }
}

public struct ValidateEmail: ValidateRegexRule {
    public var property: String
    public var error: String
    var pattern: String

    init(property: String, error: String) {
        self.pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        self.property = property
        self.error = error
    }

    init(property: String) {
        self.init(property: property, error: "\(property.camelCaseToCapitalize()) is invalid email")
    }
}

public struct ValidatePhoneNumber: ValidateRegexRule {
    public var property: String
    public var error: String
    var pattern: String { "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" }

    init(property: String, error: String) {
        self.property = property
        self.error = error
    }

    init(property: String) {
        self.init(
            property: property, error: "\(property.camelCaseToCapitalize()) is invalid phone number"
        )
    }
}

public struct ValidateBirthday: ModelRule {
    public var property: String
    public var error: String

    public func validate(_ model: Model) -> Bool {
        guard let birthday = getPropertyValue(model) as? Date else {
            return false
        }
        /// The left operand is smaller than the right operand
        switch birthday.compare(Date(timeIntervalSinceNow: 0)) {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
}

public struct ValidateRelated: ModelRule {
    public var property: String
    public var error: String

    enum ComparationType {
        case match
        case comparator((String, String) -> Bool)
    }

    var otherProperty: String
    var comparationType: ComparationType

    init(property: String, and otherProperty: String, type comparationType: ComparationType) {
        self.property = property
        self.otherProperty = otherProperty
        self.comparationType = comparationType
        self.error = "\(property.camelCaseToCapitalize()) is invalid"
    }

    public func validate(_ model: Model) -> Bool {
        switch comparationType {
        case .match:
            let propertyValue = getPropertyValue(model, keyPath: property) as? String
            let otherPropertyValue = getPropertyValue(model, keyPath: otherProperty) as? String
            return propertyValue == otherPropertyValue

        default:
            // Not implemented yet
            return false
        }
    }
}

public struct ValidateBoundary<T: Comparable>: ModelRule {
    public var property: String
    public var error: String

    var min: T?
    var max: T?

    init(property: String, error: String? = nil, min: T? = nil, max: T? = nil) {
        self.property = property
        self.min = min
        self.max = max

        if let error = error {
            self.error = error
        } else {
            self.error = "\(property.camelCaseToCapitalize()) is invalid"
        }
    }

    public func validate(_ model: Model) -> Bool {
        guard let propertyValue = getPropertyValue(model) as? T else {
            return false
        }

        if let min = min, propertyValue <= min {
            return false
        }

        if let max = max, propertyValue >= max {
            return false
        }

        return true
    }
}
