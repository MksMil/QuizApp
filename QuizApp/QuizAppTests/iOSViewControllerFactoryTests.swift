import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase{
    
    let singleAnswerQuestion = Question.singleSelection("Q1")
    let multipleAnswerQuestion = Question.multipleSelection("Q1")
    
    let options = ["A1","A2"]
    
//--- QuestionViewController
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
    
    func test_questionViewcontroller_singleSelection_createsControllerWithSungleSelection(){
        let controller = makeQuestionController(question: singleAnswerQuestion)
        _ = controller.view
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    func test_questionViewcontroller_multipleSelection_createsControllerWithSungleSelection(){
        let controller = makeQuestionController(question: multipleAnswerQuestion)
        _ = controller.view
        
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
//--- ResultViewController
    func test_resuultViewCpontroller_createsController(){
        let results = makeResults()
        XCTAssertNotNil(results.controller)
        XCTAssertEqual(results.controller.summary,
                       results.presenter.summary)
    }
    
    func test_resuultViewCpontroller_createsControllerWithPresentableAnswers(){
        let results = makeResults()
        XCTAssertNotNil(results.controller)
        XCTAssertEqual(results.controller.answers.count,
                       results.presenter.presentableAnswers.count)
    }
    
    // MARK: - Helper
    
    func makeSUT(options: [Question<String>: [String]], correctAnswers:[Question<String>: [String]] = [:] ) -> iOSViewControllerFactory{
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion] ,
                                        options: options,
                                        correctAnswers: correctAnswers)
    }
    func makeQuestionController(question: Question<String> = Question.singleSelection("")) -> QuestionViewController{
        return makeSUT(options: [question: options])
            .questionViewController(question:question,
                                    answerCallback: {_ in })
        as! QuestionViewController
    }
    
    func makeResults() -> (controller: ResultViewController, presenter: ResultPresenter){
        let userAnswers = [singleAnswerQuestion: ["A1"],
                         multipleAnswerQuestion: ["A1", "A2"]]
        let results = Result(answers: userAnswers,
                             score: 2)
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let correctAnswers = [singleAnswerQuestion: ["A1"],
                            multipleAnswerQuestion: ["A1", "A2"]]
        let sut = makeSUT(options: [:],
                          correctAnswers: correctAnswers)
        let presenter = ResultPresenter(result: results,
                                        questions: questions,
                                        correctAnswers: correctAnswers)
        let controller = sut.resultViewController(for: results) as! ResultViewController
        return (controller,presenter)
    }
}
