// For watchOS
import SwiftUI

struct ContentView: View {
    //@ObservableObject var viewModel: ViewModel
    //@State var colors: [String] = []
    
    let viewModel = ViewModel(connectionProvider: ConnectionProvider())

    var body: some View {
        NavigationView {
            VStack {
                Text("Watch Color List").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                    Text("See color list")
                }
                    .padding(50)
            }
        }
        /*
            .onAppear() {
                viewModel.connectionProvider.connect()
                colors = viewModel.connectionProvider.receivedColors
            }
         */
    }
}
