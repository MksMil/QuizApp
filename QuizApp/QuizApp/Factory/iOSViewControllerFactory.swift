import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory{
    
    var options: [Question<String>: [String]]
    
    init(options: [Question<String> : [String]]) {
        self.options = options
    }
    
    func questionViewController(question: Question<String>,answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("couldnt find options for question \(question)")}
        return makeQuestionViewController(question: question, options: options, answerCallback: answerCallback)
    }
    
    func resultViewController(for result: QuizEngine.Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
    // MARK: - Helper
    private func makeQuestionViewController(question: Question<String>,options: [String], answerCallback: @escaping (([String]) -> Void)) -> QuestionViewController{
        switch question {
        case .singleSelection(let value):
            return QuestionViewController(question: value, options: options, selection: answerCallback)
            
        case .multipleSelection(let value):
            let controller = QuestionViewController(question: value, options: options, selection: answerCallback)
            _ = controller.view
            controller.tableView.allowsMultipleSelection = true
            return controller
        }
    }
}
