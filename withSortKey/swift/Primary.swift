// swiftlint:disable all
import Amplify
import Foundation

public struct Primary: Model {
  public let tenantId: String
  public let instanceId: String
  public let recordId: String
  public var content: String?
  public var related: List<Related>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(tenantId: String,
      instanceId: String,
      recordId: String,
      content: String? = nil,
      related: List<Related> = []) {
    self.init(tenantId: tenantId,
      instanceId: instanceId,
      recordId: recordId,
      content: content,
      related: related,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(tenantId: String,
      instanceId: String,
      recordId: String,
      content: String? = nil,
      related: List<Related> = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.tenantId = tenantId
      self.instanceId = instanceId
      self.recordId = recordId
      self.content = content
      self.related = related
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}