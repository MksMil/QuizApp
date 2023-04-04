import Foundation

struct Result <Question: Hashable, Answer>{
    let answers: [Question: Answer]
    var score: Int = 0
}
