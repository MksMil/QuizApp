import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTests: XCTestCase{
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_routeToQuestions_showsQuestionControllers(){
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
 
        factory.stub(question: Question.singleSelection("Q1"), controller: firstViewController)
        sut.routeTo(question: Question.singleSelection("Q1"), answerCallback: { _ in })
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
       
        
        factory.stub(question: Question.singleSelection("Q2"), controller: secondViewController)
        sut.routeTo(question: Question.singleSelection("Q2"), answerCallback: {_ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentQustionControllerWithRighrcallback(){
        var answerCallbackFired = false
        
        sut.routeTo(question: Question.singleSelection("Q1"), answerCallback: { _ in answerCallbackFired = true })
        factory.stubbedCallbacks[Question.singleSelection("Q1")]!([" "])
        
        XCTAssertTrue(answerCallbackFired)
    }
    
    func test_routeToResult_showsResultViewController(){
        let firstViewController = UIViewController()
        let result = Result(answers: [Question.singleSelection("Q1"):["A1"]], score: 1)
 
        factory.stub(result: result, controller: firstViewController)
        sut.routeTo(result: result)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
    }
}

class ViewControllerFactoryStub: ViewControllerFactory{
    
    var stubbedResults = [Result<Question<String>,[String]>: UIViewController]()
    private var stubbedQuestions = [Question<String>: UIViewController]()
    var stubbedCallbacks = [Question<String>: ([String])->Void]()
    
    func stub(question: Question<String>, controller: UIViewController){
        stubbedQuestions[question] = controller
    }
    func stub(result: Result<Question<String>,[String]>, controller: UIViewController){
        stubbedResults[result] = controller
    }
    
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        stubbedCallbacks[question] = answerCallback
        return stubbedQuestions[question] ?? UIViewController()
    }
    func resultViewController(for result: Result<QuizApp.Question<String>, [String]>) -> UIViewController {
        return stubbedResults[result]!
    }
}

class NonAnimatedNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}
extension Result: Hashable{
    
    public static func == (lhs: QuizEngine.Result<Question, Answer>, rhs: QuizEngine.Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
    
    public func hash(into hasher: inout Hasher) {
//        hasher.combine(answers)
        hasher.combine(score)
    }
    
}
