//
//  TableViewHelper.swift
//  QuizAppTests
//
//  Created by Миляев Максим on 29.03.2023.
//

import UIKit

extension UITableView {
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
