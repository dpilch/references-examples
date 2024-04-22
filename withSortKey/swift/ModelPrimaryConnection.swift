// swiftlint:disable all
import Amplify
import Foundation

public struct ModelPrimaryConnection: Embeddable {
  var items: [Primary?]
  var nextToken: String?
}