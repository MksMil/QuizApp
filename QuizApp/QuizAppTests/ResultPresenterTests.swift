import XCTest
import Foundation
@testable import QuizApp
import QuizEngine

class ResultPresenterTests: XCTestCase {
    func test_summary_withTwoQuestionAndScoresOne_returnSummary(){
        let answers = [Question.singleSelection("Q1"): ["A1"],
                       Question.singleSelection("Q2"): ["A2"]]
        let result = Result(answers: answers,
                            score: 1)
        let sut = ResultPresenter(result: result,correctAnswers: [:])
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }

    func test_summary_withThreeQuestionAndScoresTwo_returnSummary(){
        let answers = [Question.singleSelection("Q1"): ["A1"],
                       Question.multipleSelection("Q2"): ["A2","A21","A22"],
                       Question.singleSelection("Q3"): ["A3"]]
        let result = Result(answers: answers,
                            score: 2)
        let sut = ResultPresenter(result: result,correctAnswers: [:])
        
        XCTAssertEqual(sut.summary, "You got 2/3 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty(){
        let answers = [Question<String>:[String]]()
        let result = Result(answers: answers, score: 0)
        let sut = ResultPresenter(result: result,correctAnswers: [:])

        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }
    
    func test_presentableAnswers_withOneSingleWrongAnswer_mapsAnswers(){
        let answers = [Question.singleSelection("Q1"): ["A1"]]
        let correctAnswers = [Question.singleSelection("Q1"): ["A2"]]
        let result = Result(answers: answers, score: 0)
        
        let sut = ResultPresenter(result: result,correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first?.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withMultipleWrongAnswers_mapsAnswers(){
        let answers = [Question.multipleSelection("Q1"): ["A1","A4"]]
        let correctAnswers = [Question.multipleSelection("Q1"): ["A2","A3"]]
        let result = Result(answers: answers, score: 0)
        
        let sut = ResultPresenter(result: result,correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }

    func test_presentableAnswers_withOneSinglRightAnswer_mapsAnswers(){
        let answers = [Question.singleSelection("Q1"): ["A1"]]
        let correctAnswers = [Question.singleSelection("Q1"): ["A1"]]
        let result = Result(answers: answers, score: 1)
        
        let sut = ResultPresenter(result: result,correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)
    }
    
    func test_presentableAnswers_withMultipleRightAnswers_mapsAnswers(){
        let answers = [Question.multipleSelection("Q1"): ["A1","A2"]]
        let correctAnswers = [Question.multipleSelection("Q1"): ["A1","A2"]]
        let result = Result(answers: answers, score: 1)
        
        let sut = ResultPresenter(result: result,correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
    }
}
