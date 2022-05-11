// For watchOS
import SwiftUI

struct ContentView: View {
    @ObservableObject var viewModel: ViewModel
    @State var colors: [String] = []
    
    let viewModel: ViewModel(connectionProvider: ConnectionProvider())

    var body: some View {
        NavigationView {
            VStack {
                Text("Watch Color List").font(.title)
                NavigationLink(destination: DataView(viewModel: viewModel)) {
                    Text("See color list")
                }
                    .padding(50)
            }
        }
            .onAppear() {
                viewModel.connectionProvider.connect()
                colors = viewModel.connectionProvider.receivedColors
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
