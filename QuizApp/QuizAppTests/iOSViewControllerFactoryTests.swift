import Foundation
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase{
    
    func test_questionViewController_createsControllerWithQuestion(){
        let question = Question.singleSelection("Q1")
        let options = ["A1","A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(question: Question.singleSelection("Q1"),answerCallback: {_ in }) as! QuestionViewController
        
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_createsControllerWithOptions(){
        let question = Question.singleSelection("Q1")
        let options = ["A1","A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        let controller = sut.questionViewController(question:question ,answerCallback: {_ in }) as! QuestionViewController
        
        XCTAssertEqual(controller.options, options)
    }
}
