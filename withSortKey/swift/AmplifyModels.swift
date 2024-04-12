// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "0332b5c25dd90aec9145e524a7739f94"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Primary.self)
    ModelRegistry.register(modelType: Related.self)
  }
}