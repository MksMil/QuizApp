//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Миляев Максим on 23.03.2023.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    let router = RouterSpy()

    func test_start_withNoQuestion_doesNotRouteToQuestion(){
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion(){
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion_2(){
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion(){
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice(){
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions, ["Q1","Q1"])
    }
    
    func test_startAndAnswerFirstQusestion_routesToSecondQuestion(){
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1","Q2"])
    }
    
    func test_startAndAnswerFirstQusestion_withOneQuestion_doesnotRoutesToAnotherQuestion(){
        let sut = makeSUT(questions: ["Q1"])

        sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    //results
    func test_start_withNoQuestion_routesToResult(){
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResults!, [:])
    }
    
    func test_startAndAnswerFirstandSecondQusestion_withTwoQuestion_routesToResult(){
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResults!, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startWithOneQusestion_doesnotRoutesToResult(){
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertNil(router.routedResults)
    }
    
    func test_startWithTwoQusestion_answerFirstQuestion_doesnotRoutesToResult(){
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        
        router.answerCallback("A1")
        
        XCTAssertNil(router.routedResults)
    }
    
    // MARK: - Helper
    func makeSUT(questions: [String]) -> Flow{
        return Flow(questions: questions, router: router)
    }
    
    class RouterSpy: Router{
        var routedQuestions: [String] = []
        var answerCallback: Router.AnswerCallback = { _ in }
        var routedResults: [String:String]? = nil
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback){
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        func routeTo(result: [String : String]) {
            routedResults = result
        }
    }
}
