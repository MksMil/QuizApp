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
        let sut = QuestionViewController(question: question,
                                         options: options,
                                         selection: selection)
        _ = sut.view
        return sut
    }
}
private extension UITableView {
    func cell(at row: Int) -> UITableViewCell?{
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func title(at row: Int) -> String?{
        return self.cell(at: row)?.textLabel?.text
    }
    
    func select(row: Int){
        let indPath = IndexPath(row: row, section: 0)
        selectRow(at: indPath, animated: true, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indPath)
    }
    
    func deselect(row: Int){
        let indPath = IndexPath(row: row, section: 0)
        deselectRow(at: indPath, animated: true)
        delegate?.tableView?(self, didDeselectRowAt: indPath)
    }
}
