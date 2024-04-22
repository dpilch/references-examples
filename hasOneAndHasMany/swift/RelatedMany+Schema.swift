// swiftlint:disable all
import Amplify
import Foundation

extension RelatedMany {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case primaryId
    case primary
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let relatedMany = RelatedMany.keys
    
    model.listPluralName = "RelatedManies"
    model.syncPluralName = "RelatedManies"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [relatedMany.id])
    )
    
    model.fields(
      .field(relatedMany.id, is: .required, ofType: .string),
      .field(relatedMany.primaryId, is: .required, ofType: .string),
      .belongsTo(relatedMany.primary, is: .optional, ofType: Primary.self, targetNames: ["primaryId"]),
      .field(relatedMany.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(relatedMany.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension RelatedMany: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}