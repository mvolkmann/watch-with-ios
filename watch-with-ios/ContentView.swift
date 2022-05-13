// For iOS
import SwiftUI

struct ContentView: View {
    let connectionProvider = ConnectionProvider()
    let viewModel: ViewModel
    
    init() {
        viewModel = ViewModel(connectionProvider: connectionProvider)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Phone App").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                    Text("View Colors")
                }
                Spacer()
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
