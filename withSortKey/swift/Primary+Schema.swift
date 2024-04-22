// swiftlint:disable all
import Amplify
import Foundation

extension Primary {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case tenantId
    case instanceId
    case recordId
    case content
    case related
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let primary = Primary.keys
    
    model.listPluralName = "Primaries"
    model.syncPluralName = "Primaries"
    
    model.attributes(
      .index(fields: ["tenantId", "instanceId", "recordId"], name: nil),
      .primaryKey(fields: [primary.tenantId, primary.instanceId, primary.recordId])
    )
    
    model.fields(
      .field(primary.tenantId, is: .required, ofType: .string),
      .field(primary.instanceId, is: .required, ofType: .string),
      .field(primary.recordId, is: .required, ofType: .string),
      .field(primary.content, is: .optional, ofType: .string),
      .hasMany(primary.related, is: .optional, ofType: Related.self, associatedFields: [Related.keys.primaryTenantId, Related.keys.primaryInstanceId, Related.keys.primaryRecordId],
      .field(primary.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(primary.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Primary: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

extension Primary.IdentifierProtocol {
  public static func identifier(tenantId: String,
      instanceId: String,
      recordId: String) -> Self {
    .make(fields:[(name: "tenantId", value: tenantId), (name: "instanceId", value: instanceId), (name: "recordId", value: recordId)])
  }
}