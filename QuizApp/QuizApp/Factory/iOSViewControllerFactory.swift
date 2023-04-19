import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory{
    
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    
    init(questions: [Question<String>],options: [Question<String> : [String]]) {
        self.questions = questions
        self.options = options
    }
    
    func questionViewController(question: Question<String>,
                                answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("couldnt find options for question \(question)")}
        let controller = makeQuestionViewController(question: question,
                                          options: options,
                                          answerCallback: answerCallback)
        controller.title = QuestionPresenter(questions: questions, question: question).title
        return controller
    }
    
    func resultViewController(for result: QuizEngine.Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
    // MARK: - Helper
    private func makeQuestionViewController(question: Question<String>,
                                            options: [String],
                                            answerCallback: @escaping (([String]) -> Void)) -> QuestionViewController{
        switch question {
        case .singleSelection(let value):
            return QuestionViewController(question: value,
                                          options: options,
                                          selection: answerCallback)
            
        case .multipleSelection(let value):
            let controller = QuestionViewController(question: value,
                                                    options: options,
                                                    selection: answerCallback)
            _ = controller.view
            controller.tableView.allowsMultipleSelection = true
            return controller
        }
    }
}
