import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory{
    
    var options: [Question<String>: [String]]
    
    init(options: [Question<String> : [String]]) {
        self.options = options
    }
    
    func questionViewController(question: Question<String>,answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleSelection(let value):
            return QuestionViewController(question: value,options: options[question]!, selection: answerCallback)
        default:
            return UIViewController()
        }
    }
    
    func resultViewController(for result: QuizEngine.Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
    
}
