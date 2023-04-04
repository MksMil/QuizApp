import Foundation
import XCTest
@testable import QuizApp

class ResultsViewcontrollerTests: XCTestCase{
    
    func test_viewDidLoad_loadsSummaryHeader() {
        XCTAssertEqual(makeSUT(summary: "a summary").headerLabel.text, "a summary")
    }
    
    func test_viewDidLoad_rendersAnswers() {
        XCTAssertEqual(makeSUT().tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer()]).tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewdidLoad_withCorrectAnswer_renderCorrectCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1",answer: "A1")])
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }

    func test_viewdidLoad_withWrongAnswer_renderWrongCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1",answer: "A1",wrongAnswer: "wrong")])
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswer.text, "wrong")
    }
    
    // MARK: - Helpers
    func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultViewController{
        let sut = ResultViewController(summary: summary,answers: answers)
        _ = sut.view
        return sut
    }
    
    func makeAnswer(question: String = "",answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer{
        return PresentableAnswer(question: question,answer: answer, wrongAnswer: wrongAnswer)
    }
}
