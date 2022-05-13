import SwiftUI

class Model: ObservableObject {
    @Published var data = MyData()
    @Published var message = ""
}
