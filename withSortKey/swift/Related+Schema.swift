// swiftlint:disable all
import Amplify
import Foundation

extension Related {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case primary
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let related = Related.keys
    
    model.listPluralName = "Relateds"
    model.syncPluralName = "Relateds"
    
    model.attributes(
      .primaryKey(fields: [related.id])
    )
    
    model.fields(
      .field(related.id, is: .required, ofType: .string),
      .field(related.content, is: .optional, ofType: .string),
      .belongsTo(related.primary, is: .optional, ofType: Primary.self, targetNames: ["primaryTenantId", "primaryInstanceId", "primaryRecordId"]),
      .field(related.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(related.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Related: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}