import Foundation

class Flow<Question: Hashable,
           Answer,
           R: Router> where R.Question == Question,
                            R.Answer == Answer {
    private let router: R
    private let questions: [Question]
    private var answers: [Question:Answer] = [:]
    private var scoring: ([Question:Answer]) -> Int
    
    init(questions: [Question],
         router: R,
         scoring: @escaping ([Question:Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start(){
        if let firstQuestion = questions.first{
            router.routeTo(question: firstQuestion,
                           answerCallback: nextCallback(from:firstQuestion))
        } else {
            router.routeTo(result: result())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question,
                           _ answer: Answer){
        answers[question] = answer
        if let currentIndex = questions.firstIndex(of: question){
            if currentIndex + 1 < questions.count{
                let nextQuestion = questions[currentIndex + 1]
                router.routeTo(question: nextQuestion,
                               answerCallback: nextCallback(from:nextQuestion))
            } else {
                router.routeTo(result: result())
            }
        }
    }
    private func result() -> Result<Question,Answer>{
        return Result(answers: answers,
                      score: scoring(answers))
    }
}
