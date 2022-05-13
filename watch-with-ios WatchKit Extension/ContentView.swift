// For watchOS
import SwiftUI

struct ContentView: View {
    // @EnvironmentObject var model: Model

    let connectionProvider: ConnectionProvider
    let model: Model
    let viewModel: ViewModel

    init(model: Model) {
        self.model = model
        connectionProvider = ConnectionProvider(model: model)
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
            // TODO: Why does this give the error
            // TODO: "WCSession iOS app not installed"?
            connectionProvider.send(message: ["text": bytes])
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
                Text("From phone: \(model.message)")
            }
        }
        .onAppear {
            connectionProvider.connect()
            let reachable = connectionProvider.session.isReachable
            print("session reachable? \(reachable)")
        }
    }
}
