// swiftlint:disable all
import Amplify
import Foundation

public struct RelatedOne: Model {
  public let id: String
  public var primary: Primary?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      primary: Primary? = nil) {
    self.init(id: id,
      primary: primary,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      primary: Primary? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.primary = primary
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}