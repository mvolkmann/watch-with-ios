// For watchOS
import SwiftUI

struct ContentView: View {
    let viewModel = ViewModel(connectionProvider: ConnectionProvider())

    func sendMessage() {
        let session = viewModel.connectionProvider.session
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
            let message = ["message": bytes]
            session.sendMessage(message, replyHandler: nil) { error in
                print("ContentView.sendMessage error: \(error)")
            }
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
