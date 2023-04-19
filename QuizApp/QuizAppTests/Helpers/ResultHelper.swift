import QuizEngine

extension Result: Hashable{
    
    public static func == (lhs: QuizEngine.Result<Question, Answer>, rhs: QuizEngine.Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
    
    public func hash(into hasher: inout Hasher) {
//        hasher.combine(answers)
        hasher.combine(score)
    }
    
}
