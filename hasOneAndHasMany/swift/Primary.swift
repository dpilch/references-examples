// swiftlint:disable all
import Amplify
import Foundation

public struct Primary: Model {
  public let id: String
  public var relatedMany: List<RelatedMany>?
  public var relatedOne: RelatedOne?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      relatedMany: List<RelatedMany>? = [],
      relatedOne: RelatedOne? = nil) {
    self.init(id: id,
      relatedMany: relatedMany,
      relatedOne: relatedOne,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      relatedMany: List<RelatedMany>? = [],
      relatedOne: RelatedOne? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.relatedMany = relatedMany
      self.relatedOne = relatedOne
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}