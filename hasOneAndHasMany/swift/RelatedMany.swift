// swiftlint:disable all
import Amplify
import Foundation

public struct RelatedMany: Model {
  public let id: String
  public var primaryId: String
  public var primary: Primary?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      primaryId: String,
      primary: Primary? = nil) {
    self.init(id: id,
      primaryId: primaryId,
      primary: primary,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      primaryId: String,
      primary: Primary? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.primaryId = primaryId
      self.primary = primary
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}