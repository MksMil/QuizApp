import UIKit

class ResultViewController: UIViewController{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var summary = ""
    var answers = [PresentableAnswer]()
    
    convenience init(summary: String, answers: [PresentableAnswer] = []){
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCell(CorrectAnswerCell.self)
        tableView.registerCell(WrongAnswerCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        headerLabel.text = summary
    }
}

// MARK: - UITableViewDelegate

extension ResultViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

// MARK: - UITableViewDataSource
extension ResultViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.wrongAnswer == nil {
            return makeCorrectCell(for: answers[indexPath.row])
        } else {
            return makeWrongCell(for: answers[indexPath.row])
        }
    }
    
    private func makeCorrectCell(for answer: PresentableAnswer) -> CorrectAnswerCell{
        let cell = tableView.dequeueReusableCellFor(CorrectAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
    }
    
    private func makeWrongCell(for answer: PresentableAnswer) -> WrongAnswerCell{
        let cell = tableView.dequeueReusableCellFor(WrongAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        cell.wrongAnswer.text = answer.wrongAnswer
        return cell
    }
}
