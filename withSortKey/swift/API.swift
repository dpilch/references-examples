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

  public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil) {
    graphQLMap = ["tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content]
  }

  public var tenantId: GraphQLID {
    get {
      return graphQLMap["tenantId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tenantId")
    }
  }

  public var instanceId: GraphQLID {
    get {
      return graphQLMap["instanceId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instanceId")
    }
  }

  public var recordId: GraphQLID {
    get {
      return graphQLMap["recordId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "recordId")
    }
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }
}

public struct ModelPrimaryConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: ModelStringInput? = nil, and: [ModelPrimaryConditionInput?]? = nil, or: [ModelPrimaryConditionInput?]? = nil, not: ModelPrimaryConditionInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil) {
    graphQLMap = ["content": content, "and": and, "or": or, "not": not, "createdAt": createdAt, "updatedAt": updatedAt]
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
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

  public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil) {
    graphQLMap = ["tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content]
  }

  public var tenantId: GraphQLID {
    get {
      return graphQLMap["tenantId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tenantId")
    }
  }

  public var instanceId: GraphQLID {
    get {
      return graphQLMap["instanceId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instanceId")
    }
  }

  public var recordId: GraphQLID {
    get {
      return graphQLMap["recordId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "recordId")
    }
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }
}

public struct DeletePrimaryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID) {
    graphQLMap = ["tenantId": tenantId, "instanceId": instanceId, "recordId": recordId]
  }

  public var tenantId: GraphQLID {
    get {
      return graphQLMap["tenantId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tenantId")
    }
  }

  public var instanceId: GraphQLID {
    get {
      return graphQLMap["instanceId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instanceId")
    }
  }

  public var recordId: GraphQLID {
    get {
      return graphQLMap["recordId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "recordId")
    }
  }
}

public struct CreateRelatedInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, id: GraphQLID? = nil) {
    graphQLMap = ["content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "id": id]
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var primaryTenantId: GraphQLID {
    get {
      return graphQLMap["primaryTenantId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryTenantId")
    }
  }

  public var primaryInstanceId: GraphQLID {
    get {
      return graphQLMap["primaryInstanceId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryInstanceId")
    }
  }

  public var primaryRecordId: GraphQLID {
    get {
      return graphQLMap["primaryRecordId"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryRecordId")
    }
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

public struct ModelRelatedConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: ModelStringInput? = nil, primaryTenantId: ModelIDInput? = nil, primaryInstanceId: ModelIDInput? = nil, primaryRecordId: ModelIDInput? = nil, and: [ModelRelatedConditionInput?]? = nil, or: [ModelRelatedConditionInput?]? = nil, not: ModelRelatedConditionInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil) {
    graphQLMap = ["content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "and": and, "or": or, "not": not, "createdAt": createdAt, "updatedAt": updatedAt]
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var primaryTenantId: ModelIDInput? {
    get {
      return graphQLMap["primaryTenantId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryTenantId")
    }
  }

  public var primaryInstanceId: ModelIDInput? {
    get {
      return graphQLMap["primaryInstanceId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryInstanceId")
    }
  }

  public var primaryRecordId: ModelIDInput? {
    get {
      return graphQLMap["primaryRecordId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryRecordId")
    }
  }

  public var and: [ModelRelatedConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelRelatedConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelRelatedConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelRelatedConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelRelatedConditionInput? {
    get {
      return graphQLMap["not"] as! ModelRelatedConditionInput?
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

public struct UpdateRelatedInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: String? = nil, primaryTenantId: GraphQLID? = nil, primaryInstanceId: GraphQLID? = nil, primaryRecordId: GraphQLID? = nil, id: GraphQLID) {
    graphQLMap = ["content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "id": id]
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var primaryTenantId: GraphQLID? {
    get {
      return graphQLMap["primaryTenantId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryTenantId")
    }
  }

  public var primaryInstanceId: GraphQLID? {
    get {
      return graphQLMap["primaryInstanceId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryInstanceId")
    }
  }

  public var primaryRecordId: GraphQLID? {
    get {
      return graphQLMap["primaryRecordId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryRecordId")
    }
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

public struct DeleteRelatedInput: GraphQLMapConvertible {
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

public struct ModelPrimaryPrimaryCompositeKeyConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: ModelPrimaryPrimaryCompositeKeyInput? = nil, le: ModelPrimaryPrimaryCompositeKeyInput? = nil, lt: ModelPrimaryPrimaryCompositeKeyInput? = nil, ge: ModelPrimaryPrimaryCompositeKeyInput? = nil, gt: ModelPrimaryPrimaryCompositeKeyInput? = nil, between: [ModelPrimaryPrimaryCompositeKeyInput?]? = nil, beginsWith: ModelPrimaryPrimaryCompositeKeyInput? = nil) {
    graphQLMap = ["eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "beginsWith": beginsWith]
  }

  public var eq: ModelPrimaryPrimaryCompositeKeyInput? {
    get {
      return graphQLMap["eq"] as! ModelPrimaryPrimaryCompositeKeyInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: ModelPrimaryPrimaryCompositeKeyInput? {
    get {
      return graphQLMap["le"] as! ModelPrimaryPrimaryCompositeKeyInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: ModelPrimaryPrimaryCompositeKeyInput? {
    get {
      return graphQLMap["lt"] as! ModelPrimaryPrimaryCompositeKeyInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: ModelPrimaryPrimaryCompositeKeyInput? {
    get {
      return graphQLMap["ge"] as! ModelPrimaryPrimaryCompositeKeyInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: ModelPrimaryPrimaryCompositeKeyInput? {
    get {
      return graphQLMap["gt"] as! ModelPrimaryPrimaryCompositeKeyInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [ModelPrimaryPrimaryCompositeKeyInput?]? {
    get {
      return graphQLMap["between"] as! [ModelPrimaryPrimaryCompositeKeyInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: ModelPrimaryPrimaryCompositeKeyInput? {
    get {
      return graphQLMap["beginsWith"] as! ModelPrimaryPrimaryCompositeKeyInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public struct ModelPrimaryPrimaryCompositeKeyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(instanceId: GraphQLID? = nil, recordId: GraphQLID? = nil) {
    graphQLMap = ["instanceId": instanceId, "recordId": recordId]
  }

  public var instanceId: GraphQLID? {
    get {
      return graphQLMap["instanceId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instanceId")
    }
  }

  public var recordId: GraphQLID? {
    get {
      return graphQLMap["recordId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "recordId")
    }
  }
}

public struct ModelPrimaryFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(tenantId: ModelIDInput? = nil, instanceId: ModelIDInput? = nil, recordId: ModelIDInput? = nil, content: ModelStringInput? = nil, id: ModelIDInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, and: [ModelPrimaryFilterInput?]? = nil, or: [ModelPrimaryFilterInput?]? = nil, not: ModelPrimaryFilterInput? = nil) {
    graphQLMap = ["tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or, "not": not]
  }

  public var tenantId: ModelIDInput? {
    get {
      return graphQLMap["tenantId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tenantId")
    }
  }

  public var instanceId: ModelIDInput? {
    get {
      return graphQLMap["instanceId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instanceId")
    }
  }

  public var recordId: ModelIDInput? {
    get {
      return graphQLMap["recordId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "recordId")
    }
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
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

public struct ModelRelatedFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: ModelStringInput? = nil, primaryTenantId: ModelIDInput? = nil, primaryInstanceId: ModelIDInput? = nil, primaryRecordId: ModelIDInput? = nil, id: ModelIDInput? = nil, createdAt: ModelStringInput? = nil, updatedAt: ModelStringInput? = nil, and: [ModelRelatedFilterInput?]? = nil, or: [ModelRelatedFilterInput?]? = nil, not: ModelRelatedFilterInput? = nil) {
    graphQLMap = ["content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or, "not": not]
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var primaryTenantId: ModelIDInput? {
    get {
      return graphQLMap["primaryTenantId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryTenantId")
    }
  }

  public var primaryInstanceId: ModelIDInput? {
    get {
      return graphQLMap["primaryInstanceId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryInstanceId")
    }
  }

  public var primaryRecordId: ModelIDInput? {
    get {
      return graphQLMap["primaryRecordId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryRecordId")
    }
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

  public var and: [ModelRelatedFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelRelatedFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelRelatedFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelRelatedFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelRelatedFilterInput? {
    get {
      return graphQLMap["not"] as! ModelRelatedFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelSubscriptionPrimaryFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(tenantId: ModelSubscriptionIDInput? = nil, instanceId: ModelSubscriptionIDInput? = nil, recordId: ModelSubscriptionIDInput? = nil, content: ModelSubscriptionStringInput? = nil, id: ModelSubscriptionIDInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionPrimaryFilterInput?]? = nil, or: [ModelSubscriptionPrimaryFilterInput?]? = nil) {
    graphQLMap = ["tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or]
  }

  public var tenantId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["tenantId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tenantId")
    }
  }

  public var instanceId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["instanceId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instanceId")
    }
  }

  public var recordId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["recordId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "recordId")
    }
  }

  public var content: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["content"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
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

public struct ModelSubscriptionRelatedFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: ModelSubscriptionStringInput? = nil, primaryTenantId: ModelSubscriptionIDInput? = nil, primaryInstanceId: ModelSubscriptionIDInput? = nil, primaryRecordId: ModelSubscriptionIDInput? = nil, id: ModelSubscriptionIDInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, updatedAt: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionRelatedFilterInput?]? = nil, or: [ModelSubscriptionRelatedFilterInput?]? = nil) {
    graphQLMap = ["content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "id": id, "createdAt": createdAt, "updatedAt": updatedAt, "and": and, "or": or]
  }

  public var content: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["content"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var primaryTenantId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["primaryTenantId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryTenantId")
    }
  }

  public var primaryInstanceId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["primaryInstanceId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryInstanceId")
    }
  }

  public var primaryRecordId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["primaryRecordId"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "primaryRecordId")
    }
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

  public var and: [ModelSubscriptionRelatedFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionRelatedFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionRelatedFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionRelatedFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public final class CreatePrimaryMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreatePrimary($input: CreatePrimaryInput!, $condition: ModelPrimaryConditionInput) {\n  createPrimary(input: $input, condition: $condition) {\n    __typename\n    tenantId\n    instanceId\n    recordId\n    content\n    related {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

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
        GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("related", type: .object(Related.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, related: Related? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "related": related.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tenantId: GraphQLID {
        get {
          return snapshot["tenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "tenantId")
        }
      }

      public var instanceId: GraphQLID {
        get {
          return snapshot["instanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "instanceId")
        }
      }

      public var recordId: GraphQLID {
        get {
          return snapshot["recordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "recordId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var related: Related? {
        get {
          return (snapshot["related"] as? Snapshot).flatMap { Related(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "related")
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

      public struct Related: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedConnection", "nextToken": nextToken])
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
    }
  }
}

public final class UpdatePrimaryMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdatePrimary($input: UpdatePrimaryInput!, $condition: ModelPrimaryConditionInput) {\n  updatePrimary(input: $input, condition: $condition) {\n    __typename\n    tenantId\n    instanceId\n    recordId\n    content\n    related {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

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
        GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("related", type: .object(Related.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, related: Related? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "related": related.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tenantId: GraphQLID {
        get {
          return snapshot["tenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "tenantId")
        }
      }

      public var instanceId: GraphQLID {
        get {
          return snapshot["instanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "instanceId")
        }
      }

      public var recordId: GraphQLID {
        get {
          return snapshot["recordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "recordId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var related: Related? {
        get {
          return (snapshot["related"] as? Snapshot).flatMap { Related(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "related")
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

      public struct Related: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedConnection", "nextToken": nextToken])
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
    }
  }
}

public final class DeletePrimaryMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeletePrimary($input: DeletePrimaryInput!, $condition: ModelPrimaryConditionInput) {\n  deletePrimary(input: $input, condition: $condition) {\n    __typename\n    tenantId\n    instanceId\n    recordId\n    content\n    related {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

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
        GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("related", type: .object(Related.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, related: Related? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "related": related.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tenantId: GraphQLID {
        get {
          return snapshot["tenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "tenantId")
        }
      }

      public var instanceId: GraphQLID {
        get {
          return snapshot["instanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "instanceId")
        }
      }

      public var recordId: GraphQLID {
        get {
          return snapshot["recordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "recordId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var related: Related? {
        get {
          return (snapshot["related"] as? Snapshot).flatMap { Related(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "related")
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

      public struct Related: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedConnection", "nextToken": nextToken])
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
    }
  }
}

public final class CreateRelatedMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateRelated($input: CreateRelatedInput!, $condition: ModelRelatedConditionInput) {\n  createRelated(input: $input, condition: $condition) {\n    __typename\n    content\n    primaryTenantId\n    primaryInstanceId\n    primaryRecordId\n    primary {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    id\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateRelatedInput
  public var condition: ModelRelatedConditionInput?

  public init(input: CreateRelatedInput, condition: ModelRelatedConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createRelated", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createRelated: CreateRelated? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createRelated": createRelated.flatMap { $0.snapshot }])
    }

    public var createRelated: CreateRelated? {
      get {
        return (snapshot["createRelated"] as? Snapshot).flatMap { CreateRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createRelated")
      }
    }

    public struct CreateRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["Related"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, primary: Primary? = nil, id: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "primary": primary.flatMap { $0.snapshot }, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var primaryTenantId: GraphQLID {
        get {
          return snapshot["primaryTenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryTenantId")
        }
      }

      public var primaryInstanceId: GraphQLID {
        get {
          return snapshot["primaryInstanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryInstanceId")
        }
      }

      public var primaryRecordId: GraphQLID {
        get {
          return snapshot["primaryRecordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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

public final class UpdateRelatedMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateRelated($input: UpdateRelatedInput!, $condition: ModelRelatedConditionInput) {\n  updateRelated(input: $input, condition: $condition) {\n    __typename\n    content\n    primaryTenantId\n    primaryInstanceId\n    primaryRecordId\n    primary {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    id\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateRelatedInput
  public var condition: ModelRelatedConditionInput?

  public init(input: UpdateRelatedInput, condition: ModelRelatedConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateRelated", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateRelated: UpdateRelated? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateRelated": updateRelated.flatMap { $0.snapshot }])
    }

    public var updateRelated: UpdateRelated? {
      get {
        return (snapshot["updateRelated"] as? Snapshot).flatMap { UpdateRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateRelated")
      }
    }

    public struct UpdateRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["Related"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, primary: Primary? = nil, id: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "primary": primary.flatMap { $0.snapshot }, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var primaryTenantId: GraphQLID {
        get {
          return snapshot["primaryTenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryTenantId")
        }
      }

      public var primaryInstanceId: GraphQLID {
        get {
          return snapshot["primaryInstanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryInstanceId")
        }
      }

      public var primaryRecordId: GraphQLID {
        get {
          return snapshot["primaryRecordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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

public final class DeleteRelatedMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteRelated($input: DeleteRelatedInput!, $condition: ModelRelatedConditionInput) {\n  deleteRelated(input: $input, condition: $condition) {\n    __typename\n    content\n    primaryTenantId\n    primaryInstanceId\n    primaryRecordId\n    primary {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    id\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteRelatedInput
  public var condition: ModelRelatedConditionInput?

  public init(input: DeleteRelatedInput, condition: ModelRelatedConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteRelated", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteRelated: DeleteRelated? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteRelated": deleteRelated.flatMap { $0.snapshot }])
    }

    public var deleteRelated: DeleteRelated? {
      get {
        return (snapshot["deleteRelated"] as? Snapshot).flatMap { DeleteRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteRelated")
      }
    }

    public struct DeleteRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["Related"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, primary: Primary? = nil, id: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "primary": primary.flatMap { $0.snapshot }, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var primaryTenantId: GraphQLID {
        get {
          return snapshot["primaryTenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryTenantId")
        }
      }

      public var primaryInstanceId: GraphQLID {
        get {
          return snapshot["primaryInstanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryInstanceId")
        }
      }

      public var primaryRecordId: GraphQLID {
        get {
          return snapshot["primaryRecordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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
    "query GetPrimary($tenantId: ID!, $instanceId: ID!, $recordId: ID!) {\n  getPrimary(tenantId: $tenantId, instanceId: $instanceId, recordId: $recordId) {\n    __typename\n    tenantId\n    instanceId\n    recordId\n    content\n    related {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var tenantId: GraphQLID
  public var instanceId: GraphQLID
  public var recordId: GraphQLID

  public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID) {
    self.tenantId = tenantId
    self.instanceId = instanceId
    self.recordId = recordId
  }

  public var variables: GraphQLMap? {
    return ["tenantId": tenantId, "instanceId": instanceId, "recordId": recordId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getPrimary", arguments: ["tenantId": GraphQLVariable("tenantId"), "instanceId": GraphQLVariable("instanceId"), "recordId": GraphQLVariable("recordId")], type: .object(GetPrimary.selections)),
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
        GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("related", type: .object(Related.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, related: Related? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "related": related.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tenantId: GraphQLID {
        get {
          return snapshot["tenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "tenantId")
        }
      }

      public var instanceId: GraphQLID {
        get {
          return snapshot["instanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "instanceId")
        }
      }

      public var recordId: GraphQLID {
        get {
          return snapshot["recordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "recordId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var related: Related? {
        get {
          return (snapshot["related"] as? Snapshot).flatMap { Related(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "related")
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

      public struct Related: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedConnection", "nextToken": nextToken])
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
    }
  }
}

public final class ListPrimariesQuery: GraphQLQuery {
  public static let operationString =
    "query ListPrimaries($tenantId: ID, $instanceIdRecordId: ModelPrimaryPrimaryCompositeKeyConditionInput, $filter: ModelPrimaryFilterInput, $limit: Int, $nextToken: String, $sortDirection: ModelSortDirection) {\n  listPrimaries(\n    tenantId: $tenantId\n    instanceIdRecordId: $instanceIdRecordId\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n    sortDirection: $sortDirection\n  ) {\n    __typename\n    items {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var tenantId: GraphQLID?
  public var instanceIdRecordId: ModelPrimaryPrimaryCompositeKeyConditionInput?
  public var filter: ModelPrimaryFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var sortDirection: ModelSortDirection?

  public init(tenantId: GraphQLID? = nil, instanceIdRecordId: ModelPrimaryPrimaryCompositeKeyConditionInput? = nil, filter: ModelPrimaryFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, sortDirection: ModelSortDirection? = nil) {
    self.tenantId = tenantId
    self.instanceIdRecordId = instanceIdRecordId
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.sortDirection = sortDirection
  }

  public var variables: GraphQLMap? {
    return ["tenantId": tenantId, "instanceIdRecordId": instanceIdRecordId, "filter": filter, "limit": limit, "nextToken": nextToken, "sortDirection": sortDirection]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listPrimaries", arguments: ["tenantId": GraphQLVariable("tenantId"), "instanceIdRecordId": GraphQLVariable("instanceIdRecordId"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "sortDirection": GraphQLVariable("sortDirection")], type: .object(ListPrimary.selections)),
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
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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

public final class GetRelatedQuery: GraphQLQuery {
  public static let operationString =
    "query GetRelated($id: ID!) {\n  getRelated(id: $id) {\n    __typename\n    content\n    primaryTenantId\n    primaryInstanceId\n    primaryRecordId\n    primary {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    id\n    createdAt\n    updatedAt\n  }\n}"

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
      GraphQLField("getRelated", arguments: ["id": GraphQLVariable("id")], type: .object(GetRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getRelated: GetRelated? = nil) {
      self.init(snapshot: ["__typename": "Query", "getRelated": getRelated.flatMap { $0.snapshot }])
    }

    public var getRelated: GetRelated? {
      get {
        return (snapshot["getRelated"] as? Snapshot).flatMap { GetRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getRelated")
      }
    }

    public struct GetRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["Related"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, primary: Primary? = nil, id: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "primary": primary.flatMap { $0.snapshot }, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var primaryTenantId: GraphQLID {
        get {
          return snapshot["primaryTenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryTenantId")
        }
      }

      public var primaryInstanceId: GraphQLID {
        get {
          return snapshot["primaryInstanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryInstanceId")
        }
      }

      public var primaryRecordId: GraphQLID {
        get {
          return snapshot["primaryRecordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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

public final class ListRelatedsQuery: GraphQLQuery {
  public static let operationString =
    "query ListRelateds($filter: ModelRelatedFilterInput, $limit: Int, $nextToken: String) {\n  listRelateds(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      content\n      primaryTenantId\n      primaryInstanceId\n      primaryRecordId\n      id\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelRelatedFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelRelatedFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listRelateds", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listRelateds: ListRelated? = nil) {
      self.init(snapshot: ["__typename": "Query", "listRelateds": listRelateds.flatMap { $0.snapshot }])
    }

    public var listRelateds: ListRelated? {
      get {
        return (snapshot["listRelateds"] as? Snapshot).flatMap { ListRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listRelateds")
      }
    }

    public struct ListRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelRelatedConnection"]

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
        self.init(snapshot: ["__typename": "ModelRelatedConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
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
        public static let possibleTypes = ["Related"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, id: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        public var primaryTenantId: GraphQLID {
          get {
            return snapshot["primaryTenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryTenantId")
          }
        }

        public var primaryInstanceId: GraphQLID {
          get {
            return snapshot["primaryInstanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryInstanceId")
          }
        }

        public var primaryRecordId: GraphQLID {
          get {
            return snapshot["primaryRecordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

public final class OnCreatePrimarySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreatePrimary($filter: ModelSubscriptionPrimaryFilterInput) {\n  onCreatePrimary(filter: $filter) {\n    __typename\n    tenantId\n    instanceId\n    recordId\n    content\n    related {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

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
        GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("related", type: .object(Related.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, related: Related? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "related": related.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tenantId: GraphQLID {
        get {
          return snapshot["tenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "tenantId")
        }
      }

      public var instanceId: GraphQLID {
        get {
          return snapshot["instanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "instanceId")
        }
      }

      public var recordId: GraphQLID {
        get {
          return snapshot["recordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "recordId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var related: Related? {
        get {
          return (snapshot["related"] as? Snapshot).flatMap { Related(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "related")
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

      public struct Related: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedConnection", "nextToken": nextToken])
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
    }
  }
}

public final class OnUpdatePrimarySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdatePrimary($filter: ModelSubscriptionPrimaryFilterInput) {\n  onUpdatePrimary(filter: $filter) {\n    __typename\n    tenantId\n    instanceId\n    recordId\n    content\n    related {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

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
        GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("related", type: .object(Related.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, related: Related? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "related": related.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tenantId: GraphQLID {
        get {
          return snapshot["tenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "tenantId")
        }
      }

      public var instanceId: GraphQLID {
        get {
          return snapshot["instanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "instanceId")
        }
      }

      public var recordId: GraphQLID {
        get {
          return snapshot["recordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "recordId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var related: Related? {
        get {
          return (snapshot["related"] as? Snapshot).flatMap { Related(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "related")
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

      public struct Related: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedConnection", "nextToken": nextToken])
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
    }
  }
}

public final class OnDeletePrimarySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeletePrimary($filter: ModelSubscriptionPrimaryFilterInput) {\n  onDeletePrimary(filter: $filter) {\n    __typename\n    tenantId\n    instanceId\n    recordId\n    content\n    related {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

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
        GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("related", type: .object(Related.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, related: Related? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "related": related.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tenantId: GraphQLID {
        get {
          return snapshot["tenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "tenantId")
        }
      }

      public var instanceId: GraphQLID {
        get {
          return snapshot["instanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "instanceId")
        }
      }

      public var recordId: GraphQLID {
        get {
          return snapshot["recordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "recordId")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var related: Related? {
        get {
          return (snapshot["related"] as? Snapshot).flatMap { Related(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "related")
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

      public struct Related: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelRelatedConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelRelatedConnection", "nextToken": nextToken])
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
    }
  }
}

public final class OnCreateRelatedSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateRelated($filter: ModelSubscriptionRelatedFilterInput) {\n  onCreateRelated(filter: $filter) {\n    __typename\n    content\n    primaryTenantId\n    primaryInstanceId\n    primaryRecordId\n    primary {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    id\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedFilterInput?

  public init(filter: ModelSubscriptionRelatedFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateRelated", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateRelated: OnCreateRelated? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateRelated": onCreateRelated.flatMap { $0.snapshot }])
    }

    public var onCreateRelated: OnCreateRelated? {
      get {
        return (snapshot["onCreateRelated"] as? Snapshot).flatMap { OnCreateRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateRelated")
      }
    }

    public struct OnCreateRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["Related"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, primary: Primary? = nil, id: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "primary": primary.flatMap { $0.snapshot }, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var primaryTenantId: GraphQLID {
        get {
          return snapshot["primaryTenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryTenantId")
        }
      }

      public var primaryInstanceId: GraphQLID {
        get {
          return snapshot["primaryInstanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryInstanceId")
        }
      }

      public var primaryRecordId: GraphQLID {
        get {
          return snapshot["primaryRecordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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

public final class OnUpdateRelatedSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateRelated($filter: ModelSubscriptionRelatedFilterInput) {\n  onUpdateRelated(filter: $filter) {\n    __typename\n    content\n    primaryTenantId\n    primaryInstanceId\n    primaryRecordId\n    primary {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    id\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedFilterInput?

  public init(filter: ModelSubscriptionRelatedFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateRelated", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateRelated: OnUpdateRelated? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateRelated": onUpdateRelated.flatMap { $0.snapshot }])
    }

    public var onUpdateRelated: OnUpdateRelated? {
      get {
        return (snapshot["onUpdateRelated"] as? Snapshot).flatMap { OnUpdateRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateRelated")
      }
    }

    public struct OnUpdateRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["Related"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, primary: Primary? = nil, id: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "primary": primary.flatMap { $0.snapshot }, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var primaryTenantId: GraphQLID {
        get {
          return snapshot["primaryTenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryTenantId")
        }
      }

      public var primaryInstanceId: GraphQLID {
        get {
          return snapshot["primaryInstanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryInstanceId")
        }
      }

      public var primaryRecordId: GraphQLID {
        get {
          return snapshot["primaryRecordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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

public final class OnDeleteRelatedSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteRelated($filter: ModelSubscriptionRelatedFilterInput) {\n  onDeleteRelated(filter: $filter) {\n    __typename\n    content\n    primaryTenantId\n    primaryInstanceId\n    primaryRecordId\n    primary {\n      __typename\n      tenantId\n      instanceId\n      recordId\n      content\n      createdAt\n      updatedAt\n    }\n    id\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionRelatedFilterInput?

  public init(filter: ModelSubscriptionRelatedFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteRelated", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteRelated.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteRelated: OnDeleteRelated? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteRelated": onDeleteRelated.flatMap { $0.snapshot }])
    }

    public var onDeleteRelated: OnDeleteRelated? {
      get {
        return (snapshot["onDeleteRelated"] as? Snapshot).flatMap { OnDeleteRelated(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteRelated")
      }
    }

    public struct OnDeleteRelated: GraphQLSelectionSet {
      public static let possibleTypes = ["Related"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("content", type: .scalar(String.self)),
        GraphQLField("primaryTenantId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryInstanceId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primaryRecordId", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("primary", type: .object(Primary.selections)),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(content: String? = nil, primaryTenantId: GraphQLID, primaryInstanceId: GraphQLID, primaryRecordId: GraphQLID, primary: Primary? = nil, id: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Related", "content": content, "primaryTenantId": primaryTenantId, "primaryInstanceId": primaryInstanceId, "primaryRecordId": primaryRecordId, "primary": primary.flatMap { $0.snapshot }, "id": id, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var content: String? {
        get {
          return snapshot["content"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var primaryTenantId: GraphQLID {
        get {
          return snapshot["primaryTenantId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryTenantId")
        }
      }

      public var primaryInstanceId: GraphQLID {
        get {
          return snapshot["primaryInstanceId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryInstanceId")
        }
      }

      public var primaryRecordId: GraphQLID {
        get {
          return snapshot["primaryRecordId"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "primaryRecordId")
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

      public struct Primary: GraphQLSelectionSet {
        public static let possibleTypes = ["Primary"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tenantId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("instanceId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("recordId", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(tenantId: GraphQLID, instanceId: GraphQLID, recordId: GraphQLID, content: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Primary", "tenantId": tenantId, "instanceId": instanceId, "recordId": recordId, "content": content, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var tenantId: GraphQLID {
          get {
            return snapshot["tenantId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "tenantId")
          }
        }

        public var instanceId: GraphQLID {
          get {
            return snapshot["instanceId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "instanceId")
          }
        }

        public var recordId: GraphQLID {
          get {
            return snapshot["recordId"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "recordId")
          }
        }

        public var content: String? {
          get {
            return snapshot["content"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
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