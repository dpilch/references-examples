// swiftlint:disable all
import Amplify
import Foundation

extension ModelPrimaryConnection {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case items
    case nextToken
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let modelPrimaryConnection = ModelPrimaryConnection.keys
    
    model.listPluralName = "ModelPrimaryConnections"
    model.syncPluralName = "ModelPrimaryConnections"
    
    model.fields(
      .field(modelPrimaryConnection.items, is: .required, ofType: .embeddedCollection(of: Primary.self)),
      .field(modelPrimaryConnection.nextToken, is: .optional, ofType: .string)
    )
    }
}