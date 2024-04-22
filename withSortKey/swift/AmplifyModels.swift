// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "865d573dfd2566dfe3fa34636b8f9613"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Primary.self)
    ModelRegistry.register(modelType: Related.self)
  }
}