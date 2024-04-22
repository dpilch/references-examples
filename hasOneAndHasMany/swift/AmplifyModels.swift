// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "85f93c304c1c4f934286bf0e34750b4d"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Primary.self)
    ModelRegistry.register(modelType: RelatedMany.self)
    ModelRegistry.register(modelType: RelatedOne.self)
  }
}