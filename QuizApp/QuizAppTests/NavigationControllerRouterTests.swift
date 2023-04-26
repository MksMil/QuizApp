import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTests: XCTestCase{
    
    let singleAnswerQuestion = Question.singleSelection("Q1")
    let multipleAnswerQuestion = Question.multipleSelection("Q1")
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_routeToQuestions_showsQuestionControllers(){
        let firstViewController = UIViewController()
        let secondViewController = UIViewController()
 
        factory.stub(question: singleAnswerQuestion, controller: firstViewController)
        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in })
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
       
        factory.stub(question: multipleAnswerQuestion, controller: secondViewController)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_singleAnswer_answerCallback_progressToNextQuestion(){
        var answerCallbackFired = false
        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in answerCallbackFired = true })
        factory.stubbedCallbacks[singleAnswerQuestion]!([" "])
        XCTAssertTrue(answerCallbackFired)
    }
    
    func test_routeToQuestion_multipleAnswers_answerCallback_doesNotProgressToNextQuestion(){
        var answerCallbackFired = false
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in answerCallbackFired = true })
        factory.stubbedCallbacks[multipleAnswerQuestion]!([" "])
        XCTAssertFalse(answerCallbackFired)
    }
    
    func test_routeToQuestionWithMultipleAnswers_configureViewControllerWithSubmitButton(){
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, controller: viewController)
        sut.routeTo(question: multipleAnswerQuestion) { _ in }
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
//--- SubmitButton
    func test_routeToQuestionWithSingleAnswers_doesNotConfigureControllerWthSubmitButton(){
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, controller: viewController)
        sut.routeTo(question: singleAnswerQuestion) { _ in }
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestionWithMultipleAnswers_configureControllerWthSubmitButton(){
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, controller: viewController)
        sut.routeTo(question: multipleAnswerQuestion) { _ in }
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestionWithMultipleAnswers_submitButton_isDisabledWhenZeroAnswersSelected(){
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, controller: viewController)
        sut.routeTo(question: multipleAnswerQuestion) { _ in }
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.stubbedCallbacks[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.stubbedCallbacks[multipleAnswerQuestion]!(["A2","A3"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestionWithMultipleAnswers_submitButton_progressesToNextQuestion(){
        var answerCallbackFired = false
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, controller: viewController)
        sut.routeTo(question: multipleAnswerQuestion) { _ in
            answerCallbackFired = true
        }
        factory.stubbedCallbacks[multipleAnswerQuestion]!(["A2","A3"])
        let button = viewController.navigationItem.rightBarButtonItem!
        //simulate tap on submitButton
        button.simulateTap()
        
        XCTAssertTrue(answerCallbackFired)
        
    }
    
//--- ResultViewController
    func test_routeToResult_showsResultViewController(){
        let firstViewController = UIViewController()
        let result = Result(answers: [singleAnswerQuestion:["A1"]], score: 1)
        factory.stub(result: result, controller: firstViewController)
        sut.routeTo(result: result)
        XCTAssertEqual(navigationController.viewControllers.count, 1)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
    }
}

// MARK: - Helpers
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

//--- simulate tap helper extension
private extension UIBarButtonItem{
    func simulateTap(){
        target!.performSelector(onMainThread: action!,
                                     with: nil,
                                     waitUntilDone: true)
    }
}
