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
    
    func test_optionSelected_notifiesDelegate() {
        var receivedAnswer = ""
        let sut = makeSUT(options: ["A1"]){
            receivedAnswer = $0
        }
        
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(receivedAnswer, "A1")
    }
    
    // MARK: - Helpers
    
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: (@escaping(String) -> Void) = { _ in }) -> QuestionViewController{
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
}
