//
//  Flow.swift
//  QuizEngine
//
//  Created by Миляев Максим on 23.03.2023.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallback: @escaping AnswerCallback)
    func routeTo(result: [String: String])
    
}

class Flow {
    private let router: Router
    private let questions: [String]
    private var results: [String:String] = [:]
    
    init( questions: [String],router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start(){
        if let firstQuestion = questions.first{
            router.routeTo(question: firstQuestion, answerCallback: routeToNext(from:firstQuestion))
        } else {
            router.routeTo(result: results)
        }
    }
    
    private func routeToNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] answer in
            guard let strongSelf = self else { return }
            strongSelf.results[question] = answer
            if let currentIndex = strongSelf.questions.firstIndex(of: question){
                if currentIndex + 1 < strongSelf.questions.count{
                    let nextQuestion = strongSelf.questions[currentIndex + 1]
                    strongSelf.router.routeTo(question: nextQuestion, answerCallback: strongSelf.routeToNext(from:nextQuestion))
                } else {
                    strongSelf.router.routeTo(result: strongSelf.results)
                }
            }
        }
    }
    
}
