//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
import Foundation

public protocol GraphQLInputValue {
}

public struct GraphQLVariable {
  let name: String
  
  public init(_ name: String) {
    self.name = name
  }
}

extension GraphQLVariable: GraphQLInputValue {
}

extension JSONEncodable {
  public func evaluate(with variables: [String: JSONEncodable]?) throws -> Any {
    return jsonValue
  }
}

public typealias GraphQLMap = [String: JSONEncodable?]

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var withNilValuesRemoved: Dictionary<String, JSONEncodable> {
    var filtered = Dictionary<String, JSONEncodable>(minimumCapacity: count)
    for (key, value) in self {
      if value != nil {
        filtered[key] = value
      }
    }
    return filtered
  }
}

public protocol GraphQLMapConvertible: JSONEncodable {
  var graphQLMap: GraphQLMap { get }
}

public extension GraphQLMapConvertible {
  var jsonValue: Any {
    return graphQLMap.withNilValuesRemoved.jsonValue
  }
}

public typealias GraphQLID = String

public protocol APISwiftGraphQLOperation: AnyObject {
  
  static var operationString: String { get }
  static var requestString: String { get }
  static var operationIdentifier: String? { get }
  
  var variables: GraphQLMap? { get }
  
  associatedtype Data: GraphQLSelectionSet
}

public extension APISwiftGraphQLOperation {
  static var requestString: String {
    return operationString
  }

  static var operationIdentifier: String? {
    return nil
  }

  var variables: GraphQLMap? {
    return nil
  }
}

public protocol GraphQLQuery: APISwiftGraphQLOperation {}

public protocol GraphQLMutation: APISwiftGraphQLOperation {}

public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

public protocol GraphQLFragment: GraphQLSelectionSet {
  static var possibleTypes: [String] { get }
}

public typealias Snapshot = [String: Any?]

public protocol GraphQLSelectionSet: Decodable {
  static var selections: [GraphQLSelection] { get }
  
  var snapshot: Snapshot { get }
  init(snapshot: Snapshot)
}

extension GraphQLSelectionSet {
    public init(from decoder: Decoder) throws {
        if let jsonObject = try? APISwiftJSONValue(from: decoder) {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jsonObject)
            let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

            self.init(snapshot: optionalDictionary)
        } else {
            self.init(snapshot: [:])
        }
    }
}

enum APISwiftJSONValue: Codable {
    case array([APISwiftJSONValue])
    case boolean(Bool)
    case number(Double)
    case object([String: APISwiftJSONValue])
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode([String: APISwiftJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([APISwiftJSONValue].self) {
            self = .array(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .array(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public protocol GraphQLSelection {
}

public struct GraphQLField: GraphQLSelection {
  let name: String
  let alias: String?
  let arguments: [String: GraphQLInputValue]?
  
  var responseKey: String {
    return alias ?? name
  }
  
  let type: GraphQLOutputType
  
  public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
    self.name = name
    self.alias = alias
    
    self.arguments = arguments
    
    self.type = type
  }
}

public indirect enum GraphQLOutputType {
  case scalar(JSONDecodable.Type)
  case object([GraphQLSelection])
  case nonNull(GraphQLOutputType)
  case list(GraphQLOutputType)
  
  var namedType: GraphQLOutputType {
    switch self {
    case .nonNull(let innerType), .list(let innerType):
      return innerType.namedType
    case .scalar, .object:
      return self
    }
  }
}

public struct GraphQLBooleanCondition: GraphQLSelection {
  let variableName: String
  let inverted: Bool
  let selections: [GraphQLSelection]
  
  public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
    self.variableName = variableName
    self.inverted = inverted;
    self.selections = selections;
  }
}

public struct GraphQLTypeCondition: GraphQLSelection {
  let possibleTypes: [String]
  let selections: [GraphQLSelection]
  
  public init(possibleTypes: [String], selections: [GraphQLSelection]) {
    self.possibleTypes = possibleTypes
    self.selections = selections;
  }
}

public struct GraphQLFragmentSpread: GraphQLSelection {
  let fragment: GraphQLFragment.Type
  
  public init(_ fragment: GraphQLFragment.Type) {
    self.fragment = fragment
  }
}

public struct GraphQLTypeCase: GraphQLSelection {
  let variants: [String: [GraphQLSelection]]
  let `default`: [GraphQLSelection]
  
  public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
    self.variants = variants
    self.default = `default`;
  }
}

public typealias JSONObject = [String: Any]

public protocol JSONDecodable {
  init(jsonValue value: Any) throws
}

public protocol JSONEncodable: GraphQLInputValue {
  var jsonValue: Any { get }
}

public enum JSONDecodingError: Error, LocalizedError {
  case missingValue
  case nullValue
  case wrongType
  case couldNotConvert(value: Any, to: Any.Type)
  
  public var errorDescription: String? {
    switch self {
    case .missingValue:
      return "Missing value"
    case .nullValue:
      return "Unexpected null value"
    case .wrongType:
      return "Wrong type"
    case .couldNotConvert(let value, let expectedType):
      return "Could not convert \"\(value)\" to \(expectedType)"
    }
  }
}

extension String: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = string
  }

  public var jsonValue: Any {
    return self
  }
}

extension Int: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Float: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Double: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Bool: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: Any {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: Any) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: Any {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: Any) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional: JSONEncodable {
  public var jsonValue: Any {
    switch self {
    case .none:
      return NSNull()
    case .some(let wrapped as JSONEncodable):
      return wrapped.jsonValue
    default:
      fatalError("Optional is only JSONEncodable if Wrapped is")
    }
  }
}

extension Dictionary: JSONEncodable {
  public var jsonValue: Any {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      if case let (key as String, value as JSONEncodable) = (key, value) {
        jsonObject[key] = value.jsonValue
      } else {
        fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
      }
    }
    return jsonObject
  }
}

extension Array: JSONEncodable {
  public var jsonValue: Any {
    return map() { element -> (Any) in
      if case let element as JSONEncodable = element {
        return element.jsonValue
      } else {
        fatalError("Array is only JSONEncodable if Element is")
      }
    }
  }
}

extension URL: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
    self.init(string: string)!
  }

  public var jsonValue: Any {
    return self.absoluteString
  }
}

extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { (_, new) in new }
  }
}

#elseif canImport(AWSAppSync)
import AWSAppSync
#endif

public struct CreatePrimaryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelPrimaryConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(and: [ModelPrimaryConditionInput?]? = nil, or: [ModelPrimaryConditionInput?]? = nil, not: ModelPrimaryConditionInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil) {
    graphQLMap = ["and": and, "or": or, "not": not, "createdAt": createdAt, "updatedAt": updatedAt]
  }

  public var and: [ModelPrimaryConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelPrimaryConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelPrimaryConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelPrimaryConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelPrimaryConditionInput? {
    get {
      return graphQLMap["not"] as! ModelPrimaryConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct UpdatePrimaryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct DeletePrimaryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateRelatedManyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, primaryId: GraphQLID) {
    graphQLMap = ["id": id, "primaryId": primaryId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: GraphQLID {
    get {
      return graphQLMap["primaryId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }
}

public struct ModelRelatedManyConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(primaryId: ModelIDInput? = nil, and: [ModelRelatedManyConditionInput?]? = nil, or: [ModelRelatedManyConditionInput?]? = nil, not: ModelRelatedManyConditionInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil) {
    graphQLMap = ["primaryId": primaryId, "and": and, "or": or, "not": not, "createdAt": createdAt, "updatedAt": updatedAt]
  }

  public var primaryId: ModelIDInput? {
    get {
      return graphQLMap["primaryId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }

  public var and: [ModelRelatedManyConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelRelatedManyConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelRelatedManyConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelRelatedManyConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelRelatedManyConditionInput? {
    get {
      return graphQLMap["not"] as! ModelRelatedManyConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct UpdateRelatedManyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, primaryId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "primaryId": primaryId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: GraphQLID? {
    get {
      return graphQLMap["primaryId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }
}

public struct DeleteRelatedManyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateRelatedOneInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, primaryId: GraphQLID) {
    graphQLMap = ["id": id, "primaryId": primaryId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: GraphQLID {
    get {
      return graphQLMap["primaryId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }
}

public struct ModelRelatedOneConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(primaryId: ModelIDInput? = nil, and: [ModelRelatedOneConditionInput?]? = nil, or: [ModelRelatedOneConditionInput?]? = nil, not: ModelRelatedOneConditionInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil) {
    graphQLMap = ["primaryId": primaryId, "and": and, "or": or, "not": not, "createdAt": createdAt, "updatedAt": updatedAt]
  }

  public var primaryId: ModelIDInput? {
    get {
      return graphQLMap["primaryId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }

  public var and: [ModelRelatedOneConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelRelatedOneConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelRelatedOneConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelRelatedOneConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelRelatedOneConditionInput? {
    get {
      return graphQLMap["not"] as! ModelRelatedOneConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }
}

public struct UpdateRelatedOneInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, primaryId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "primaryId": primaryId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: GraphQLID? {
    get {
      return graphQLMap["primaryId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }
}

public struct DeleteRelatedOneInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelPrimaryFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, and: [ModelPrimaryFilterInput?]? = nil, or: [ModelPrimaryFilterInput?]? = nil, not: ModelPrimaryFilterInput? = nil) {
    graphQLMap = ["id": id, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelPrimaryFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelPrimaryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelPrimaryFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelPrimaryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelPrimaryFilterInput? {
    get {
      return graphQLMap["not"] as! ModelPrimaryFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public enum ModelSortDirection: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case asc
  case desc
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ASC": self = .asc
      case "DESC": self = .desc
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .asc: return "ASC"
      case .desc: return "DESC"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelSortDirection, rhs: ModelSortDirection) -> Bool {
    switch (lhs, rhs) {
      case (.asc, .asc): return true
      case (.desc, .desc): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelRelatedManyFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, primaryId: ModelIDInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, and: [ModelRelatedManyFilterInput?]? = nil, or: [ModelRelatedManyFilterInput?]? = nil, not: ModelRelatedManyFilterInput? = nil) {
    graphQLMap = ["id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: ModelIDInput? {
    get {
      return graphQLMap["primaryId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelRelatedManyFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelRelatedManyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelRelatedManyFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelRelatedManyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelRelatedManyFilterInput? {
    get {
      return graphQLMap["not"] as! ModelRelatedManyFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelRelatedOneFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, primaryId: ModelIDInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, and: [ModelRelatedOneFilterInput?]? = nil, or: [ModelRelatedOneFilterInput?]? = nil, not: ModelRelatedOneFilterInput? = nil) {
    graphQLMap = ["id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: ModelIDInput? {
    get {
      return graphQLMap["primaryId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelRelatedOneFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelRelatedOneFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelRelatedOneFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelRelatedOneFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelRelatedOneFilterInput? {
    get {
      return graphQLMap["not"] as! ModelRelatedOneFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelSubscriptionPrimaryFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionPrimaryFilterInput?]? = nil, or: [ModelSubscriptionPrimaryFilterInput?]? = nil) {
    graphQLMap = ["id": id, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelSubscriptionPrimaryFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionPrimaryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionPrimaryFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionPrimaryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [GraphQLID?]? {
    get {
      return graphQLMap["in"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [GraphQLID?]? {
    get {
      return graphQLMap["notIn"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [String?]? {
    get {
      return graphQLMap["in"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [String?]? {
    get {
      return graphQLMap["notIn"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionRelatedManyFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, primaryId: ModelSubscriptionIDInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionRelatedManyFilterInput?]? = nil, or: [ModelSubscriptionRelatedManyFilterInput?]? = nil) {
    graphQLMap = ["id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["primaryId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelSubscriptionRelatedManyFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionRelatedManyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionRelatedManyFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionRelatedManyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionRelatedOneFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, primaryId: ModelSubscriptionIDInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionRelatedOneFilterInput?]? = nil, or: [ModelSubscriptionRelatedOneFilterInput?]? = nil) {
    graphQLMap = ["id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var primaryId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["primaryId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryId")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var updatedAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["updatedAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "updatedAt")
    }
  }

  public var and: [ModelSubscriptionRelatedOneFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionRelatedOneFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionRelatedOneFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionRelatedOneFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public final class CreatePrimaryMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreatePrimary($input: CreatePrimaryInput!, $condition: ModelPrimaryConditionInput) {\n  createPrimary(input: $input, condition: $condition) {\n    __typename\n    id\n    relatedMany {\n      __typename\n      nextToken\n    }\n    relatedOne {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreatePrimaryInput
  public var condition: ModelPrimaryConditionInput?

  public init(input: CreatePrimaryInput, condition: ModelPrimaryConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createPrimary", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreatePrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createPrimary: CreatePrimary? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createPrimary": createPrimary.flatMap { $0.snapshot }])
    }

    public var createPrimary: CreatePrimary? {
      get {
        return (snapshot["createPrimary"] as? Snapshot).flatMap { CreatePrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createPrimary")
      }
    }

    public struct CreatePrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["Primary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("relatedMany", type: .object(RelatedMany.selections)),
        GraphQLField("relatedOne", type: .object(RelatedOne.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, relatedMany: RelatedMany? = nil, relatedOne: RelatedOne? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "id": id, "relatedMany": relatedMany.flatMap { $0.snapshot }, "relatedOne": relatedOne.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var relatedMany: RelatedMany? {
        get {
          return (snapshot["relatedMany"] as? Snapshot).flatMap { RelatedMany(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedMany")
        }
      }

      public var relatedOne: RelatedOne? {
        get {
          return (snapshot["relatedOne"] as? Snapshot).flatMap { RelatedOne(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedOne")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct RelatedMany: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedManyConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct RelatedOne: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class UpdatePrimaryMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdatePrimary($input: UpdatePrimaryInput!, $condition: ModelPrimaryConditionInput) {\n  updatePrimary(input: $input, condition: $condition) {\n    __typename\n    id\n    relatedMany {\n      __typename\n      nextToken\n    }\n    relatedOne {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdatePrimaryInput
  public var condition: ModelPrimaryConditionInput?

  public init(input: UpdatePrimaryInput, condition: ModelPrimaryConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updatePrimary", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdatePrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updatePrimary: UpdatePrimary? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updatePrimary": updatePrimary.flatMap { $0.snapshot }])
    }

    public var updatePrimary: UpdatePrimary? {
      get {
        return (snapshot["updatePrimary"] as? Snapshot).flatMap { UpdatePrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updatePrimary")
      }
    }

    public struct UpdatePrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["Primary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("relatedMany", type: .object(RelatedMany.selections)),
        GraphQLField("relatedOne", type: .object(RelatedOne.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, relatedMany: RelatedMany? = nil, relatedOne: RelatedOne? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "id": id, "relatedMany": relatedMany.flatMap { $0.snapshot }, "relatedOne": relatedOne.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var relatedMany: RelatedMany? {
        get {
          return (snapshot["relatedMany"] as? Snapshot).flatMap { RelatedMany(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedMany")
        }
      }

      public var relatedOne: RelatedOne? {
        get {
          return (snapshot["relatedOne"] as? Snapshot).flatMap { RelatedOne(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedOne")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct RelatedMany: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedManyConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct RelatedOne: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class DeletePrimaryMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeletePrimary($input: DeletePrimaryInput!, $condition: ModelPrimaryConditionInput) {\n  deletePrimary(input: $input, condition: $condition) {\n    __typename\n    id\n    relatedMany {\n      __typename\n      nextToken\n    }\n    relatedOne {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeletePrimaryInput
  public var condition: ModelPrimaryConditionInput?

  public init(input: DeletePrimaryInput, condition: ModelPrimaryConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deletePrimary", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeletePrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deletePrimary: DeletePrimary? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deletePrimary": deletePrimary.flatMap { $0.snapshot }])
    }

    public var deletePrimary: DeletePrimary? {
      get {
        return (snapshot["deletePrimary"] as? Snapshot).flatMap { DeletePrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deletePrimary")
      }
    }

    public struct DeletePrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["Primary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("relatedMany", type: .object(RelatedMany.selections)),
        GraphQLField("relatedOne", type: .object(RelatedOne.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, relatedMany: RelatedMany? = nil, relatedOne: RelatedOne? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "id": id, "relatedMany": relatedMany.flatMap { $0.snapshot }, "relatedOne": relatedOne.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var relatedMany: RelatedMany? {
        get {
          return (snapshot["relatedMany"] as? Snapshot).flatMap { RelatedMany(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedMany")
        }
      }

      public var relatedOne: RelatedOne? {
        get {
          return (snapshot["relatedOne"] as? Snapshot).flatMap { RelatedOne(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedOne")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct RelatedMany: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedManyConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct RelatedOne: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class CreateRelatedManyMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateRelatedMany($input: CreateRelatedManyInput!, $condition: ModelRelatedManyConditionInput) {\n  createRelatedMany(input: $input, condition: $condition) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateRelatedManyInput
  public var condition: ModelRelatedManyConditionInput?

  public init(input: CreateRelatedManyInput, condition: ModelRelatedManyConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createRelatedMany", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createRelatedMany: CreateRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createRelatedMany": createRelatedMany.flatMap { $0.snapshot }])
    }

    public var createRelatedMany: CreateRelatedMany? {
      get {
        return (snapshot["createRelatedMany"] as? Snapshot).flatMap { CreateRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createRelatedMany")
      }
    }

    public struct CreateRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedMany"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class UpdateRelatedManyMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateRelatedMany($input: UpdateRelatedManyInput!, $condition: ModelRelatedManyConditionInput) {\n  updateRelatedMany(input: $input, condition: $condition) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateRelatedManyInput
  public var condition: ModelRelatedManyConditionInput?

  public init(input: UpdateRelatedManyInput, condition: ModelRelatedManyConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateRelatedMany", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateRelatedMany: UpdateRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateRelatedMany": updateRelatedMany.flatMap { $0.snapshot }])
    }

    public var updateRelatedMany: UpdateRelatedMany? {
      get {
        return (snapshot["updateRelatedMany"] as? Snapshot).flatMap { UpdateRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateRelatedMany")
      }
    }

    public struct UpdateRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedMany"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class DeleteRelatedManyMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteRelatedMany($input: DeleteRelatedManyInput!, $condition: ModelRelatedManyConditionInput) {\n  deleteRelatedMany(input: $input, condition: $condition) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteRelatedManyInput
  public var condition: ModelRelatedManyConditionInput?

  public init(input: DeleteRelatedManyInput, condition: ModelRelatedManyConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteRelatedMany", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteRelatedMany: DeleteRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteRelatedMany": deleteRelatedMany.flatMap { $0.snapshot }])
    }

    public var deleteRelatedMany: DeleteRelatedMany? {
      get {
        return (snapshot["deleteRelatedMany"] as? Snapshot).flatMap { DeleteRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteRelatedMany")
      }
    }

    public struct DeleteRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedMany"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class CreateRelatedOneMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateRelatedOne($input: CreateRelatedOneInput!, $condition: ModelRelatedOneConditionInput) {\n  createRelatedOne(input: $input, condition: $condition) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateRelatedOneInput
  public var condition: ModelRelatedOneConditionInput?

  public init(input: CreateRelatedOneInput, condition: ModelRelatedOneConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createRelatedOne", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createRelatedOne: CreateRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createRelatedOne": createRelatedOne.flatMap { $0.snapshot }])
    }

    public var createRelatedOne: CreateRelatedOne? {
      get {
        return (snapshot["createRelatedOne"] as? Snapshot).flatMap { CreateRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createRelatedOne")
      }
    }

    public struct CreateRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedOne"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class UpdateRelatedOneMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateRelatedOne($input: UpdateRelatedOneInput!, $condition: ModelRelatedOneConditionInput) {\n  updateRelatedOne(input: $input, condition: $condition) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateRelatedOneInput
  public var condition: ModelRelatedOneConditionInput?

  public init(input: UpdateRelatedOneInput, condition: ModelRelatedOneConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateRelatedOne", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateRelatedOne: UpdateRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateRelatedOne": updateRelatedOne.flatMap { $0.snapshot }])
    }

    public var updateRelatedOne: UpdateRelatedOne? {
      get {
        return (snapshot["updateRelatedOne"] as? Snapshot).flatMap { UpdateRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateRelatedOne")
      }
    }

    public struct UpdateRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedOne"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class DeleteRelatedOneMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteRelatedOne($input: DeleteRelatedOneInput!, $condition: ModelRelatedOneConditionInput) {\n  deleteRelatedOne(input: $input, condition: $condition) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteRelatedOneInput
  public var condition: ModelRelatedOneConditionInput?

  public init(input: DeleteRelatedOneInput, condition: ModelRelatedOneConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteRelatedOne", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteRelatedOne: DeleteRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteRelatedOne": deleteRelatedOne.flatMap { $0.snapshot }])
    }

    public var deleteRelatedOne: DeleteRelatedOne? {
      get {
        return (snapshot["deleteRelatedOne"] as? Snapshot).flatMap { DeleteRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteRelatedOne")
      }
    }

    public struct DeleteRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedOne"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetPrimaryQuery: GraphQLQuery {
  public static let operationString =
    "query GetPrimary($id: ID!) {\n  getPrimary(id: $id) {\n    __typename\n    id\n    relatedMany {\n      __typename\n      nextToken\n    }\n    relatedOne {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPrimary", arguments: ["id": GraphQLVariable("id")], type: .object(GetPrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getPrimary: GetPrimary? = nil) {
      self.init(snapshot: ["__typename": "Query", "getPrimary": getPrimary.flatMap { $0.snapshot }])
    }

    public var getPrimary: GetPrimary? {
      get {
        return (snapshot["getPrimary"] as? Snapshot).flatMap { GetPrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getPrimary")
      }
    }

    public struct GetPrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["Primary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("relatedMany", type: .object(RelatedMany.selections)),
        GraphQLField("relatedOne", type: .object(RelatedOne.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, relatedMany: RelatedMany? = nil, relatedOne: RelatedOne? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "id": id, "relatedMany": relatedMany.flatMap { $0.snapshot }, "relatedOne": relatedOne.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var relatedMany: RelatedMany? {
        get {
          return (snapshot["relatedMany"] as? Snapshot).flatMap { RelatedMany(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedMany")
        }
      }

      public var relatedOne: RelatedOne? {
        get {
          return (snapshot["relatedOne"] as? Snapshot).flatMap { RelatedOne(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedOne")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct RelatedMany: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedManyConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct RelatedOne: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class ListPrimariesQuery: GraphQLQuery {
  public static let operationString =
    "query ListPrimaries($id: ID, $filter: ModelPrimaryFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listPrimaries(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelPrimaryFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelPrimaryFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listPrimaries", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListPrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listPrimaries: ListPrimary? = nil) {
      self.init(snapshot: ["__typename": "Query", "listPrimaries": listPrimaries.flatMap { $0.snapshot }])
    }

    public var listPrimaries: ListPrimary? {
      get {
        return (snapshot["listPrimaries"] as? Snapshot).flatMap { ListPrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listPrimaries")
      }
    }

    public struct ListPrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelPrimaryConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelPrimaryConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetRelatedManyQuery: GraphQLQuery {
  public static let operationString =
    "query GetRelatedMany($id: ID!) {\n  getRelatedMany(id: $id) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getRelatedMany", arguments: ["id": GraphQLVariable("id")], type: .object(GetRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getRelatedMany: GetRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Query", "getRelatedMany": getRelatedMany.flatMap { $0.snapshot }])
    }

    public var getRelatedMany: GetRelatedMany? {
      get {
        return (snapshot["getRelatedMany"] as? Snapshot).flatMap { GetRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getRelatedMany")
      }
    }

    public struct GetRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedMany"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class ListRelatedManiesQuery: GraphQLQuery {
  public static let operationString =
    "query ListRelatedManies($id: ID, $filter: ModelRelatedManyFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listRelatedManies(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelRelatedManyFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelRelatedManyFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listRelatedManies", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listRelatedManies: ListRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Query", "listRelatedManies": listRelatedManies.flatMap { $0.snapshot }])
    }

    public var listRelatedManies: ListRelatedMany? {
      get {
        return (snapshot["listRelatedManies"] as? Snapshot).flatMap { ListRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listRelatedManies")
      }
    }

    public struct ListRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelRelatedManyConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedMany"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetRelatedOneQuery: GraphQLQuery {
  public static let operationString =
    "query GetRelatedOne($id: ID!) {\n  getRelatedOne(id: $id) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getRelatedOne", arguments: ["id": GraphQLVariable("id")], type: .object(GetRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getRelatedOne: GetRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Query", "getRelatedOne": getRelatedOne.flatMap { $0.snapshot }])
    }

    public var getRelatedOne: GetRelatedOne? {
      get {
        return (snapshot["getRelatedOne"] as? Snapshot).flatMap { GetRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getRelatedOne")
      }
    }

    public struct GetRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedOne"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class ListRelatedOnesQuery: GraphQLQuery {
  public static let operationString =
    "query ListRelatedOnes($id: ID, $filter: ModelRelatedOneFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listRelatedOnes(\n    id: $id\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var id: GraphQLID?
  public var filter: ModelRelatedOneFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(id: GraphQLID? = nil, filter: ModelRelatedOneFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.id = id
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["id": id, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listRelatedOnes", arguments: ["id": GraphQLVariable("id"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listRelatedOnes: ListRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Query", "listRelatedOnes": listRelatedOnes.flatMap { $0.snapshot }])
    }

    public var listRelatedOnes: ListRelatedOne? {
      get {
        return (snapshot["listRelatedOnes"] as? Snapshot).flatMap { ListRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listRelatedOnes")
      }
    }

    public struct ListRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelRelatedOneConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelRelatedOneConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnCreatePrimarySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreatePrimary($filter: ModelSubscriptionPrimaryFilterInput) {\n  onCreatePrimary(filter: $filter) {\n    __typename\n    id\n    relatedMany {\n      __typename\n      nextToken\n    }\n    relatedOne {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionPrimaryFilterInput?

  public init(filter: ModelSubscriptionPrimaryFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreatePrimary", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreatePrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreatePrimary: OnCreatePrimary? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreatePrimary": onCreatePrimary.flatMap { $0.snapshot }])
    }

    public var onCreatePrimary: OnCreatePrimary? {
      get {
        return (snapshot["onCreatePrimary"] as? Snapshot).flatMap { OnCreatePrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreatePrimary")
      }
    }

    public struct OnCreatePrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["Primary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("relatedMany", type: .object(RelatedMany.selections)),
        GraphQLField("relatedOne", type: .object(RelatedOne.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, relatedMany: RelatedMany? = nil, relatedOne: RelatedOne? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "id": id, "relatedMany": relatedMany.flatMap { $0.snapshot }, "relatedOne": relatedOne.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var relatedMany: RelatedMany? {
        get {
          return (snapshot["relatedMany"] as? Snapshot).flatMap { RelatedMany(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedMany")
        }
      }

      public var relatedOne: RelatedOne? {
        get {
          return (snapshot["relatedOne"] as? Snapshot).flatMap { RelatedOne(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedOne")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct RelatedMany: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedManyConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct RelatedOne: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnUpdatePrimarySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdatePrimary($filter: ModelSubscriptionPrimaryFilterInput) {\n  onUpdatePrimary(filter: $filter) {\n    __typename\n    id\n    relatedMany {\n      __typename\n      nextToken\n    }\n    relatedOne {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionPrimaryFilterInput?

  public init(filter: ModelSubscriptionPrimaryFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdatePrimary", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdatePrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdatePrimary: OnUpdatePrimary? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdatePrimary": onUpdatePrimary.flatMap { $0.snapshot }])
    }

    public var onUpdatePrimary: OnUpdatePrimary? {
      get {
        return (snapshot["onUpdatePrimary"] as? Snapshot).flatMap { OnUpdatePrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdatePrimary")
      }
    }

    public struct OnUpdatePrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["Primary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("relatedMany", type: .object(RelatedMany.selections)),
        GraphQLField("relatedOne", type: .object(RelatedOne.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, relatedMany: RelatedMany? = nil, relatedOne: RelatedOne? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "id": id, "relatedMany": relatedMany.flatMap { $0.snapshot }, "relatedOne": relatedOne.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var relatedMany: RelatedMany? {
        get {
          return (snapshot["relatedMany"] as? Snapshot).flatMap { RelatedMany(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedMany")
        }
      }

      public var relatedOne: RelatedOne? {
        get {
          return (snapshot["relatedOne"] as? Snapshot).flatMap { RelatedOne(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedOne")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct RelatedMany: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedManyConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct RelatedOne: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnDeletePrimarySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeletePrimary($filter: ModelSubscriptionPrimaryFilterInput) {\n  onDeletePrimary(filter: $filter) {\n    __typename\n    id\n    relatedMany {\n      __typename\n      nextToken\n    }\n    relatedOne {\n      __typename\n      id\n      primaryId\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionPrimaryFilterInput?

  public init(filter: ModelSubscriptionPrimaryFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeletePrimary", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeletePrimary.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeletePrimary: OnDeletePrimary? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeletePrimary": onDeletePrimary.flatMap { $0.snapshot }])
    }

    public var onDeletePrimary: OnDeletePrimary? {
      get {
        return (snapshot["onDeletePrimary"] as? Snapshot).flatMap { OnDeletePrimary(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeletePrimary")
      }
    }

    public struct OnDeletePrimary: GraphQLSelectionSet {
      public static let possibleTypes = ["Primary"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("relatedMany", type: .object(RelatedMany.selections)),
        GraphQLField("relatedOne", type: .object(RelatedOne.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, relatedMany: RelatedMany? = nil, relatedOne: RelatedOne? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "id": id, "relatedMany": relatedMany.flatMap { $0.snapshot }, "relatedOne": relatedOne.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var relatedMany: RelatedMany? {
        get {
          return (snapshot["relatedMany"] as? Snapshot).flatMap { RelatedMany(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedMany")
        }
      }

      public var relatedOne: RelatedOne? {
        get {
          return (snapshot["relatedOne"] as? Snapshot).flatMap { RelatedOne(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "relatedOne")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct RelatedMany: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedManyConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedManyConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct RelatedOne: GraphQLSelectionSet {
        public static let possibleTypes = ["RelatedOne"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, primaryId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var primaryId: GraphQLID {
          get {
            return snapshot["primaryId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryId")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateRelatedManySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateRelatedMany($filter: ModelSubscriptionRelatedManyFilterInput) {\n  onCreateRelatedMany(filter: $filter) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedManyFilterInput?

  public init(filter: ModelSubscriptionRelatedManyFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateRelatedMany", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateRelatedMany: OnCreateRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateRelatedMany": onCreateRelatedMany.flatMap { $0.snapshot }])
    }

    public var onCreateRelatedMany: OnCreateRelatedMany? {
      get {
        return (snapshot["onCreateRelatedMany"] as? Snapshot).flatMap { OnCreateRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateRelatedMany")
      }
    }

    public struct OnCreateRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedMany"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnUpdateRelatedManySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateRelatedMany($filter: ModelSubscriptionRelatedManyFilterInput) {\n  onUpdateRelatedMany(filter: $filter) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedManyFilterInput?

  public init(filter: ModelSubscriptionRelatedManyFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateRelatedMany", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateRelatedMany: OnUpdateRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateRelatedMany": onUpdateRelatedMany.flatMap { $0.snapshot }])
    }

    public var onUpdateRelatedMany: OnUpdateRelatedMany? {
      get {
        return (snapshot["onUpdateRelatedMany"] as? Snapshot).flatMap { OnUpdateRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateRelatedMany")
      }
    }

    public struct OnUpdateRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedMany"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnDeleteRelatedManySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteRelatedMany($filter: ModelSubscriptionRelatedManyFilterInput) {\n  onDeleteRelatedMany(filter: $filter) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedManyFilterInput?

  public init(filter: ModelSubscriptionRelatedManyFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteRelatedMany", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteRelatedMany.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteRelatedMany: OnDeleteRelatedMany? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteRelatedMany": onDeleteRelatedMany.flatMap { $0.snapshot }])
    }

    public var onDeleteRelatedMany: OnDeleteRelatedMany? {
      get {
        return (snapshot["onDeleteRelatedMany"] as? Snapshot).flatMap { OnDeleteRelatedMany(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteRelatedMany")
      }
    }

    public struct OnDeleteRelatedMany: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedMany"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedMany", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnCreateRelatedOneSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateRelatedOne($filter: ModelSubscriptionRelatedOneFilterInput) {\n  onCreateRelatedOne(filter: $filter) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedOneFilterInput?

  public init(filter: ModelSubscriptionRelatedOneFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateRelatedOne", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateRelatedOne: OnCreateRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateRelatedOne": onCreateRelatedOne.flatMap { $0.snapshot }])
    }

    public var onCreateRelatedOne: OnCreateRelatedOne? {
      get {
        return (snapshot["onCreateRelatedOne"] as? Snapshot).flatMap { OnCreateRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateRelatedOne")
      }
    }

    public struct OnCreateRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedOne"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnUpdateRelatedOneSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateRelatedOne($filter: ModelSubscriptionRelatedOneFilterInput) {\n  onUpdateRelatedOne(filter: $filter) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedOneFilterInput?

  public init(filter: ModelSubscriptionRelatedOneFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateRelatedOne", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateRelatedOne: OnUpdateRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateRelatedOne": onUpdateRelatedOne.flatMap { $0.snapshot }])
    }

    public var onUpdateRelatedOne: OnUpdateRelatedOne? {
      get {
        return (snapshot["onUpdateRelatedOne"] as? Snapshot).flatMap { OnUpdateRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateRelatedOne")
      }
    }

    public struct OnUpdateRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedOne"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class OnDeleteRelatedOneSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteRelatedOne($filter: ModelSubscriptionRelatedOneFilterInput) {\n  onDeleteRelatedOne(filter: $filter) {\n    __typename\n    id\n    primaryId\n    primary {\n      __typename\n      id\n      createdAt\n      updatedAt\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedOneFilterInput?

  public init(filter: ModelSubscriptionRelatedOneFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteRelatedOne", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteRelatedOne.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteRelatedOne: OnDeleteRelatedOne? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteRelatedOne": onDeleteRelatedOne.flatMap { $0.snapshot }])
    }

    public var onDeleteRelatedOne: OnDeleteRelatedOne? {
      get {
        return (snapshot["onDeleteRelatedOne"] as? Snapshot).flatMap { OnDeleteRelatedOne(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteRelatedOne")
      }
    }

    public struct OnDeleteRelatedOne: GraphQLSelectionSet {
      public static let possibleTypes = ["RelatedOne"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, primaryId: GraphQLID, primary: Primary? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "RelatedOne", "id": id, "primaryId": primaryId, "primary": primary.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var primaryId: GraphQLID {
        get {
          return snapshot["primaryId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryId")
        }
      }

      public var primary: Primary? {
        get {
          return (snapshot["primary"] as? Snapshot).flatMap { Primary(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "primary")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}