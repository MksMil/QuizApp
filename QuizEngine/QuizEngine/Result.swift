import Foundation

public struct Result <Question: Hashable, Answer>{
   public let answers: [Question: Answer]
   public let score: Int
    
   public init(answers: [Question: Answer],score: Int){
        //       self.init(answer: [:], score: 0)
        self.answers = answers
        self.score = score
    }
}
