// swiftlint:disable all
import Amplify
import Foundation

public struct Related: Model {
  public let id: String
  public var content: String?
  public var primary: Primary?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      content: String? = nil,
      primary: Primary? = nil) {
    self.init(id: id,
      content: content,
      primary: primary,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      content: String? = nil,
      primary: Primary? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.content = content
      self.primary = primary
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}