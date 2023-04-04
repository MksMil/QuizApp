import Foundation

public struct Result <Question: Hashable, Answer>{
   public let answers: [Question: Answer]
   public var score: Int = 0
}
