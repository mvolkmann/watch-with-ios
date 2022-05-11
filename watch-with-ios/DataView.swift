import SwiftUI

struct DataView: View {
    @ObservedObject var viewModel: ViewModel
    @State var colors: [String] = []
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Color List").font(.title)
            List {
                ForEach(colors, id: \.self) { color in
                    Text(color)
                }
            }
        }
        .onAppear() {
            viewModel.connectionProvider.connect()
            viewModel.connectionProvider.setup()
            colors = viewModel.connectionProvider.colors
        }
    }
}
