// For watchOS
import SwiftUI

struct ContentView: View {
    //@ObservableObject var viewModel: ViewModel
    //@State var colors: [String] = []
    
    let viewModel = ViewModel(connectionProvider: ConnectionProvider())

    var body: some View {
        NavigationView {
            VStack {
                Text("Watch App").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                    Text("View Colors")
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
