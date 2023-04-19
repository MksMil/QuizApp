//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Миляев Максим on 24.03.2023.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase{
    
    func test_viewDidLoad_rendersQuestionHeadersText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withOptions_rendersOptions() {
        XCTAssertEqual(makeSUT().tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1","A2"]).tableView.numberOfRows(inSection: 0), 2)
        XCTAssertEqual(makeSUT(options: ["A1","A2","A3"]).tableView.numberOfRows(inSection: 0), 3)
    }
    
    func test_viewDidLoad_withOptions_rendersOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1","A2"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1","A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_withTwoOptions_optionSelected_notifiesDelegateLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1","A2"]){
            receivedAnswer = $0
        }

        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_withTwoOptions_optionDeselected_doNotNotifiesDelegate() {
        var callbackCount: Int = 0
        let sut = makeSUT(options: ["A1","A2"]){ _ in
            callbackCount += 1
        }

        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }

    
    func test_withTwoOptions_optionSelected_withMultipleSelectionEnabled_notifiesDelegateLastSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1","A2"]){
            receivedAnswer = $0
        }
        sut.tableView.allowsMultipleSelection = true

        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1","A2"])
    }
    
    func test_withMultipleSelection_optionDeselected_notifiesDelegateNoSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1","A2"]){ receivedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true

        sut.tableView.select(row: 0)
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK: - Helpers
    
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: (@escaping([String]) -> Void) = { _ in }) -> QuestionViewController{
        let question = Question.singleSelection(question)
        let factory = iOSViewControllerFactory(questions:[question] ,options: [question: options])
        let sut = factory.questionViewController(question: question, answerCallback: selection) as! QuestionViewController
        _ = sut.view
        return sut
    }
}
