//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Миляев Максим on 24.03.2023.
//

import UIKit

class QuestionViewController: UIViewController{
    
    private let reuseIdentifier = "Cell"
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    private var question = ""
    private var options = [String]()
    private var selection: ((String) -> Void)? = nil
    
    convenience init(question: String, options: [String], selection: @escaping (String)->Void){
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = question
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension QuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(at: tableView)
        cell.textLabel?.text = options[indexPath.row]

        return cell
    }
    
    private func dequeueCell(at tableView: UITableView) -> UITableViewCell{
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier){
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    }
}

extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selection?(options[indexPath.row])
    }
}
