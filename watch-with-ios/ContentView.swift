// For iOS
import SwiftUI

struct ContentView: View {
    let connectionProvider = ConnectionProvider()
    let viewModel: ViewModel
    
    init() {
        viewModel = ViewModel(connectionProvider: connectionProvider)
    }
    
    func sendMessage() {
        let session = connectionProvider.session
        if !session.isReachable {
            print("ContentView.sendMessage: session not reachable")
            print("Perhaps the watch app is not currently running.")
            return
        }
        
        let message = "from phone"
        do {
            let bytes = try NSKeyedArchiver.archivedData(
                withRootObject: message,
                requiringSecureCoding: true
            )
            connectionProvider.send(message: ["message": bytes])
        } catch {
            print("ContentView.sendMessage: error \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Phone App").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                    Text("View Colors")
                }
                Button("Send to Watch", action: sendMessage)
                    .buttonStyle(.borderedProminent)
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
