import Foundation

class Data: NSObject {
    var colors: [String]
    
    override init() {
        colors = []
    }
    
    func addColor(_ color: String) {
        colors.append(color)
    }
}
