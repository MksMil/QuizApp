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
        let vc = QuestionViewController(question: "Question",
                                        options: ["Answer1", "Answer2", "Answer3"])
        { print($0) }
        _ = vc.view
        vc.tableView.allowsMultipleSelection = true
        
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
    }
}

