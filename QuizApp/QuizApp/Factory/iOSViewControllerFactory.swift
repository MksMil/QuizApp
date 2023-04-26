import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory{
    
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    private let correctAnswers: [Question<String>: [String]]
    
    init(questions: [Question<String>],options: [Question<String> : [String]], correctAnswers:[Question<String> : [String]]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
//--- QuestionViewControllerCreation
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
    
        private func makeQuestionViewController(question: Question<String>,
                                            options: [String],
                                            answerCallback: @escaping (([String]) -> Void)) -> QuestionViewController{
        switch question {
        case .singleSelection(let value):
            return QuestionViewController(question: value,
                                          options: options,
                                          allowMultipleSelection: false,
                                          selection: answerCallback)
            
        case .multipleSelection(let value):
            return QuestionViewController(question: value,
                                                    options: options,
                                                    allowMultipleSelection: true,
                                                    selection: answerCallback)
        }
    }
//--- ResultViewControllerCreation
    func resultViewController(for result: QuizEngine.Result<Question<String>, [String]>) -> UIViewController {
        let presenter = ResultPresenter(result: result,
                                        questions: questions,
                                        correctAnswers: correctAnswers)
        return ResultViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
    }
}
