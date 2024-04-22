// swiftlint:disable all
import Amplify
import Foundation

public struct ModelRelatedConnection: Embeddable {
  var items: [Related?]
  var nextToken: String?
}