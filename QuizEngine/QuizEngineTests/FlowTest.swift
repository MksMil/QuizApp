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
        XCTAssertEqual(router.routedResults!.answers, [:])
    }
    
    func test_startAndAnswerFirstandSecondQusestion_withTwoQuestion_routesToResult(){
        let sut = makeSUT(questions: ["Q1", "Q2"])

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResults!.answers, ["Q1": "A1", "Q2": "A2"])
    }
    
    func test_startWithOneQusestion_doesnotRoutesToResult(){
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertNil(router.routedResults)
    }
    
    func test_startWithTwoQusestion_answerFirstQuestion_doesNotRoutesToResult(){
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        
        router.answerCallback("A1")
        
        XCTAssertNil(router.routedResults)
    }
    
    //scoring
    
    func test_startWithTwoQuestions_answeringTwoQuestion_scores() {
        let sut = makeSUT(questions: ["Q1","Q2"],scoring: {_ in 10})
        sut.start()
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResults?.score, 10)
    }
    
    func test_startWithTwoQuestion_answeringTwoQuestion_returnRightAnswers(){
        var receivedAnswers:[String:String] = [:]
        let sut = makeSUT(questions: ["Q1","Q2"]) { answers in
            receivedAnswers = answers
            return 10
        }
        
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(receivedAnswers, ["Q1":"A1","Q2":"A2"])
    }
    
    // MARK: - Helper
    func makeSUT(questions: [String],scoring: @escaping ([String:String])->Int = { _ in 10}) -> Flow<String,String,RouterSpy>{
        return Flow(questions: questions, router: router,scoring: scoring)
    }
    
    
}
