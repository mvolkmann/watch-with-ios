// For watchOS
import SwiftUI

struct ContentView: View {
    let viewModel = ViewModel(connectionProvider: ConnectionProvider())

    var body: some View {
        NavigationView {
            VStack {
                Text("Watch App").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                    Text("View Colors")
                }
            }
        }
    }
}
