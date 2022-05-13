// For watchOS
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
            print("Perhaps the phone app is not currently running.")
            return
        }
        
        let message = "from watch"
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
                Text("Watch App").font(.title)
                NavigationLink(destination: MyDataView(viewModel: viewModel)) {
                    Text("View Colors")
                }
                Button("Send to Phone", action: sendMessage)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}
