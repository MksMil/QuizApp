import Foundation
import QuizEngine

struct ResultPresenter {
    let result: Result<Question<String>, [String]>
    let questions: [Question<String>]
    let correctAnswers: [Question<String>: [String]]
    var summary: String {
        "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { question in
            guard let userAnswer = result.answers[question],
                  let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find correct answer for question \(question)")
            }
            return presentableAnswer(question: question,
                                     userAnswer: userAnswer,
                                     correctAnswer: correctAnswer)
        }
    }
    
    private func presentableAnswer(question: Question<String>,
                                   userAnswer: [String],
                                   correctAnswer: [String]) -> PresentableAnswer{
        switch question {
        case .singleSelection(let value), .multipleSelection(let value):
            return PresentableAnswer(question: value,
                                     answer: formattedAnswer(correctAnswer),
                                     wrongAnswer: formattedWrongAnswer(correctAnswer,
                                                                       userAnswer))
        }
    }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ correctAnswer: [String],
                                      _ userAnswer: [String]) -> String? {
        return correctAnswer == userAnswer ?
        nil: formattedAnswer(userAnswer)
    }
}

