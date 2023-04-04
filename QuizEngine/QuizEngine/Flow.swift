import Foundation

protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer

    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: [Question: Answer])
    
}

class Flow<Qustion: Hashable, Answer, R: Router> where R.Question == Qustion, R.Answer == Answer {
    private let router: R
    private let questions: [Qustion]
    private var results: [Qustion:Answer] = [:]
    
    init( questions: [Qustion],router: R) {
        self.questions = questions
        self.router = router
    }
    
    func start(){
        if let firstQuestion = questions.first{
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(from:firstQuestion))
        } else {
            router.routeTo(result: results)
        }
    }
    
    private func nextCallback(from question: Qustion) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Qustion,_ answer: Answer){
        results[question] = answer
        if let currentIndex = questions.firstIndex(of: question){
            if currentIndex + 1 < questions.count{
                let nextQuestion = questions[currentIndex + 1]
                router.routeTo(question: nextQuestion, answerCallback: nextCallback(from:nextQuestion))
            } else {
                router.routeTo(result: results)
            }
        }
    }
    
}
