import UIKit
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase{
    
    let options = ["A1","A2"]
    
    func test_questionViewController_createsControllerWithQuestion(){
        XCTAssertEqual(makeQuestionController(question: Question.singleSelection("Q1")).question, "Q1")
    }
    
    func test_questionViewController_createsControllerWithOptions(){
        let controller = makeQuestionController()
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewcontroller_singleAnswer_createsControllerWithSungleSelection(){
        let controller = makeQuestionController()
        _ = controller.view
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion(){
        XCTAssertEqual(makeQuestionController(question: Question.multipleSelection("Q1")).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions(){
        let controller = makeQuestionController(question: Question.multipleSelection("Q1"))
        
        XCTAssertEqual(controller.options, options)
    }
    
    func test_questionViewcontroller_multipleAnswer_createsControllerWithSungleSelection(){
        let controller = makeQuestionController(question: Question.multipleSelection("Q1"))
        _ = controller.view
        
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK: - Helper
    
    func makeSUT(options: [Question<String>: [String]]) -> iOSViewControllerFactory{
        return iOSViewControllerFactory(options: options)
    }
    func makeQuestionController(question: Question<String> = Question.singleSelection("")) -> QuestionViewController{
        return makeSUT(options: [question: options]).questionViewController(question:question ,answerCallback: {_ in }) as! QuestionViewController
    }
}
