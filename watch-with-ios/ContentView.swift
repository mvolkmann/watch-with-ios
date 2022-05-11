// For iOS
import SwiftUI

struct ContentView: View {
    //TODO: Why does this create two instances of ConnectionProvider?
    let viewModel = ViewModel(connectionProvider: ConnectionProvider())
    let connectionProvider = ConnectionProvider()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Phone App").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                    Text("View Colors")
                }
            }
        }
            .onAppear() {
                connectionProvider.connect()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
