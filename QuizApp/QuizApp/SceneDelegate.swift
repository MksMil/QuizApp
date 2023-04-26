import UIKit
import QuizEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var game: Game<Question<String>,[String],NavigationControllerRouter>?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let question1 = Question.singleSelection("Сколько стоит мясо?")
        let question2 = Question.multipleSelection("Где живут рыбы?")
        let question3 = Question.singleSelection("Как называется наша родная планета?")
        let question4 = Question.multipleSelection("Что нужно есть на завтрак?")
        
        let questions = [question1,question2,question3,question4]
        
        let options = [question1: ["100", "200", "300"],
                       question2: ["Океан", "Аквариум", "Горы","Лес"],
                       question3: ["Нептун", "Марс", "Сатурн","Земля","Юпитер"],
                       question4: ["Гвозди", "Яичницу", "Тосты","Салат","Пюрешку с котлеткой"]
        ]
        let correctAnswers = [question1: ["200"],
                              question2: ["Океан", "Аквариум"],
                              question3: ["Земля"],
                              question4: ["Яичницу", "Тосты","Салат"]]
        
        let navController = UINavigationController()
        let factory = iOSViewControllerFactory(questions: questions,
                                               options: options,
                                               correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(navController,
                                                factory: factory)
        window = UIWindow(windowScene: scene)
        
        window?.rootViewController = navController
        
        window?.makeKeyAndVisible()
        
        game = startGame(questions: questions,
                             router: router,
                             correctAnswers: correctAnswers)
    }
}

