// swiftlint:disable all
import Amplify
import Foundation

extension RelatedOne {
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
    let relatedOne = RelatedOne.keys
    
    model.listPluralName = "RelatedOnes"
    model.syncPluralName = "RelatedOnes"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [relatedOne.id])
    )
    
    model.fields(
      .field(relatedOne.id, is: .required, ofType: .string),
      .field(relatedOne.primaryId, is: .required, ofType: .string),
      .belongsTo(relatedOne.primary, is: .optional, ofType: Primary.self, targetNames: ["primaryId"]),
      .field(relatedOne.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(relatedOne.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension RelatedOne: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}