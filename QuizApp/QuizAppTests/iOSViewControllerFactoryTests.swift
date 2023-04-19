import UIKit
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase{
    
    let singleAnswerQuestion = Question.singleSelection("Q1")
    let multipleAnswerQuestion = Question.multipleSelection("Q1")
    
    let options = ["A1","A2"]
    
    func test_questionViewController_createsControllerWithTitle(){
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion],
                                          question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_createsControllerWithQuestion(){
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_createsControllerWithOptions(){
        XCTAssertEqual(makeQuestionController().options, options)
    }
    
    func test_questionViewcontroller_singleAnswer_createsControllerWithSungleSelection(){
        let controller = makeQuestionController()
        _ = controller.view
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    func test_questionViewController_twoQuestions_createsControllerWithTitle(){
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion],
                                          question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion(){
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions(){
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewcontroller_multipleAnswer_createsControllerWithSungleSelection(){
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        _ = controller.view
        
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK: - Helper
    
    func makeSUT(options: [Question<String>: [String]]) -> iOSViewControllerFactory{
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion] ,options: options)
    }
    func makeQuestionController(question: Question<String> = Question.singleSelection("")) -> QuestionViewController{
        return makeSUT(options: [question: options]).questionViewController(question:question ,answerCallback: {_ in }) as! QuestionViewController
    }
}
