// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "d9fef6b1e566fdad1b67541a37a61d14"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Primary.self)
    ModelRegistry.register(modelType: RelatedMany.self)
    ModelRegistry.register(modelType: RelatedOne.self)
  }
}