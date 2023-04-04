//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by Миляев Максим on 24.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
//        let vc = QuestionViewController(question: "Question",
//                                        options: ["Answer1", "Answer2", "Answer3"])
//        { print($0) }
//        _ = vc.view
//        vc.tableView.allowsMultipleSelection = true
   
        let vc = ResultViewController(summary: "Your results is : 1/2", answers: [
        PresentableAnswer(question: "First QuestionFirst QuestionFirst QuestionFirst QuestionFirst QuestionFirst QuestionFirst QuestionFirst QuestionFirst QuestionFirst QuestionFirst Question", answer: "Right AnswerRight AnswerRight AnswerRight AnswerRight AnswerRight AnswerRight AnswerRight AnswerRight Answer", wrongAnswer: nil),
        PresentableAnswer(question: "FSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond Question", answer: "RiFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond Questionght Answer", wrongAnswer: "WrongFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond QuestionFSecond Question Answer"),
        PresentableAnswer(question: "Third Question", answer: "Right Answer", wrongAnswer: "NOOO!"),
        PresentableAnswer(question: "Fourth Question", answer: "YES!!!!", wrongAnswer: nil)
        ])
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
    }
}

