import Foundation
import XCTest
import QuizEngine

class GameTest: XCTestCase{
    
    var game: Game<String, String, RouterSpy>!
    let router = RouterSpy()
    
    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1","Q2"],router: router, correctAnswers: ["Q1":"A1","Q2":"A2"])
    }
    
    func test_startGame_withTwoQuestion_zeroRightAnswer_scoringZero(){
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        XCTAssertEqual(router.routedResults?.score, 0)
    }
    func test_startGame_withTwoQuestion_oneRightAnswer_scoringOne(){
        router.answerCallback("A1")
        router.answerCallback("wrong")
        XCTAssertEqual(router.routedResults?.score, 1)
    }
    func test_startGame_withTwoQuestion_twoRightAnswer_scoringTwo(){
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResults?.score, 2)
    }
}
