import Foundation

enum Question<T: Hashable>:Hashable{
    case singleSelection(T)
    case multipleSelection(T)
    
    func hash(into hasher: inout Hasher) {
        switch self{
        case .singleSelection(let a):
            hasher.combine(a)
        case .multipleSelection(let a):
            hasher.combine(a)
        }
    }
    
    static func == (lhs:Question<T>,
                    rhs:Question<T>)->Bool{
        switch (lhs, rhs){
        case (.singleSelection(let a), .singleSelection(let b)):
            return a == b
        case (.multipleSelection(let a), .multipleSelection(let b)):
            return a == b
        default:
            return false
        }
    }
}
