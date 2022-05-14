import SwiftUI

class Model: ObservableObject {
    static let instance = Model()
    
    @Published var data = MyData()
    @Published var message = ""
}
