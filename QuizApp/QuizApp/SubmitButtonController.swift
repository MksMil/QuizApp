import UIKit

class SubmitButtonController: NSObject{
    let button: UIBarButtonItem
    var model: [String] = []
    let callBack: ([String]) -> Void
    
    init(button: UIBarButtonItem, callback: @escaping ([String])->Void ) {
        self.button = button
        self.callBack = callback
        super.init()
        setup()
    }
    
    private func setup(){
        button.target = self
        button.action = #selector(fireCallback)
        updateState()
    }
    
    func update(_ model: [String]){
        self.model = model
        updateState()
    }
    
    private func updateState(){
        button.isEnabled = model.count > 1
    }
    
    @objc private func fireCallback(){
        callBack(model)
    }
}
