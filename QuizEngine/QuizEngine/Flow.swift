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
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(from:firstQuestion))
        } else {
            router.routeTo(result: results)
        }
    }
    
    private func nextCallback(from question: String) -> Router.AnswerCallback {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String,_ answer: String){
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
