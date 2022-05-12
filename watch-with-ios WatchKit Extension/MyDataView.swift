import SwiftUI

struct MyDataView: View {
    @ObservedObject var viewModel: ViewModel
    @State var data = MyData()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Color List").font(.title)
            List {
                ForEach(data.colors, id: \.self) { color in
                    Text(color)
                }
            }
        }
        .onAppear() {
            viewModel.connectionProvider.connect()
            // Should this only be called in the iOS app?
            //viewModel.connectionProvider.setup()
            data = viewModel.connectionProvider.data
        }
    }
}
