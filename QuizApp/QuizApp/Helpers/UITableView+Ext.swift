import UIKit

extension UITableView{
    func registerCell(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil),
                 forCellReuseIdentifier: className)
    }
    
    func dequeueReusableCellFor<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier:className) as? T
    }
}
