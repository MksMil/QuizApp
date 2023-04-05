import UIKit
import XCTest
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
 
        factory.stub(question: "Q1", controller: firstViewController)
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
       
        
        factory.stub(question: "Q2", controller: secondViewController)
        sut.routeTo(question: "Q2", answerCallback: {_ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentQustionControllerWithRighrcallback(){
        var answerCallbackFired = false
        
        sut.routeTo(question: "Q1", answerCallback: { _ in answerCallbackFired = true })
        factory.stubbedCallbacks["Q1"]!(" ")
        
        XCTAssertTrue(answerCallbackFired)
    }
}

class ViewControllerFactoryStub: ViewControllerFactory{
    
    private var stubbedQuestions = [String: UIViewController]()
    var stubbedCallbacks = [String: (String)->Void]()
    
    func stub(question: String, controller: UIViewController){
        stubbedQuestions[question] = controller
    }
    
    func questionViewController(question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
        stubbedCallbacks[question] = answerCallback
        return stubbedQuestions[question] ?? UIViewController()
    }
}

class NonAnimatedNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}
