import SwiftUI

class Model: ObservableObject {
    @Published var colors: [String] = []
    @Published var message = ""
}
