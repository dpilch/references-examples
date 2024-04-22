// swiftlint:disable all
import Amplify
import Foundation

extension Primary {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case relatedMany
    case relatedOne
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
      .index(fields: ["id"], name: nil),
      .primaryKey(fields: [primary.id])
    )
    
    model.fields(
      .field(primary.id, is: .required, ofType: .string),
      .hasMany(primary.relatedMany, is: .optional, ofType: RelatedMany.self, associatedFields: [RelatedMany.keys.primaryId],
      .hasOne(primary.relatedOne, is: .optional, ofType: RelatedOne.self, associatedFields: [RelatedOne.keys.primaryId]),
      .field(primary.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(primary.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Primary: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}