import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String])->Void) -> UIViewController
    
    func resultViewController(for result: Result<Question<String>,[String]>) -> UIViewController
}


