// swiftlint:disable all
import Amplify
import Foundation

extension ModelRelatedConnection {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case items
    case nextToken
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let modelRelatedConnection = ModelRelatedConnection.keys
    
    model.listPluralName = "ModelRelatedConnections"
    model.syncPluralName = "ModelRelatedConnections"
    
    model.fields(
      .field(modelRelatedConnection.items, is: .required, ofType: .embeddedCollection(of: Related.self)),
      .field(modelRelatedConnection.nextToken, is: .optional, ofType: .string)
    )
    }
}