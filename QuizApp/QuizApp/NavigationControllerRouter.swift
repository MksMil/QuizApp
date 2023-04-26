import UIKit
import QuizEngine


class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController,
         factory: ViewControllerFactory){
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func routeTo(question: Question<String>,
                 answerCallback: @escaping ([String]) -> Void){
        switch question {
        case .singleSelection:
            show(factory.questionViewController(question: question,
                                                answerCallback: answerCallback))
        case .multipleSelection:
            let button = UIBarButtonItem(title: "Submit",
                                         style: .done,
                                         target: nil,
                                         action: nil)
            let buttonController = SubmitButtonController(button: button,
                                                          callback: answerCallback)
            let controller = factory.questionViewController(question: question,
                                                            answerCallback: { selection in
                buttonController.update(selection)
            })
            controller.navigationItem.rightBarButtonItem = button
            show(controller)
        }
    }
    func routeTo(result: Result<Question<String>, [String]>){
        let resultViewController = factory.resultViewController(for: result)
        show(resultViewController)
    }
    
    func show(_ viewController: UIViewController){
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
