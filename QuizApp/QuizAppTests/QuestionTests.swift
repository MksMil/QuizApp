import Foundation
import XCTest
@testable import QuizApp

class Questiontests: XCTestCase{
    
    //Hashable
    func test_hashValue_singleAnswer_returnsTypeHash(){
        let type = "a string"
        let sut = Question.singleSelection(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnsTypeHash(){
        let type = "a string"
        let sut = Question.multipleSelection(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    //Equatable
    func test_equal_answer_isEqual(){
        XCTAssertEqual(Question.singleSelection("a string"), Question.singleSelection("a string"))
        XCTAssertEqual(Question.multipleSelection("a string"), Question.multipleSelection("a string"))
    }
    
    func test_notEqual_answer_isNotEqual(){
        XCTAssertNotEqual(Question.singleSelection("a string"), Question.singleSelection("another string"))
        XCTAssertNotEqual(Question.multipleSelection("a string"), Question.multipleSelection("another string"))
        XCTAssertNotEqual(Question.singleSelection("a string"), Question.multipleSelection("a string"))
        XCTAssertNotEqual(Question.multipleSelection("a string"), Question.singleSelection("a string"))
    }
    
}
